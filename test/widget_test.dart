import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aicallassistant/core/utils/phone_utils.dart';
import 'package:aicallassistant/core/utils/date_formatter.dart';
import 'package:aicallassistant/core/services/gemini_ai_service.dart';
import 'package:aicallassistant/shared/widgets/glass_card.dart';
import 'package:aicallassistant/shared/widgets/status_badge.dart';
import 'package:aicallassistant/shared/widgets/custom_button.dart';

void main() {
  group('PhoneUtils Tests', () {
    test('formatPhoneNumber formats Indian numbers correctly', () {
      expect(PhoneUtils.formatPhoneNumber('9876543210'), '+91 98765 43210');
      expect(PhoneUtils.formatPhoneNumber('+919876543210'), '+91 98765 43210');
    });

    test('generateCallForwardingMmiCode generates correct MMI strings', () {
      final airtelBusy = PhoneUtils.generateCallForwardingMmiCode(
        carrier: 'Airtel',
        triggerType: 'whenBusy',
        assistantNumber: '+919999000111',
      );
      expect(airtelBusy, '*67*+919999000111#');

      final jioUnanswered = PhoneUtils.generateCallForwardingMmiCode(
        carrier: 'Jio',
        triggerType: 'whenUnanswered',
        assistantNumber: '+919999000111',
      );
      expect(jioUnanswered, '*409*+919999000111');
    });
  });

  group('DateFormatter Tests', () {
    test('formatDuration formats seconds into human readable text', () {
      expect(DateFormatter.formatDuration(0), '0s');
      expect(DateFormatter.formatDuration(45), '45s');
      expect(DateFormatter.formatDuration(125), '2m 05s');
      expect(DateFormatter.formatDuration(3600), '60m 00s');
    });
  });

  group('GeminiAiService Local Fallback Tests', () {
    test('local engine detects urgent Hindi intent', () async {
      final service = GeminiAiService(apiKey: null);
      final response = await service.generateCallTurn(
        userSpeech: 'नमस्ते, यह एक बहुत जरूरी आपातकाल है',
        history: [],
        ownerName: 'Vivek',
        preferredLanguage: 'hi',
      );

      expect(response.detectedLanguage, 'hi');
      expect(response.intent, 'URGENT_ALERT');
      expect(response.callbackRequired, true);
    });

    test('local engine detects English callback request', () async {
      final service = GeminiAiService(apiKey: null);
      final response = await service.generateCallTurn(
        userSpeech: 'Please ask Vivek to call me back',
        history: [],
        ownerName: 'Vivek',
        preferredLanguage: 'en',
      );

      expect(response.intent, 'CALLBACK_REQUEST');
      expect(response.callbackRequired, true);
    });
  });

  group('Widget Tests', () {
    testWidgets('StatusBadge renders priority correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge.priority('urgent'),
          ),
        ),
      );

      expect(find.text('URGENT'), findsOneWidget);
    });

    testWidgets('CustomButton renders text and triggers callback', (tester) async {
      bool clicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Simulate Call',
              onPressed: () => clicked = true,
            ),
          ),
        ),
      );

      expect(find.text('Simulate Call'), findsOneWidget);
      await tester.tap(find.text('Simulate Call'));
      expect(clicked, true);
    });

    testWidgets('GlassCard renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });
  });
}
