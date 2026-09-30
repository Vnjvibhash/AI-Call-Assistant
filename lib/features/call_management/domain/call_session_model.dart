class TranscriptSegmentItem {
  final String id;
  final String speaker; // 'ai', 'caller', 'user'
  final String text;
  final DateTime timestamp;
  final String language;

  TranscriptSegmentItem({
    required this.id,
    required this.speaker,
    required this.text,
    required this.timestamp,
    required this.language,
  });
}

class CallSessionModel {
  final String callId;
  final String callerName;
  final String phoneNumber;
  final DateTime startTime;
  final int durationSeconds;
  final String callState; // 'RINGING', 'ACTIVE', 'DISCONNECTED'
  final bool isAiHandling;
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isAiThinking;
  final bool isAiSpeaking;
  final bool isListeningToCaller;
  final bool isRecordingAudio;
  final String currentSpokenWords;
  final List<TranscriptSegmentItem> segments;
  final bool isScreened;
  final String handlingMode;

  CallSessionModel({
    required this.callId,
    required this.callerName,
    required this.phoneNumber,
    required this.startTime,
    this.durationSeconds = 0,
    required this.callState,
    this.isAiHandling = true,
    this.isMuted = false,
    this.isSpeakerOn = false,
    this.isAiThinking = false,
    this.isAiSpeaking = false,
    this.isListeningToCaller = false,
    this.isRecordingAudio = true,
    this.currentSpokenWords = '',
    this.segments = const [],
    this.isScreened = false,
    this.handlingMode = 'cloud',
  });

  CallSessionModel copyWith({
    String? callId,
    String? callerName,
    String? phoneNumber,
    DateTime? startTime,
    int? durationSeconds,
    String? callState,
    bool? isAiHandling,
    bool? isMuted,
    bool? isSpeakerOn,
    bool? isAiThinking,
    bool? isAiSpeaking,
    bool? isListeningToCaller,
    bool? isRecordingAudio,
    String? currentSpokenWords,
    List<TranscriptSegmentItem>? segments,
    bool? isScreened,
    String? handlingMode,
  }) {
    return CallSessionModel(
      callId: callId ?? this.callId,
      callerName: callerName ?? this.callerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      startTime: startTime ?? this.startTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      callState: callState ?? this.callState,
      isAiHandling: isAiHandling ?? this.isAiHandling,
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isAiThinking: isAiThinking ?? this.isAiThinking,
      isAiSpeaking: isAiSpeaking ?? this.isAiSpeaking,
      isListeningToCaller: isListeningToCaller ?? this.isListeningToCaller,
      isRecordingAudio: isRecordingAudio ?? this.isRecordingAudio,
      currentSpokenWords: currentSpokenWords ?? this.currentSpokenWords,
      segments: segments ?? this.segments,
      isScreened: isScreened ?? this.isScreened,
      handlingMode: handlingMode ?? this.handlingMode,
    );
  }
}
