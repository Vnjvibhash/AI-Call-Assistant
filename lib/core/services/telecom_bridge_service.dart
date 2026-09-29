import 'dart:async';
import 'package:flutter/services.dart';
import '../constants/telecom_constants.dart';

class TelecomBridgeService {
  static const MethodChannel _methodChannel =
      MethodChannel(TelecomConstants.methodChannelName);
  static const EventChannel _eventChannel =
      EventChannel(TelecomConstants.eventChannelName);

  Stream<Map<String, dynamic>>? _eventStream;

  Stream<Map<String, dynamic>> get callEvents {
    _eventStream ??= _eventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map));
    return _eventStream!;
  }

  Future<bool> isDefaultDialer() async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(TelecomConstants.methodIsDefaultDialer);
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> requestDefaultDialer() async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(TelecomConstants.methodRequestDefaultDialer);
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isCallScreeningRoleHeld() async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(TelecomConstants.methodIsCallScreeningRoleHeld);
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> requestCallScreeningRole() async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(TelecomConstants.methodRequestCallScreeningRole);
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<Map<String, bool>> getPermissionStatus() async {
    try {
      final res = await _methodChannel.invokeMethod<Map>(TelecomConstants.methodGetPermissionStatus);
      if (res != null) {
        return res.map((k, v) => MapEntry(k.toString(), v == true));
      }
    } on PlatformException {
      // Fallback
    }
    return {};
  }

  Future<bool> answerCall({String? callId}) async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(
        TelecomConstants.methodAnswerCall,
        {'callId': callId},
      );
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> endCall({String? callId}) async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(
        TelecomConstants.methodEndCall,
        {'callId': callId},
      );
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> rejectCall({String? callId}) async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(
        TelecomConstants.methodRejectCall,
        {'callId': callId},
      );
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> setSpeakerphone(bool enabled) async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(
        TelecomConstants.methodSetSpeakerphone,
        {'enabled': enabled},
      );
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> setMute(bool muted) async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(
        TelecomConstants.methodSetMute,
        {'muted': muted},
      );
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<Map<String, dynamic>> getAudioRoutingCapabilities() async {
    try {
      final res = await _methodChannel.invokeMethod<Map>(TelecomConstants.methodGetAudioCapabilities);
      if (res != null) {
        return Map<String, dynamic>.from(res);
      }
    } on PlatformException {
      // fallback
    }
    return {
      'directCellularPcmCaptureSupported': false,
      'inCommunicationModeSupported': true,
      'speakerphoneSupported': true,
      'requiresCallForwardingOrInCommunication': true,
    };
  }

  Future<bool> startCallMonitorService() async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(TelecomConstants.methodStartCallMonitor);
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> stopCallMonitorService() async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(TelecomConstants.methodStopCallMonitor);
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<Map<String, dynamic>> processLocalAi(
    String text, {
    String? callerName,
    String? languageHint,
  }) async {
    try {
      final res = await _methodChannel.invokeMethod<Map>(
        TelecomConstants.methodProcessLocalAi,
        {
          'text': text,
          'callerName': callerName,
          'languageHint': languageHint,
        },
      );
      if (res != null) {
        return Map<String, dynamic>.from(res);
      }
    } on PlatformException {
      // fallback
    }
    return {
      'intent': 'GENERAL_INQUIRY',
      'urgency': 'medium',
      'callbackRequired': false,
      'suggestedResponse': 'Thank you for your message. Vivek has been informed.',
      'detectedLanguage': 'en',
    };
  }

  Future<bool> launchCallForwardingDialer(String mmiCode) async {
    try {
      final res = await _methodChannel.invokeMethod<bool>(
        TelecomConstants.methodLaunchForwardingDialer,
        {'mmiCode': mmiCode},
      );
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }
}
