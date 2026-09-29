class AppConstants {
  static const String appName = 'AI Call Assistant';
  static const String appTagline = 'Smart Personal AI Phone Assistant';
  static const String appVersion = '1.0.0';

  // State keys
  static const String keyGeminiApiKey = 'secure_gemini_api_key';
  static const String keyUserDisplayName = 'user_display_name';
  static const String keyDefaultPhoneCarrier = 'default_phone_carrier';
  static const String keyCallForwardingNumber = 'call_forwarding_number';
  static const String keyHasCompletedOnboarding = 'has_completed_onboarding';

  // Languages
  static const String langAuto = 'auto';
  static const String langHindi = 'hi';
  static const String langEnglish = 'en';
  static const String langHinglish = 'hinglish';

  // AI Modes
  static const String modeLocal = 'local';
  static const String modeCloud = 'cloud';

  // Urgency / Priority
  static const String priorityUrgent = 'urgent';
  static const String priorityHigh = 'high';
  static const String priorityMedium = 'medium';
  static const String priorityLow = 'low';

  // Greetings
  static const String defaultEnglishGreeting =
      "Hello! I'm Vivek's personal AI assistant. He is currently unavailable. May I know who is calling and what the call is about?";

  static const String defaultHindiGreeting =
      "नमस्ते! विवेक अभी उपलब्ध नहीं हैं। कृपया बताइए, मैं आपकी क्या सहायता कर सकता हूँ?";

  static const String defaultHinglishGreeting =
      "Hello! Vivek abhi available nahi hain. Kya aap bata sakte hain ki aap kaun bol rahe hain aur kya kaam hai?";

  // Default Dialing / Carrier GSM MMI Codes for Conditional Call Forwarding
  static const Map<String, Map<String, String>> carrierForwardingCodes = {
    'Airtel': {
      'whenBusy': '*67*',
      'whenUnanswered': '*61*',
      'whenUnreachable': '*62*',
      'deactivate': '##002#',
      'suffix': '#',
    },
    'Jio': {
      'whenBusy': '*405*',
      'whenUnanswered': '*409*',
      'whenUnreachable': '*410*',
      'deactivate': '*413',
      'suffix': '',
    },
    'Vi (Vodafone Idea)': {
      'whenBusy': '*67*',
      'whenUnanswered': '*61*',
      'whenUnreachable': '*62*',
      'deactivate': '##002#',
      'suffix': '#',
    },
    'BSNL': {
      'whenBusy': '*67*',
      'whenUnanswered': '*61*',
      'whenUnreachable': '*62*',
      'deactivate': '##002#',
      'suffix': '#',
    },
    'Standard GSM (AT&T / T-Mobile / Verizon)': {
      'whenBusy': '*67*',
      'whenUnanswered': '*61*',
      'whenUnreachable': '*62*',
      'deactivate': '##002#',
      'suffix': '#',
    },
  };
}
