import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../core/constants/telecom_constants.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/wave_animation.dart';
import '../data/call_session_controller.dart';

class LiveCallScreen extends ConsumerStatefulWidget {
  const LiveCallScreen({super.key});

  @override
  ConsumerState<LiveCallScreen> createState() => _LiveCallScreenState();
}

class _LiveCallScreenState extends ConsumerState<LiveCallScreen> {
  final TextEditingController _speechInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _speechInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeCall = ref.watch(activeCallSessionProvider);

    // If call ended or null, navigate back
    if (activeCall == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.call_end_rounded, color: AppTheme.accentRose, size: 48),
              const SizedBox(height: 16),
              Text(
                'Call Disconnected',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'AI Summary and transcript have been saved to Call History.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Return to Dashboard'),
              ),
            ],
          ),
        ),
      );
    }

    _scrollToBottom();

    final isRinging = activeCall.callState == TelecomConstants.stateRinging;
    final isConnected = activeCall.callState == TelecomConstants.stateActive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          isRinging ? 'Incoming Call Screening' : 'Live AI Call Assistant',
          style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: activeCall.handlingMode == 'local'
                  ? AppTheme.accentEmerald.withOpacity(0.15)
                  : AppTheme.primaryBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              activeCall.handlingMode.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: activeCall.handlingMode == 'local'
                    ? AppTheme.accentEmerald
                    : AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Caller Card & Live Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.surfaceLight,
                          child: const Icon(Icons.person_rounded, size: 28, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeCall.callerName,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                PhoneUtils.formatPhoneNumber(activeCall.phoneNumber),
                                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isConnected
                                    ? AppTheme.accentEmerald.withOpacity(0.15)
                                    : AppTheme.accentAmber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                activeCall.callState,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isConnected ? AppTheme.accentEmerald : AppTheme.accentAmber,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormatter.formatDuration(activeCall.durationSeconds),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // AI Visualizer Waveform & Live Status
                    Row(
                      children: [
                        Expanded(
                          child: WaveAnimation(
                            isAnimating: activeCall.isAiThinking || activeCall.isListeningToCaller,
                            color: activeCall.isAiThinking ? AppTheme.accentRose : AppTheme.accentCyan,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          activeCall.isAiThinking
                              ? 'AI Assistant thinking...'
                              : activeCall.isListeningToCaller
                                  ? 'Listening to caller...'
                                  : 'Assistant speaking...',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: activeCall.isAiThinking
                                ? AppTheme.accentRose
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    if (activeCall.currentSpokenWords.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '"${activeCall.currentSpokenWords}"...',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.accentCyan,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Middle Section: Live Real-Time Transcript Stream
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: AppTheme.surface.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: activeCall.segments.isEmpty
                    ? Center(
                        child: Text(
                          isRinging ? 'Waiting for call answer...' : 'AI assistant is starting conversation...',
                          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: activeCall.segments.length,
                        itemBuilder: (context, index) {
                          final seg = activeCall.segments[index];
                          final isAi = seg.speaker.toLowerCase() == 'ai';

                          return Align(
                            alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.78,
                              ),
                              decoration: BoxDecoration(
                                color: isAi ? AppTheme.primaryBlue.withOpacity(0.2) : AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(12).copyWith(
                                  bottomLeft: isAi ? const Radius.circular(0) : const Radius.circular(12),
                                  bottomRight: !isAi ? const Radius.circular(0) : const Radius.circular(12),
                                ),
                                border: Border.all(
                                  color: isAi ? AppTheme.primaryBlue.withOpacity(0.4) : AppTheme.border,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isAi ? 'AI ASSISTANT' : activeCall.callerName.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isAi ? AppTheme.accentCyan : AppTheme.accentRose,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormatter.formatTime(seg.timestamp),
                                        style: const TextStyle(fontSize: 9, color: AppTheme.textMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    seg.text,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      color: AppTheme.textPrimary,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Quick Speech Injector / Tester Bar (Chips & Input)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildQuickSpeechChip("I want to discuss a project with Vivek", ref),
                        _buildQuickSpeechChip("नमस्ते, मुझे विवेक से जरूरी बात करनी है", ref),
                        _buildQuickSpeechChip("Please ask Vivek to call me back at 6 PM", ref),
                        _buildQuickSpeechChip("Thanks for the info, bye!", ref),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _speechInputController,
                          decoration: InputDecoration(
                            hintText: 'Type or speak caller speech...',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send_rounded, size: 20, color: AppTheme.primaryBlue),
                              onPressed: () {
                                final text = _speechInputController.text.trim();
                                if (text.isNotEmpty) {
                                  ref.read(activeCallSessionProvider.notifier).simulateCallerSpeech(text);
                                  _speechInputController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom In-Call Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: const Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute Button
                  _buildControlAction(
                    icon: activeCall.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: activeCall.isMuted ? 'Unmute' : 'Mute',
                    isActive: activeCall.isMuted,
                    onTap: () => ref.read(activeCallSessionProvider.notifier).toggleMute(),
                  ),

                  // Speakerphone Button
                  _buildControlAction(
                    icon: activeCall.isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                    label: 'Speaker',
                    isActive: activeCall.isSpeakerOn,
                    onTap: () => ref.read(activeCallSessionProvider.notifier).toggleSpeaker(),
                  ),

                  // Hangup / End Call Button
                  GestureDetector(
                    onTap: () => ref.read(activeCallSessionProvider.notifier).endCurrentCall(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'End Call',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accentRed),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSpeechChip(String text, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 11)),
        backgroundColor: AppTheme.surfaceLight,
        side: const BorderSide(color: AppTheme.border),
        onPressed: () {
          ref.read(activeCallSessionProvider.notifier).simulateCallerSpeech(text);
        },
      ),
    );
  }

  Widget _buildControlAction({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryBlue : AppTheme.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(color: isActive ? AppTheme.primaryBlue : AppTheme.border),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : AppTheme.textPrimary,
              size: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isActive ? AppTheme.primaryBlue : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
