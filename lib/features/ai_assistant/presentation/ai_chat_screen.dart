import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/date_formatter.dart';

class ChatMessageItem {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageItem({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;

  final List<ChatMessageItem> _messages = [
    ChatMessageItem(
      id: 'init_1',
      text:
          "Hello Vivek! I am your AI Phone Assistant. Ask me anything about your incoming calls, pending callbacks, or urgent messages.",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  final List<String> _suggestedPrompts = [
    "Who called me today?",
    "Summarize my last three calls",
    "Who requested a callback?",
    "Show me urgent calls",
  ];

  void _sendMessage(String query) async {
    if (query.trim().isEmpty || _isProcessing) return;

    final userMsg = ChatMessageItem(
      id: const Uuid().v4(),
      text: query.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isProcessing = true;
    });
    _inputController.clear();
    _scrollToBottom();

    final db = ref.read(databaseProvider);
    final aiService = ref.read(geminiAiServiceProvider);
    final settings = ref.read(assistantSettingsProvider);

    // Fetch context from database
    final calls = await db.getRecentCalls(limit: 15);
    final List<CallSummary> summaries = [];
    for (final c in calls) {
      final s = await db.getSummaryForCall(c.id);
      if (s != null) summaries.add(s);
    }
    final reminders = await db.getAllReminders();

    // Generate AI response
    final responseText = await aiService.queryCallHistory(
      userQuery: query,
      calls: calls,
      summaries: summaries,
      reminders: reminders,
      ownerName: settings.ownerName,
    );

    final aiMsg = ChatMessageItem(
      id: const Uuid().v4(),
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    if (mounted) {
      setState(() {
        _messages.add(aiMsg);
        _isProcessing = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: AppTheme.primaryBlue, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('AI Call Concierge'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat message list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.82,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isUser ? AppTheme.primaryBlue : AppTheme.surface,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomRight: msg.isUser ? const Radius.circular(0) : const Radius.circular(16),
                          bottomLeft: !msg.isUser ? const Radius.circular(0) : const Radius.circular(16),
                        ),
                        border: Border.all(
                          color: msg.isUser ? AppTheme.primaryBlue : AppTheme.border,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.text,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: msg.isUser ? Colors.white : AppTheme.textPrimary,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormatter.formatTime(msg.timestamp),
                            style: TextStyle(
                              fontSize: 9.5,
                              color: msg.isUser ? Colors.white70 : AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isProcessing) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppTheme.primaryBlue)),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'AI Assistant querying database...',
                      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ],

            // Suggested prompt chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _suggestedPrompts.map((prompt) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ActionChip(
                        label: Text(prompt, style: const TextStyle(fontSize: 11.5)),
                        backgroundColor: AppTheme.surface,
                        side: const BorderSide(color: AppTheme.border),
                        onPressed: () => _sendMessage(prompt),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Input Bar
            Container(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 88,
              ),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        hintText: 'Ask about callers, callbacks, summaries...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppTheme.primaryBlue),
                    onPressed: () => _sendMessage(_inputController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
