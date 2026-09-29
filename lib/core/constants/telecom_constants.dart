class TelecomConstants {
  static const String methodChannelName = 'in.innovateria.aicallassistant/telecom';
  static const String eventChannelName = 'in.innovateria.aicallassistant/telecom_events';

  // Native Method Names
  static const String methodIsDefaultDialer = 'isDefaultDialer';
  static const String methodRequestDefaultDialer = 'requestDefaultDialer';
  static const String methodIsCallScreeningRoleHeld = 'isCallScreeningRoleHeld';
  static const String methodRequestCallScreeningRole = 'requestCallScreeningRole';
  static const String methodGetPermissionStatus = 'getPermissionStatus';
  static const String methodAnswerCall = 'answerCall';
  static const String methodEndCall = 'endCall';
  static const String methodRejectCall = 'rejectCall';
  static const String methodSetSpeakerphone = 'setSpeakerphone';
  static const String methodSetMute = 'setMute';
  static const String methodGetAudioCapabilities = 'getAudioRoutingCapabilities';
  static const String methodStartCallMonitor = 'startCallMonitorService';
  static const String methodStopCallMonitor = 'stopCallMonitorService';
  static const String methodProcessLocalAi = 'processLocalAiMessage';
  static const String methodLaunchForwardingDialer = 'launchCallForwardingDialer';

  // Event Types
  static const String eventIncomingCall = 'INCOMING_CALL';
  static const String eventCallStateChanged = 'CALL_STATE_CHANGED';
  static const String eventCallAnswered = 'CALL_ANSWERED';
  static const String eventCallEnded = 'CALL_ENDED';
  static const String eventAudioRouteChange = 'AUDIO_ROUTE_CHANGED';

  // Call States
  static const String stateRinging = 'RINGING';
  static const String stateActive = 'ACTIVE';
  static const String stateHolding = 'HOLDING';
  static const String stateDisconnected = 'DISCONNECTED';
  static const String stateConnecting = 'CONNECTING';

  // Handling Status
  static const String statusScreened = 'screened';
  static const String statusAnsweredByAi = 'answered_by_ai';
  static const String statusMissed = 'missed';
  static const String statusBlocked = 'blocked';
  static const String statusUserAnswered = 'user_answered';
}
