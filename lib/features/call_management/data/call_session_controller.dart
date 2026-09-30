import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../app/providers.dart';
import '../../../core/constants/telecom_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/gemini_ai_service.dart';
import '../../../core/services/speech_service.dart';
import '../../../core/services/telecom_bridge_service.dart';
import '../../../core/services/tts_service.dart';
import '../domain/call_session_model.dart';

class CallSessionController extends StateNotifier<CallSessionModel?> {
  final Ref _ref;
  final TelecomBridgeService _telecom;
  final GeminiAiService _ai;
  final TextToSpeechService _tts;
  final SpeechService _speech;
  final AppDatabase _db;

  StreamSubscription? _telecomSub;
  Timer? _durationTimer;
  Timer? _streamingTimer;
  final _uuid = const Uuid();

  CallSessionController(this._ref, this._telecom, this._ai, this._tts, this._speech, this._db)
      : super(null) {
    _listenToNativeEvents();
  }

  void _listenToNativeEvents() {
    _telecomSub = _telecom.callEvents.listen((event) {
      final type = event['type'] as String?;
      final data = Map<String, dynamic>.from(event['data'] ?? {});

      if (type == TelecomConstants.eventIncomingCall) {
        final callId = data['callId']?.toString() ?? _uuid.v4();
        final phoneNumber = data['phoneNumber']?.toString() ?? 'Unknown';
        final callerName = data['callerName']?.toString() ?? 'Incoming Caller';
        final isScreened = data['isScreened'] == true;

        startIncomingCall(
          callId: callId,
          phoneNumber: phoneNumber,
          callerName: callerName,
          isScreened: isScreened,
        );
      } else if (type == TelecomConstants.eventCallAnswered) {
        if (state != null && state!.callState != TelecomConstants.stateActive) {
          onCallConnected();
        }
      } else if (type == TelecomConstants.eventCallEnded) {
        if (state != null) {
          endCurrentCall();
        }
      }
    });
  }

  /// Start incoming call session
  void startIncomingCall({
    required String callId,
    required String phoneNumber,
    required String callerName,
    bool isScreened = false,
    bool autoAnswer = true,
  }) {
    final settings = _ref.read(assistantSettingsProvider);

    state = CallSessionModel(
      callId: callId,
      callerName: callerName,
      phoneNumber: phoneNumber,
      startTime: DateTime.now(),
      callState: TelecomConstants.stateRinging,
      isScreened: isScreened,
      handlingMode: settings.aiMode,
      segments: [],
    );

    // If assistant is enabled and auto-answer is desired, answer after short ring
    if (settings.isEnabled && autoAnswer) {
      Timer(const Duration(milliseconds: 1500), () {
        if (state != null && state!.callState == TelecomConstants.stateRinging) {
          answerWithAi();
        }
      });
    }
  }

  /// Answer incoming call via AI
  Future<void> answerWithAi() async {
    if (state == null) return;

    // Answer native call via Telecom bridge
    await _telecom.answerCall(callId: state!.callId);

    onCallConnected();
  }

