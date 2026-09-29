import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  SecureStorageService(this._secureStorage, this._prefs);

  static Future<SecureStorageService> init() async {
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final prefs = await SharedPreferences.getInstance();
    return SecureStorageService(secureStorage, prefs);
  }

  // --- Secure Storage: API Key ---
  Future<void> saveGeminiApiKey(String apiKey) async {
    await _secureStorage.write(key: AppConstants.keyGeminiApiKey, value: apiKey);
  }

  Future<String?> getGeminiApiKey() async {
    return await _secureStorage.read(key: AppConstants.keyGeminiApiKey);
  }

  Future<void> deleteGeminiApiKey() async {
    await _secureStorage.delete(key: AppConstants.keyGeminiApiKey);
  }

  // --- Non-sensitive SharedPreferences ---
  bool isAssistantEnabled() {
    return _prefs.getBool('assistant_enabled') ?? true;
  }

  Future<void> setAssistantEnabled(bool enabled) async {
    await _prefs.setBool('assistant_enabled', enabled);
  }

  String getAiMode() {
    return _prefs.getString('ai_mode') ?? AppConstants.modeCloud;
  }

  Future<void> setAiMode(String mode) async {
    await _prefs.setString('ai_mode', mode);
  }

  String getPreferredLanguage() {
    return _prefs.getString('preferred_language') ?? AppConstants.langAuto;
  }

  Future<void> setPreferredLanguage(String lang) async {
    await _prefs.setString('preferred_language', lang);
  }

  String getGreetingMessage(String language) {
    switch (language) {
      case AppConstants.langHindi:
        return _prefs.getString('greeting_hi') ?? AppConstants.defaultHindiGreeting;
      case AppConstants.langHinglish:
        return _prefs.getString('greeting_hinglish') ?? AppConstants.defaultHinglishGreeting;
      case AppConstants.langEnglish:
      default:
        return _prefs.getString('greeting_en') ?? AppConstants.defaultEnglishGreeting;
    }
  }

  Future<void> setGreetingMessage(String language, String message) async {
    switch (language) {
      case AppConstants.langHindi:
        await _prefs.setString('greeting_hi', message);
        break;
      case AppConstants.langHinglish:
        await _prefs.setString('greeting_hinglish', message);
        break;
      case AppConstants.langEnglish:
      default:
        await _prefs.setString('greeting_en', message);
        break;
    }
  }

  String getUserDisplayName() {
    return _prefs.getString(AppConstants.keyUserDisplayName) ?? 'Vivek';
  }

  Future<void> setUserDisplayName(String name) async {
    await _prefs.setString(AppConstants.keyUserDisplayName, name);
  }

  String getPhoneCarrier() {
    return _prefs.getString(AppConstants.keyDefaultPhoneCarrier) ?? 'Airtel';
  }

  Future<void> setPhoneCarrier(String carrier) async {
    await _prefs.setString(AppConstants.keyDefaultPhoneCarrier, carrier);
  }

  String getCallForwardingNumber() {
    return _prefs.getString(AppConstants.keyCallForwardingNumber) ?? '+919999000111';
  }

  Future<void> setCallForwardingNumber(String number) async {
    await _prefs.setString(AppConstants.keyCallForwardingNumber, number);
  }

  bool hasCompletedOnboarding() {
    return _prefs.getBool(AppConstants.keyHasCompletedOnboarding) ?? false;
  }

  Future<void> setHasCompletedOnboarding(bool completed) async {
    await _prefs.setBool(AppConstants.keyHasCompletedOnboarding, completed);
  }

  // Clear all data for user privacy
  Future<void> clearAllUserData() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
}
