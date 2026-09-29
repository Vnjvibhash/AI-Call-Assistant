import 'package:flutter_tts/flutter_tts.dart';

abstract class TextToSpeechService {
  Future<void> speak(String text, String language);
  Future<void> stop();
}

class FlutterTextToSpeechService implements TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 1.0;

  FlutterTextToSpeechService() {
    _initTts();
  }

  Future<void> _initTts() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setVolume(_volume);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(_pitch);

      // On Android, ensure audio stream is set to voice call or music
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playAndRecord,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
      );

      _isInitialized = true;
    } catch (e) {
      // Ignored for platform variances
    }
  }

  Future<void> setRate(double rate) async {
    _speechRate = rate;
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    await _flutterTts.setPitch(pitch);
  }

  @override
  Future<void> speak(String text, String language) async {
    await _initTts();
    try {
      final langTag = _mapLanguageToLocale(language);
      await _flutterTts.setLanguage(langTag);
      await _flutterTts.speak(text);
    } catch (e) {
      // Safe fallback
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      // Safe fallback
    }
  }

  String _mapLanguageToLocale(String language) {
    switch (language.toLowerCase()) {
      case 'hi':
      case 'hindi':
        return 'hi-IN';
      case 'hinglish':
        return 'hi-IN'; // Indian locale handles Hinglish phonetics best
      case 'en':
      case 'english':
      default:
        return 'en-IN'; // Indian English accent for natural conversation
    }
  }
}
