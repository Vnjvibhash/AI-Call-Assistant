import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../shared/widgets/glass_card.dart';

class CallForwardingSetupScreen extends ConsumerStatefulWidget {
  const CallForwardingSetupScreen({super.key});

  @override
  ConsumerState<CallForwardingSetupScreen> createState() => _CallForwardingSetupScreenState();
}

class _CallForwardingSetupScreenState extends ConsumerState<CallForwardingSetupScreen> {
  late String _selectedCarrier;
  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(assistantSettingsProvider);
    _selectedCarrier = settings.phoneCarrier;
    _numberController = TextEditingController(text: settings.forwardingNumber);
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _dialMmiCode(String triggerType) async {
    final telecom = ref.read(telecomBridgeServiceProvider);
    final number = _numberController.text.trim();

    final code = PhoneUtils.generateCallForwardingMmiCode(
      carrier: _selectedCarrier,
      triggerType: triggerType,
      assistantNumber: number,
    );

    await telecom.launchCallForwardingDialer(code);
  }

  void _deactivateForwarding() async {
    final telecom = ref.read(telecomBridgeServiceProvider);
    final code = PhoneUtils.getDeactivationCode(_selectedCarrier);
    await telecom.launchCallForwardingDialer(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Carrier Call Forwarding'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Equal AI Telephony Trunk Integration',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'To have AI answer cellular calls without requiring your phone to be the default dialer (or when your phone is turned off / out of coverage), configure Conditional Call Forwarding via your mobile carrier.',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Carrier Selection Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Mobile Carrier',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedCarrier,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: AppConstants.carrierForwardingCodes.keys.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedCarrier = val);
                        ref.read(assistantSettingsProvider.notifier).setCarrier(val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'AI Telephony Dedicated Inbound Number',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_in_talk_rounded),
                      hintText: '+919999000111',
                    ),
                    onChanged: (val) {
                      ref.read(assistantSettingsProvider.notifier).setForwardingNumber(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            Text(
              'Quick One-Tap Carrier Activation',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),

            // MMI Action 1: When Unanswered
            _buildMmiActionTile(
              title: 'When Unanswered (No Answer)',
              subtitle: 'Forwards call to AI if you don\'t pick up within 15 seconds.',
              mmiCode: PhoneUtils.generateCallForwardingMmiCode(
                carrier: _selectedCarrier,
                triggerType: 'whenUnanswered',
                assistantNumber: _numberController.text.trim(),
              ),
              onTap: () => _dialMmiCode('whenUnanswered'),
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(height: 10),

            // MMI Action 2: When Busy / Rejected
            _buildMmiActionTile(
              title: 'When Busy / Declined',
              subtitle: 'Forwards immediately when you decline or are on another line.',
              mmiCode: PhoneUtils.generateCallForwardingMmiCode(
                carrier: _selectedCarrier,
                triggerType: 'whenBusy',
                assistantNumber: _numberController.text.trim(),
              ),
              onTap: () => _dialMmiCode('whenBusy'),
              color: AppTheme.accentCyan,
            ),
            const SizedBox(height: 10),

            // MMI Action 3: When Unreachable
            _buildMmiActionTile(
              title: 'When Unreachable / Switched Off',
              subtitle: 'Forwards when outside network coverage or battery runs out.',
              mmiCode: PhoneUtils.generateCallForwardingMmiCode(
                carrier: _selectedCarrier,
                triggerType: 'whenUnreachable',
                assistantNumber: _numberController.text.trim(),
              ),
              onTap: () => _dialMmiCode('whenUnreachable'),
              color: AppTheme.accentEmerald,
            ),

            const SizedBox(height: 20),

            // Deactivation Card
            GlassCard(
              padding: const EdgeInsets.all(14),
              borderColor: AppTheme.accentRed.withOpacity(0.3),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cancel_rounded, color: AppTheme.accentRed, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cancel All Forwarding', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(
                          'Dial ${PhoneUtils.getDeactivationCode(_selectedCarrier)} to restore normal phone carrier handling.',
                          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _deactivateForwarding,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentRed,
                      side: const BorderSide(color: AppTheme.accentRed),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Deactivate', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMmiActionTile({
    required String title,
    required String subtitle,
    required String mmiCode,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: color.withOpacity(0.3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.dialpad_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'MMI Code: $mmiCode',
                    style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace', color: AppTheme.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('Dial', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
