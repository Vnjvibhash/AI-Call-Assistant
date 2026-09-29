import '../constants/app_constants.dart';

class PhoneUtils {
  /// Format phone numbers nicely (e.g. +91 98765 43210)
  static String formatPhoneNumber(String rawNumber) {
    final cleaned = rawNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('+91') && cleaned.length == 13) {
      return '+91 ${cleaned.substring(3, 8)} ${cleaned.substring(8)}';
    }
    if (cleaned.length == 10) {
      return '+91 ${cleaned.substring(0, 5)} ${cleaned.substring(5)}';
    }
    return rawNumber;
  }

  /// Generate GSM MMI call forwarding code for given carrier, mode, and assistant number
  static String generateCallForwardingMmiCode({
    required String carrier,
    required String triggerType, // 'whenBusy', 'whenUnanswered', 'whenUnreachable'
    required String assistantNumber,
  }) {
    final carrierConfig = AppConstants.carrierForwardingCodes[carrier] ??
        AppConstants.carrierForwardingCodes['Standard GSM (AT&T / T-Mobile / Verizon)']!;

    final prefix = carrierConfig[triggerType] ?? '*67*';
    final suffix = carrierConfig['suffix'] ?? '#';

    // Format: *67*<assistantNumber>#
    return '$prefix$assistantNumber$suffix';
  }

  /// Generate deactivation code
  static String getDeactivationCode(String carrier) {
    final carrierConfig = AppConstants.carrierForwardingCodes[carrier] ??
        AppConstants.carrierForwardingCodes['Standard GSM (AT&T / T-Mobile / Verizon)']!;
    return carrierConfig['deactivate'] ?? '##002#';
  }
}
