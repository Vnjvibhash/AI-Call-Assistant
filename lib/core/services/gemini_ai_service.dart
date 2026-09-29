import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../database/app_database.dart';

class CallAiResponse {
  final String text;
  final String detectedLanguage;
  final String intent;
  final bool callbackRequired;
  final bool shouldHangup;

  CallAiResponse({
    required this.text,
    required this.detectedLanguage,
    required this.intent,
    this.callbackRequired = false,
    this.shouldHangup = false,
  });
}

class CallSummaryResult {
  final String summary;
  final String intent;
  final String priority;
  final bool callbackRequired;
  final DateTime? callbackTime;
  final List<String> actionItems;

  CallSummaryResult({
    required this.summary,
    required this.intent,
    required this.priority,
    required this.callbackRequired,
    this.callbackTime,
    required this.actionItems,
  });
}

class GeminiAiService {
  final String? _apiKey;
  GenerativeModel? _model;

  GeminiAiService({String? apiKey}) : _apiKey = apiKey {
    final key = _apiKey;
    if (key != null && key.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: key,
        generationConfig: GenerationConfig(
          temperature: 0.2,
          maxOutputTokens: 500,
        ),
      );
    }
  }

  bool get isConfigured => _model != null;

  /// Process In-Call Turn: Given caller's speech and conversation history,
  /// generate the next conversational turn in Hindi, English, or Hinglish.
  Future<CallAiResponse> generateCallTurn({
    required String userSpeech,
    required List<Map<String, String>> history,
    required String ownerName,
    String preferredLanguage = 'auto',
  }) async {
    // If no Gemini key is provided, use high-precision local fallback engine
    if (_model == null) {
      return _generateLocalCallTurn(
        userSpeech: userSpeech,
        ownerName: ownerName,
        preferredLanguage: preferredLanguage,
      );
    }

    try {
      final prompt = '''
You are the personal AI phone assistant for $ownerName.
You are currently on a live phone call with a caller.

STRICT CONVERSATIONAL POLICIES:
1. NEVER impersonate $ownerName. Always clearly state you are $ownerName's AI Assistant.
2. Speak concisely (1-2 sentences maximum per turn) so the text-to-speech audio sounds natural and immediate.
3. Language adaptation:
   - If caller speaks Hindi (or Devanagari), respond in polite conversational Hindi.
   - If caller speaks English, respond in professional English.
   - If caller speaks Hinglish (Roman Hindi), respond in natural conversational Hinglish.
4. Identify caller name, purpose of the call, and whether they need a callback.
5. If the caller has stated their message and wants to finish, wrap up politely and set shouldHangup to true.

Conversation History so far:
${history.map((h) => "${h['speaker']}: ${h['text']}").join("\n")}

Caller just said: "$userSpeech"

Respond ONLY with valid JSON in this exact structure:
{
  "response": "Your spoken response to the caller here",
  "language": "hi | en | hinglish",
  "intent": "PROJECT_DISCUSSION | MEETING_REQUEST | CALLBACK_REQUEST | GENERAL_INQUIRY | SPAM",
  "callbackRequired": true/false,
  "shouldHangup": true/false
}
''';

      final response = await _model!.generateContent([Content.text(prompt)]);
      final text = response.text?.trim() ?? '';
      
      // Extract JSON if wrapped in markdown blocks
      String jsonStr = text;
      if (jsonStr.contains('```json')) {
        jsonStr = jsonStr.split('```json')[1].split('```')[0].trim();
      } else if (jsonStr.contains('```')) {
        jsonStr = jsonStr.split('```')[1].split('```')[0].trim();
      }

      final Map<String, dynamic> data = jsonDecode(jsonStr);
      return CallAiResponse(
        text: data['response'] ?? 'Thank you. I will pass your message to $ownerName.',
        detectedLanguage: data['language'] ?? 'en',
        intent: data['intent'] ?? 'GENERAL_INQUIRY',
        callbackRequired: data['callbackRequired'] == true,
        shouldHangup: data['shouldHangup'] == true,
      );
    } catch (e) {
      // Fallback on error
      return _generateLocalCallTurn(
        userSpeech: userSpeech,
        ownerName: ownerName,
        preferredLanguage: preferredLanguage,
      );
    }
  }

  /// Post-Call Summary Generation
  Future<CallSummaryResult> generateSummary({
    required String callerName,
    required String phoneNumber,
    required int durationSeconds,
    required List<TranscriptSegment> segments,
    required String ownerName,
  }) async {
    final transcriptText = segments
        .map((s) => "[${s.speaker.toUpperCase()}]: ${s.textContent}")
        .join("\n");

    if (_model == null) {
      return _generateLocalSummary(
        callerName: callerName,
        transcriptText: transcriptText,
        durationSeconds: durationSeconds,
      );
    }

    try {
      final prompt = '''
Analyze the following phone conversation between $ownerName's AI Assistant and caller "$callerName" ($phoneNumber).
Call Duration: $durationSeconds seconds.

Conversation Transcript:
$transcriptText

Generate a structured summary following this exact JSON format:
{
  "summary": "Concise 2-3 sentence overview of what the caller wanted and what was discussed.",
  "intent": "Brief 2-4 word primary intent (e.g. Project Discussion, Callback Request, Interview, Inquiry)",
  "priority": "urgent | high | medium | low",
  "callbackRequired": true/false,
  "callbackTimeDescription": "Preferred callback time if mentioned or empty string",
  "actionItems": [
    "Specific action item 1",
    "Specific action item 2"
  ]
}
''';

      final response = await _model!.generateContent([Content.text(prompt)]);
      final text = response.text?.trim() ?? '';
      
      String jsonStr = text;
      if (jsonStr.contains('```json')) {
        jsonStr = jsonStr.split('```json')[1].split('```')[0].trim();
      } else if (jsonStr.contains('```')) {
        jsonStr = jsonStr.split('```')[1].split('```')[0].trim();
      }

      final Map<String, dynamic> data = jsonDecode(jsonStr);
      final List<dynamic> actions = data['actionItems'] ?? [];

      return CallSummaryResult(
        summary: data['summary'] ?? 'Call received from $callerName.',
        intent: data['intent'] ?? 'General Inquiry',
        priority: (data['priority'] ?? 'medium').toString().toLowerCase(),
        callbackRequired: data['callbackRequired'] == true,
        actionItems: actions.map((a) => a.toString()).toList(),
      );
    } catch (e) {
      return _generateLocalSummary(
        callerName: callerName,
        transcriptText: transcriptText,
        durationSeconds: durationSeconds,
      );
    }
  }

  /// AI Chat Assistant for querying past calls ("Who called me today?", "Summarize last 3 calls")
  Future<String> queryCallHistory({
    required String userQuery,
    required List<CallRecord> calls,
    required List<CallSummary> summaries,
    required List<CallbackReminder> reminders,
    required String ownerName,
  }) async {
    final contextBuffer = StringBuffer();
    contextBuffer.writeln("Owner Name: $ownerName");
    contextBuffer.writeln("Call Records count: ${calls.length}");
    for (int i = 0; i < calls.length && i < 15; i++) {
      final c = calls[i];
      final summary = summaries.where((s) => s.callId == c.id).firstOrNull;
      contextBuffer.writeln(
        "- Call from: ${c.callerName} (${c.phoneNumber}) at ${c.startTime}. Duration: ${c.duration}s. Status: ${c.status}. Summary: ${summary?.summary ?? 'No summary available'}. Priority: ${summary?.priority ?? 'medium'}. Callback Required: ${summary?.callbackRequired ?? false}",
      );
    }
    contextBuffer.writeln("\nPending Reminders:");
    for (final r in reminders) {
      contextBuffer.writeln(
        "- Reminder for ${r.callerName} (${r.phoneNumber}) at ${r.reminderTime}. Status: ${r.reminderStatus}. Note: ${r.note ?? ''}",
      );
    }

    if (_model == null) {
      return _generateLocalChatAnswer(userQuery, calls, summaries, reminders);
    }

    try {
      final prompt = '''
You are the personal AI phone assistant for $ownerName.
The user is asking you a question about their incoming calls, call summaries, or callback reminders.

User Question: "$userQuery"

Call History & Reminders Database Context:
$contextBuffer

Answer the user's question accurately, concisely, and helpfully in a natural tone.
If they ask for urgent calls, list them clearly. If they ask to summarize recent calls, provide bullet points.
''';

      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text?.trim() ?? "I reviewed your call logs. Let me know what specific details you'd like.";
    } catch (e) {
      return _generateLocalChatAnswer(userQuery, calls, summaries, reminders);
    }
  }

  // --- LOCAL FALLBACK HEURISTICS ---
  CallAiResponse _generateLocalCallTurn({
    required String userSpeech,
    required String ownerName,
    required String preferredLanguage,
  }) {
    final lower = userSpeech.toLowerCase();
    final isHindi = _containsHindi(userSpeech) || preferredLanguage == 'hi';
    final isHinglish = preferredLanguage == 'hinglish' ||
        (lower.contains('hai') || lower.contains('karo') || lower.contains('bol') || lower.contains('bhai'));

    if (lower.contains('urgent') || lower.contains('emergency') || lower.contains('जरूरी')) {
      return CallAiResponse(
        text: isHindi
            ? "मैंने आपकी बात की गंभीरता नोट कर ली है। मैं तुरंत $ownerName को अलर्ट भेज रहा हूँ।"
            : "I have flagged this as urgent and am notifying $ownerName immediately.",
        detectedLanguage: isHindi ? 'hi' : 'en',
        intent: 'URGENT_ALERT',
        callbackRequired: true,
      );
    }

    if (lower.contains('callback') || lower.contains('call back') || lower.contains('कॉल बैक') || lower.contains('call me')) {
      return CallAiResponse(
        text: isHindi
            ? "ज़रूर, मैंने आपका कॉलबैक अनुरोध नोट कर लिया है। $ownerName आपको जल्द ही कॉल करेंगे।"
            : "Understood. I have recorded your callback request. $ownerName will call you back shortly.",
        detectedLanguage: isHindi ? 'hi' : 'en',
        intent: 'CALLBACK_REQUEST',
        callbackRequired: true,
      );
    }

    if (lower.contains('bye') || lower.contains('thank you') || lower.contains('thanks') || lower.contains('धन्यवाद') || lower.contains('अलविदा')) {
      return CallAiResponse(
        text: isHindi
            ? "बात करने के लिए धन्यवाद। आपका दिन शुभ हो! नमस्ते।"
            : "Thank you for calling. Have a wonderful day!",
        detectedLanguage: isHindi ? 'hi' : 'en',
        intent: 'CALL_WRAPUP',
        shouldHangup: true,
      );
    }

    return CallAiResponse(
      text: isHindi
          ? "धन्यवाद। मैंने आपका संदेश दर्ज कर लिया है और $ownerName तक पहुँचा दूँगा।"
          : isHinglish
              ? "Thank you, maine aapka message note kar liya hai aur $ownerName ko bata doonga."
              : "Thank you. I have recorded your message and will pass it to $ownerName.",
      detectedLanguage: isHindi ? 'hi' : (isHinglish ? 'hinglish' : 'en'),
      intent: 'GENERAL_INQUIRY',
    );
  }

  CallSummaryResult _generateLocalSummary({
    required String callerName,
    required String transcriptText,
    required int durationSeconds,
  }) {
    final lower = transcriptText.toLowerCase();
    final isUrgent = lower.contains('urgent') || lower.contains('emergency') || lower.contains('जरूरी');
    final callbackReq = lower.contains('call back') || lower.contains('callback') || lower.contains('call me');

    return CallSummaryResult(
      summary: "Call from $callerName lasting $durationSeconds seconds. Conversation recorded and logged.",
      intent: callbackReq ? "Callback Request" : (isUrgent ? "Urgent Matter" : "General Inquiry"),
      priority: isUrgent ? "urgent" : (callbackReq ? "high" : "medium"),
      callbackRequired: callbackReq,
      actionItems: [
        if (callbackReq) "Call $callerName back today.",
        "Review full conversation transcript.",
      ],
    );
  }

  String _generateLocalChatAnswer(
    String query,
    List<CallRecord> calls,
    List<CallSummary> summaries,
    List<CallbackReminder> reminders,
  ) {
    final lower = query.toLowerCase();
    if (lower.contains('who called') || lower.contains('today')) {
      if (calls.isEmpty) return "You haven't received any calls logged by the assistant yet.";
      final names = calls.take(5).map((c) => "${c.callerName} (${c.phoneNumber})").join(", ");
      return "Here are the recent callers: $names.";
    }
    if (lower.contains('callback') || lower.contains('remind')) {
      final pending = reminders.where((r) => r.reminderStatus == 'pending').toList();
      if (pending.isEmpty) return "You have no pending callback reminders at the moment.";
      return "You have ${pending.length} pending callback request(s): " +
          pending.map((r) => "${r.callerName} (${r.phoneNumber})").join("; ");
    }
    if (lower.contains('urgent')) {
      final urgentSummaries = summaries.where((s) => s.priority == 'urgent' || s.priority == 'high').toList();
      if (urgentSummaries.isEmpty) return "No urgent or high-priority calls were flagged.";
      return "Found ${urgentSummaries.length} high-priority call(s): " +
          urgentSummaries.map((s) => s.summary).join("\n");
    }
    return "I found ${calls.length} total call records in your local database. You can view full transcripts and summaries in the Call History tab.";
  }

  bool _containsHindi(String text) {
    for (int i = 0; i < text.length; i++) {
      final code = text.codeUnitAt(i);
      if (code >= 0x0900 && code <= 0x097F) return true;
    }
    return false;
  }
}