  /// When call is picked up
  void onCallConnected() {
    if (state == null) return;

    state = state!.copyWith(
      callState: TelecomConstants.stateActive,
      isAiHandling: true,
      isRecordingAudio: true,
    );

    // Start in-call duration counter
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state != null) {
        state = state!.copyWith(durationSeconds: state!.durationSeconds + 1);
      }
    });

    // Deliver AI Greeting
    _speakAiGreeting();
  }

  Future<void> _speakAiGreeting() async {
    if (state == null) return;
    final settings = _ref.read(assistantSettingsProvider);
    final storage = _ref.read(secureStorageServiceProvider);

    final lang = settings.language;
    final greeting = storage.getGreetingMessage(lang);

    _addSegment(speaker: 'ai', text: greeting, language: lang);

    state = state!.copyWith(isAiThinking: false, isAiSpeaking: true);

    // Speak aloud using TTS
    await _tts.speak(greeting, lang);

    if (state != null) {
      state = state!.copyWith(isAiSpeaking: false);
    }

    // After greeting completes, listen for caller's reply
    startListeningToCaller();
  }

  /// Start recording/listening to caller's microphone speech
  void startListeningToCaller() {
    if (state == null || state!.callState != TelecomConstants.stateActive) return;

    _streamingTimer?.cancel();
    state = state!.copyWith(
      isListeningToCaller: true,
      currentSpokenWords: '',
      isAiThinking: false,
      isAiSpeaking: false,
    );

    final settings = _ref.read(assistantSettingsProvider);

    _speech.startListening(
      languageCode: settings.language,
      onResult: (words, isFinal) {
        if (state == null) return;
        state = state!.copyWith(currentSpokenWords: words);

        if (isFinal && words.trim().isNotEmpty) {
          _speech.stopListening();
          state = state!.copyWith(isListeningToCaller: false, currentSpokenWords: '');
          _processCallerSpeech(words.trim());
        }
      },
    );
  }

  /// Manually commit collected words if speech recognition ends
  void stopListeningAndCommit() {
    if (state == null) return;
    _speech.stopListening();
    final words = state!.currentSpokenWords.trim();
    state = state!.copyWith(isListeningToCaller: false, currentSpokenWords: '');
    if (words.isNotEmpty) {
      _processCallerSpeech(words);
    }
  }

  /// Toggle caller microphone input
  Future<void> toggleCallerMic() async {
    if (state == null) return;
    if (state!.isListeningToCaller) {
      stopListeningAndCommit();
    } else {
      startListeningToCaller();
    }
  }

  /// Process caller's speech through AI service
  Future<void> _processCallerSpeech(String speech) async {
    if (state == null) return;

    final settings = _ref.read(assistantSettingsProvider);

    // Add caller's segment to transcript
    _addSegment(speaker: 'caller', text: speech, language: settings.language);

    state = state!.copyWith(
      isAiThinking: true,
      isListeningToCaller: false,
      currentSpokenWords: '',
    );

    final history = state!.segments.map((s) => {'speaker': s.speaker, 'text': s.text}).toList();

    // Call Gemini AI or Local Engine
    final response = await _ai.generateCallTurn(
      userSpeech: speech,
      history: history,
      ownerName: settings.ownerName,
      preferredLanguage: settings.language,
    );

    if (state == null) return;

    _addSegment(
      speaker: 'ai',
      text: response.text,
      language: response.detectedLanguage,
    );

    state = state!.copyWith(isAiThinking: false, isAiSpeaking: true);

    // Speak response
    await _tts.speak(response.text, response.detectedLanguage);

    if (state != null) {
      state = state!.copyWith(isAiSpeaking: false);
    }

    if (response.shouldHangup) {
      Timer(const Duration(seconds: 3), () {
        endCurrentCall();
      });
    } else {
      // Continue listening for next caller turn
      Timer(const Duration(milliseconds: 600), () {
        startListeningToCaller();
      });
    }
  }

  /// Inject caller speech with real-time word-by-word streaming into chat
  void simulateCallerSpeech(String speech, {bool streamWords = true}) {
    if (state == null || state!.callState != TelecomConstants.stateActive) return;
    _speech.stopListening();
    _streamingTimer?.cancel();

    final text = speech.trim();
    if (text.isEmpty) return;

    if (!streamWords) {
      state = state!.copyWith(isListeningToCaller: false, currentSpokenWords: '');
      _processCallerSpeech(text);
      return;
    }

    // Stream words into currentSpokenWords with human speaking pace
    final words = text.split(RegExp(r'\s+'));
    state = state!.copyWith(
      isListeningToCaller: true,
      currentSpokenWords: '',
      isAiThinking: false,
      isAiSpeaking: false,
    );

    int wordIndex = 0;
    _streamingTimer = Timer.periodic(const Duration(milliseconds: 85), (timer) {
      if (state == null || state!.callState != TelecomConstants.stateActive) {
        timer.cancel();
        return;
      }

      wordIndex++;
      final currentSubstr = words.take(wordIndex).join(' ');
      state = state!.copyWith(currentSpokenWords: currentSubstr);

      if (wordIndex >= words.length) {
        timer.cancel();
        Timer(const Duration(milliseconds: 350), () {
          if (state != null && state!.callState == TelecomConstants.stateActive) {
            state = state!.copyWith(isListeningToCaller: false, currentSpokenWords: '');
            _processCallerSpeech(text);
          }
        });
      }
    });
  }

  void _addSegment({required String speaker, required String text, required String language}) {
    if (state == null) return;
    final segment = TranscriptSegmentItem(
      id: _uuid.v4(),
      speaker: speaker,
      text: text,
      timestamp: DateTime.now(),
      language: language,
    );
    state = state!.copyWith(segments: [...state!.segments, segment]);
  }

  Future<void> toggleMute() async {
    if (state == null) return;
    final newMute = !state!.isMuted;
    await _telecom.setMute(newMute);
    state = state!.copyWith(isMuted: newMute);
  }

  Future<void> toggleSpeaker() async {
    if (state == null) return;
    final newSpeaker = !state!.isSpeakerOn;
    await _telecom.setSpeakerphone(newSpeaker);
    state = state!.copyWith(isSpeakerOn: newSpeaker);
  }

  /// End and persist call session, summaries, and reminders
  Future<void> endCurrentCall() async {
    if (state == null) return;

    _durationTimer?.cancel();
    _streamingTimer?.cancel();
    _speech.stopListening();
    _tts.stop();

    await _telecom.endCall(callId: state!.callId);

    final currentSession = state!;
    state = state!.copyWith(callState: TelecomConstants.stateDisconnected);

    // Persist Call Record in SQLite Drift database
    await _persistCallAndSummarize(currentSession);

    // Dismiss session after short delay
    Timer(const Duration(milliseconds: 1500), () {
      state = null;
    });
  }

  Future<void> _persistCallAndSummarize(CallSessionModel session) async {
    final settings = _ref.read(assistantSettingsProvider);

    // 1. Insert CallRecord
    final callRecordCompanion = CallRecordsCompanion.insert(
      id: session.callId,
      phoneNumber: session.phoneNumber,
      callerName: session.callerName,
      startTime: session.startTime,
      endTime: Value(DateTime.now()),
      duration: Value(session.durationSeconds),
      handlingMode: Value(session.handlingMode),
      language: Value(settings.language),
      status: const Value(TelecomConstants.statusAnsweredByAi),
    );
    await _db.insertCall(callRecordCompanion);

    // 2. Insert Transcript Segments
    for (final seg in session.segments) {
      await _db.insertTranscriptSegment(
        TranscriptSegmentsCompanion.insert(
          id: seg.id,
          callId: session.callId,
          speaker: seg.speaker,
          textContent: seg.text,
          timestamp: seg.timestamp,
          language: seg.language,
        ),
      );
    }

    // 3. Generate and Save AI Summary
    final dbSegments = await _db.getTranscriptForCall(session.callId);
    final summaryResult = await _ai.generateSummary(
      callerName: session.callerName,
      phoneNumber: session.phoneNumber,
      durationSeconds: session.durationSeconds,
      segments: dbSegments,
      ownerName: settings.ownerName,
    );

    final summaryCompanion = CallSummariesCompanion.insert(
      id: _uuid.v4(),
      callId: session.callId,
      summary: summaryResult.summary,
      intent: summaryResult.intent,
      priority: Value(summaryResult.priority),
      callbackRequired: Value(summaryResult.callbackRequired),
      callbackTime: Value(summaryResult.callbackTime),
      actionItems: Value(summaryResult.actionItems.join(' | ')),
    );
    await _db.insertOrUpdateSummary(summaryCompanion);

    // 4. If callback required, schedule a reminder
    if (summaryResult.callbackRequired) {
      final reminderTime = DateTime.now().add(const Duration(hours: 2));
      await _db.insertReminder(
        CallbackRemindersCompanion.insert(
          id: _uuid.v4(),
          callId: session.callId,
          callerName: session.callerName,
          phoneNumber: session.phoneNumber,
          reminderTime: reminderTime,
          reminderStatus: const Value('pending'),
          note: Value('Call back regarding ${summaryResult.intent}'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _streamingTimer?.cancel();
    _telecomSub?.cancel();
    super.dispose();
  }
}

final activeCallSessionProvider =
    StateNotifierProvider<CallSessionController, CallSessionModel?>((ref) {
  final telecom = ref.watch(telecomBridgeServiceProvider);
  final ai = ref.watch(geminiAiServiceProvider);
  final tts = ref.watch(ttsServiceProvider);
  final speech = ref.watch(speechServiceProvider);
  final db = ref.watch(databaseProvider);
  return CallSessionController(ref, telecom, ai, tts, speech, db);
});
