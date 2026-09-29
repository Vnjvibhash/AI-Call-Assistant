import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  final StreamController<String> _wordsController =
      StreamController<String>.broadcast();

  Stream<String> get onSpeechWords => _wordsController.stream;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (val) {
          _isListening = false;
        },
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            _isListening = false;
          }
        },
      );
      return _isInitialized;
    } catch (e) {
      _isInitialized = false;
      return false;
    }
  }

  Future<void> startListening({
    required Function(String recognizedWords, bool isFinal) onResult,
    String languageCode = 'en_IN',
  }) async {
    final available = await initialize();
    if (!available) return;

    _isListening = true;
    try {
      await _speech.listen(
        onResult: (result) {
          final words = result.recognizedWords;
          _wordsController.add(words);
          onResult(words, result.finalResult);
        },
        localeId: _getSpeechLocale(languageCode),
        listenMode: stt.ListenMode.dictation,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      );
    } catch (e) {
      _isListening = false;
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  String _getSpeechLocale(String code) {
    if (code.startsWith('hi')) return 'hi_IN';
    return 'en_IN';
  }

  void dispose() {
    _wordsController.close();
    _speech.stop();
  }
}
