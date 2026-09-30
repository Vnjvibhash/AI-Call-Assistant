import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../domain/call_session_model.dart';

class LiveCallScreen extends ConsumerStatefulWidget {
  const LiveCallScreen({super.key});

  @override
  ConsumerState<LiveCallScreen> createState() => _LiveCallScreenState();
}

class _LiveCallScreenState extends ConsumerState<LiveCallScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _speechInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speechInputController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                'AI Summary and live transcript have been saved to Call History.',
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
                  ? AppTheme.accentEmerald.withValues(alpha: 0.15)
                  : AppTheme.primaryBlue.withValues(alpha: 0.15),
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
            // Top Section: Caller Card, Live Recording Badge & Waveform
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.surfaceLight,
                          child: Icon(Icons.person_rounded, size: 28, color: AppTheme.textPrimary),
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Call State Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isConnected
                                        ? AppTheme.accentEmerald.withValues(alpha: 0.15)
                                        : AppTheme.accentAmber.withValues(alpha: 0.15),
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
                                if (isConnected) ...[
                                  const SizedBox(width: 6),
                                  // Audio Recording Badge
                                  _buildRecBadge(activeCall),
                                ],
                              ],
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

                    // Visualizer Waveform & Live Status Bar
                    Row(
                      children: [
                        Expanded(
                          child: WaveAnimation(
                            isAnimating: activeCall.isAiThinking ||
                                activeCall.isListeningToCaller ||
                                activeCall.isAiSpeaking,
                            color: activeCall.isListeningToCaller
                                ? AppTheme.accentRose
                                : (activeCall.isAiThinking
                                    ? AppTheme.accentAmber
                                    : AppTheme.accentCyan),
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          activeCall.isListeningToCaller
                              ? (activeCall.currentSpokenWords.isNotEmpty
                                  ? 'Transcribing caller speech...'
                                  : 'Listening to caller audio...')
                              : (activeCall.isAiThinking
                                  ? 'AI Assistant thinking...'
                                  : (activeCall.isAiSpeaking
                                      ? 'Assistant speaking...'
                                      : 'Call connected')),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: activeCall.isListeningToCaller
                                ? AppTheme.accentRose
                                : (activeCall.isAiThinking
                                    ? AppTheme.accentAmber
                                    : AppTheme.accentCyan),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Middle Section: Live Real-Time Transcript Stream
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: AppTheme.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: _buildTranscriptStream(activeCall),
              ),
            ),

            // Quick Speech Injector / Tester Bar (Chips & Interactive Controls)
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
                        _buildQuickSpeechChip("Payment के regarding बात करनी थी", ref),
                        _buildQuickSpeechChip("Thanks for the info, bye!", ref),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Interactive Caller Microphone Toggle Button
                      _buildCallerMicButton(activeCall),
                      const SizedBox(width: 8),
                      // Text Input Field for custom caller speech
                      Expanded(
                        child: TextField(
                          controller: _speechInputController,
                          decoration: InputDecoration(
                            hintText: 'Type caller words (streams in real-time)...',
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
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border)),
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

  Widget _buildRecBadge(CallSessionModel activeCall) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = _pulseController.value;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.accentRed.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppTheme.accentRed.withValues(alpha: 0.4 + (pulse * 0.6)),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'REC',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentRed,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCallerMicButton(CallSessionModel activeCall) {
    final isListening = activeCall.isListeningToCaller;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = _pulseController.value;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              ref.read(activeCallSessionProvider.notifier).toggleCallerMic();
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isListening
                      ? [
                          AppTheme.accentRed.withValues(alpha: 0.3 + (pulse * 0.2)),
                          AppTheme.accentRose.withValues(alpha: 0.4 + (pulse * 0.2)),
                        ]
                      : [
                          AppTheme.surfaceLight,
                          AppTheme.surface,
                        ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isListening
                      ? AppTheme.accentRed.withValues(alpha: 0.8)
                      : AppTheme.border,
                  width: isListening ? 1.5 : 1.0,
                ),
                boxShadow: isListening
                    ? [
                        BoxShadow(
                          color: AppTheme.accentRed.withValues(alpha: 0.3 * pulse),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    size: 18,
                    color: isListening ? Colors.white : AppTheme.accentRose,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isListening ? 'Send Voice' : 'Speak as Caller',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isListening ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTranscriptStream(CallSessionModel activeCall) {
    final showCallerActive = activeCall.isListeningToCaller || activeCall.currentSpokenWords.isNotEmpty;
    final showAiThinking = activeCall.isAiThinking;

    final totalItems = activeCall.segments.length +
        (showCallerActive ? 1 : 0) +
        (showAiThinking ? 1 : 0);

    if (totalItems == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.record_voice_over_rounded, size: 36, color: AppTheme.primaryBlue),
            const SizedBox(height: 12),
            Text(
              activeCall.callState == TelecomConstants.stateRinging
                  ? 'Waiting for call answer...'
                  : 'AI assistant is starting conversation...',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        // 1. Committed segments
        if (index < activeCall.segments.length) {
          final seg = activeCall.segments[index];
          final isAi = seg.speaker.toLowerCase() == 'ai';
          final isLatestAiSpeaking = isAi &&
              activeCall.isAiSpeaking &&
              index == activeCall.segments.length - 1;

          return _buildCommittedBubble(
            seg: seg,
            isAi: isAi,
            callerName: activeCall.callerName,
            isSpeaking: isLatestAiSpeaking,
          );
        }

        // 2. Active Caller Live Transcribing Bubble
        if (showCallerActive && index == activeCall.segments.length) {
          return _buildLiveCallerTranscribingBubble(activeCall);
        }

        // 3. Active AI Formulating Bubble
        return _buildLiveAiThinkingBubble();
      },
    );
  }

  Widget _buildCommittedBubble({
    required TranscriptSegmentItem seg,
    required bool isAi,
    required String callerName,
    required bool isSpeaking,
  }) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isAi
              ? AppTheme.primaryBlue.withValues(alpha: 0.18)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14).copyWith(
            bottomLeft: isAi ? const Radius.circular(2) : const Radius.circular(14),
            bottomRight: !isAi ? const Radius.circular(2) : const Radius.circular(14),
          ),
          border: Border.all(
            color: isAi
                ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                : AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAi ? 'AI ASSISTANT' : callerName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isAi ? AppTheme.accentCyan : AppTheme.accentRose,
                  ),
                ),
                if (isSpeaking) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppTheme.accentCyan.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.volume_up_rounded, size: 10, color: AppTheme.accentCyan),
                        const SizedBox(width: 3),
                        Text(
                          'SPEAKING',
                          style: GoogleFonts.outfit(
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                Text(
                  DateFormatter.formatTime(seg.timestamp),
                  style: const TextStyle(fontSize: 9, color: AppTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 5),
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
  }

  Widget _buildLiveCallerTranscribingBubble(CallSessionModel activeCall) {
    final hasWords = activeCall.currentSpokenWords.trim().isNotEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = _pulseController.value;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(13),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E293B).withValues(alpha: 0.95),
                  const Color(0xFF0F172A).withValues(alpha: 0.98),
                ],
              ),
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomRight: const Radius.circular(2),
              ),
              border: Border.all(
                color: AppTheme.accentRose.withValues(alpha: 0.4 + (pulse * 0.4)),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentRose.withValues(alpha: 0.15 + (pulse * 0.18)),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Header with Pulsing REC & Equalizer
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed.withValues(alpha: 0.4 + (pulse * 0.6)),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentRed.withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'REC • LIVE TRANSCRIBING',
                      style: GoogleFonts.outfit(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppTheme.accentRose,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildMiniEqualizer(pulse, AppTheme.accentRose),
                  ],
                ),
                const SizedBox(height: 7),

                // Spoken Words / Realtime Streaming
                if (hasWords) ...[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: activeCall.currentSpokenWords,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          text: pulse > 0.4 ? ' ▌' : '  ',
                          style: const TextStyle(
                            color: AppTheme.accentCyan,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.mic_none_rounded, size: 14, color: AppTheme.accentRose.withValues(alpha: 0.8)),
                      const SizedBox(width: 6),
                      Text(
                        'Listening for caller speech...',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveAiThinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = _pulseController.value;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(13),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.22),
                  const Color(0xFF0F172A).withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(2),
              ),
              border: Border.all(
                color: AppTheme.accentCyan.withValues(alpha: 0.4 + (pulse * 0.35)),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 13, color: AppTheme.accentCyan),
                    const SizedBox(width: 6),
                    Text(
                      'AI ASSISTANT • GENERATING RESPONSE',
                      style: GoogleFonts.outfit(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppTheme.accentCyan,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildMiniEqualizer(pulse, AppTheme.accentCyan),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBouncingDot(0, pulse),
                    const SizedBox(width: 4),
                    _buildBouncingDot(1, pulse),
                    const SizedBox(width: 4),
                    _buildBouncingDot(2, pulse),
                    const SizedBox(width: 8),
                    Text(
                      'Analyzing conversation context...',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBouncingDot(int index, double progress) {
    final shift = ((progress + (index * 0.33)) % 1.0);
    final scale = 0.6 + (shift * 0.5);
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppTheme.accentCyan.withValues(alpha: 0.6 + (shift * 0.4)),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildMiniEqualizer(double progress, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBar(4 + (progress * 7), color),
        const SizedBox(width: 2),
        _buildBar(11 - (progress * 6), color),
        const SizedBox(width: 2),
        _buildBar(6 + (progress * 5), color),
        const SizedBox(width: 2),
        _buildBar(10 - (progress * 5), color),
      ],
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 2.2,
      height: height.clamp(3.0, 12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
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
