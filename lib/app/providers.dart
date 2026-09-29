import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/app_database.dart';
import '../core/services/gemini_ai_service.dart';
import '../core/services/secure_storage_service.dart';
import '../core/services/speech_service.dart';
import '../core/services/telecom_bridge_service.dart';
import '../core/services/tts_service.dart';

// 1. Singletons
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  throw UnimplementedError('Initialized in main() via ProviderScope override');
});

final telecomBridgeServiceProvider = Provider<TelecomBridgeService>((ref) {
  return TelecomBridgeService();
});

final ttsServiceProvider = Provider<TextToSpeechService>((ref) {
  return FlutterTextToSpeechService();
});

final speechServiceProvider = Provider<SpeechService>((ref) {
  final service = SpeechService();
  ref.onDispose(() => service.dispose());
  return service;
});

// 2. Gemini AI Service (updates when API key changes)
final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(secureStorageServiceProvider);
  return await storage.getGeminiApiKey();
});

final geminiAiServiceProvider = Provider<GeminiAiService>((ref) {
  final apiKeyAsync = ref.watch(geminiApiKeyProvider);
  final apiKey = apiKeyAsync.valueOrNull;
  return GeminiAiService(apiKey: apiKey);
});

// 3. Assistant Settings State
class AssistantSettingsState {
  final bool isEnabled;
  final String aiMode; // 'cloud' | 'local'
  final String language; // 'auto' | 'hi' | 'en' | 'hinglish'
  final String ownerName;
  final String phoneCarrier;
  final String forwardingNumber;

  AssistantSettingsState({
    required this.isEnabled,
    required this.aiMode,
    required this.language,
    required this.ownerName,
    required this.phoneCarrier,
    required this.forwardingNumber,
  });

  AssistantSettingsState copyWith({
    bool? isEnabled,
    String? aiMode,
    String? language,
    String? ownerName,
    String? phoneCarrier,
    String? forwardingNumber,
  }) {
    return AssistantSettingsState(
      isEnabled: isEnabled ?? this.isEnabled,
      aiMode: aiMode ?? this.aiMode,
      language: language ?? this.language,
      ownerName: ownerName ?? this.ownerName,
      phoneCarrier: phoneCarrier ?? this.phoneCarrier,
      forwardingNumber: forwardingNumber ?? this.forwardingNumber,
    );
  }
}

class AssistantSettingsNotifier extends StateNotifier<AssistantSettingsState> {
  final SecureStorageService _storage;
  final TelecomBridgeService _telecom;

  AssistantSettingsNotifier(this._storage, this._telecom)
      : super(
          AssistantSettingsState(
            isEnabled: _storage.isAssistantEnabled(),
            aiMode: _storage.getAiMode(),
            language: _storage.getPreferredLanguage(),
            ownerName: _storage.getUserDisplayName(),
            phoneCarrier: _storage.getPhoneCarrier(),
            forwardingNumber: _storage.getCallForwardingNumber(),
          ),
        );

  Future<void> toggleAssistant(bool enabled) async {
    state = state.copyWith(isEnabled: enabled);
    await _storage.setAssistantEnabled(enabled);
    if (enabled) {
      await _telecom.startCallMonitorService();
    } else {
      await _telecom.stopCallMonitorService();
    }
  }

  Future<void> setAiMode(String mode) async {
    state = state.copyWith(aiMode: mode);
    await _storage.setAiMode(mode);
  }

  Future<void> setLanguage(String lang) async {
    state = state.copyWith(language: lang);
    await _storage.setPreferredLanguage(lang);
  }

  Future<void> setOwnerName(String name) async {
    state = state.copyWith(ownerName: name);
    await _storage.setUserDisplayName(name);
  }

  Future<void> setCarrier(String carrier) async {
    state = state.copyWith(phoneCarrier: carrier);
    await _storage.setPhoneCarrier(carrier);
  }

  Future<void> setForwardingNumber(String number) async {
    state = state.copyWith(forwardingNumber: number);
    await _storage.setCallForwardingNumber(number);
  }
}

final assistantSettingsProvider =
    StateNotifierProvider<AssistantSettingsNotifier, AssistantSettingsState>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final telecom = ref.watch(telecomBridgeServiceProvider);
  return AssistantSettingsNotifier(storage, telecom);
});

// 4. Call Database Streams
final allCallsStreamProvider = StreamProvider<List<CallRecord>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllCalls();
});

final pendingRemindersStreamProvider = StreamProvider<List<CallbackReminder>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchPendingReminders();
});
