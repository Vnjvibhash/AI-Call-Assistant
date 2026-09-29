import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/glass_card.dart';

class PermissionSetupScreen extends ConsumerStatefulWidget {
  const PermissionSetupScreen({super.key});

  @override
  ConsumerState<PermissionSetupScreen> createState() => _PermissionSetupScreenState();
}

class _PermissionSetupScreenState extends ConsumerState<PermissionSetupScreen> {
  bool _isDefaultDialer = false;
  bool _isCallScreening = false;
  bool _hasMic = false;
  bool _hasPhoneState = false;
  bool _hasNotifications = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);
    final telecom = ref.read(telecomBridgeServiceProvider);

    final isDefault = await telecom.isDefaultDialer();
    final isScreening = await telecom.isCallScreeningRoleHeld();
    final micStatus = await Permission.microphone.isGranted;
    final phoneStatus = await Permission.phone.isGranted;
    final notifStatus = await Permission.notification.isGranted;

    if (mounted) {
      setState(() {
        _isDefaultDialer = isDefault;
        _isCallScreening = isScreening;
        _hasMic = micStatus;
        _hasPhoneState = phoneStatus;
        _hasNotifications = notifStatus;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestDefaultDialer() async {
    final telecom = ref.read(telecomBridgeServiceProvider);
    await telecom.requestDefaultDialer();
    await Future.delayed(const Duration(seconds: 1));
    _checkPermissions();
  }

  Future<void> _requestCallScreening() async {
    final telecom = ref.read(telecomBridgeServiceProvider);
    await telecom.requestCallScreeningRole();
    await Future.delayed(const Duration(seconds: 1));
    _checkPermissions();
  }

  Future<void> _requestSystemPermissions() async {
    await [
      Permission.microphone,
      Permission.phone,
      Permission.notification,
    ].request();
    _checkPermissions();
  }

  void _finishSetup() async {
    final storage = ref.read(secureStorageServiceProvider);
    await storage.setHasCompletedOnboarding(true);
    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('System Telephony Setup'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  Text(
                    'Permissions & Telephony Access',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'To enable on-device call interception, automated AI voice responses, and real-time transcription, grant the necessary Android telephony permissions below.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Permission Card 1: Default Dialer (InCallService)
                  _buildPermissionCard(
                    title: 'Default Phone App (InCallService)',
                    subtitle:
                        'Allows AI Call Assistant to receive incoming cellular calls and answer them programmatically using Android Telecom APIs.',
                    icon: Icons.dialer_sip_rounded,
                    isGranted: _isDefaultDialer,
                    actionText: _isDefaultDialer ? 'Configured' : 'Set as Default',
                    onAction: _isDefaultDialer ? null : _requestDefaultDialer,
                    color: AppTheme.primaryBlue,
                    badge: 'RECOMMENDED FOR ON-DEVICE ANSWERING',
                  ),

                  const SizedBox(height: 14),

                  // Permission Card 2: Call Screening Role
                  _buildPermissionCard(
                    title: 'Call Screening Service',
                    subtitle:
                        'Inspects caller ID before ringing, flags spam, and silences unknown or robocalls automatically.',
                    icon: Icons.filter_alt_rounded,
                    isGranted: _isCallScreening,
                    actionText: _isCallScreening ? 'Active' : 'Enable Screening',
                    onAction: _isCallScreening ? null : _requestCallScreening,
                    color: AppTheme.accentCyan,
                  ),

                  const SizedBox(height: 14),

                  // Permission Card 3: Microphone & Speech
                  _buildPermissionCard(
                    title: 'Microphone & Speech',
                    subtitle:
                        'Required for real-time speech-to-text recognition in Hindi, English, and Hinglish during live calls.',
                    icon: Icons.mic_rounded,
                    isGranted: _hasMic,
                    actionText: _hasMic ? 'Granted' : 'Grant Mic',
                    onAction: _hasMic ? null : _requestSystemPermissions,
                    color: AppTheme.accentRose,
                  ),

                  const SizedBox(height: 14),

                  // Permission Card 4: Phone & Call Log
                  _buildPermissionCard(
                    title: 'Phone State & Contacts',
                    subtitle:
                        'Identifies incoming caller numbers, contact names, and logs call records in your local encrypted database.',
                    icon: Icons.contacts_rounded,
                    isGranted: _hasPhoneState,
                    actionText: _hasPhoneState ? 'Granted' : 'Grant Access',
                    onAction: _hasPhoneState ? null : _requestSystemPermissions,
                    color: AppTheme.accentEmerald,
                  ),

                  const SizedBox(height: 14),

                  // Permission Card 5: Notifications
                  _buildPermissionCard(
                    title: 'Notifications & Foreground Service',
                    subtitle:
                        'Keeps the AI call monitoring service active in the background without Android battery killer termination.',
                    icon: Icons.notifications_active_rounded,
                    isGranted: _hasNotifications,
                    actionText: _hasNotifications ? 'Granted' : 'Allow',
                    onAction: _hasNotifications ? null : _requestSystemPermissions,
                    color: AppTheme.accentAmber,
                  ),

                  const SizedBox(height: 28),

                  CustomButton(
                    text: 'Complete Setup & Continue',
                    icon: Icons.check_circle_outline_rounded,
                    width: double.infinity,
                    onPressed: _finishSetup,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'You can update these permissions anytime in Settings.',
                      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildPermissionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isGranted,
    required String actionText,
    required VoidCallback? onAction,
    required Color color,
    String? badge,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: isGranted ? color.withOpacity(0.4) : AppTheme.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isGranted)
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.accentEmerald),
                    const SizedBox(width: 6),
                    Text(
                      actionText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentEmerald,
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton(
                  onPressed: onAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color.withOpacity(0.6)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    actionText,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
