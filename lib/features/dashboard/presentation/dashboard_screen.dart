import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/constants/telecom_constants.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../call_management/data/call_session_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(assistantSettingsProvider);
    final callsAsync = ref.watch(allCallsStreamProvider);
    final remindersAsync = ref.watch(pendingRemindersStreamProvider);
    final activeCall = ref.watch(activeCallSessionProvider);

    final calls = callsAsync.valueOrNull ?? [];
    final pendingReminders = remindersAsync.valueOrNull ?? [];

    final totalHandled = calls.where((c) => c.status == TelecomConstants.statusAnsweredByAi).length;
    final missedCalls = calls.where((c) => c.status == TelecomConstants.statusMissed).length;
    final screenedCalls = calls.where((c) => c.status == TelecomConstants.statusScreened).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Call Assistant', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Equal AI for Android', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Active Call Banner (if a call is currently ringing or connected)
            if (activeCall != null) ...[
              _buildActiveCallBanner(context, ref, activeCall),
              const SizedBox(height: 16),
            ],

            // 1. Assistant Master Toggle & Status Card
            _buildMasterAssistantCard(context, ref, settings),
            const SizedBox(height: 16),

            // 2. Metrics / Statistics Grid
            _buildStatsGrid(totalHandled, missedCalls, screenedCalls, pendingReminders.length),
            const SizedBox(height: 20),

            // 3. Quick Action Hub (Simulator, Carrier Setup, AI Chat)
            _buildActionHub(context, ref),
            const SizedBox(height: 20),

            // 4. Recent Calls Header & Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Calls',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/history'),
                  child: const Text('View All', style: TextStyle(color: AppTheme.primaryBlue)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (calls.isEmpty)
              _buildEmptyCallsCard(context, ref)
            else
              ...calls.take(4).map((call) => _buildRecentCallItem(context, call)),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCallBanner(BuildContext context, WidgetRef ref, dynamic activeCall) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: AppTheme.accentRose,
      gradient: LinearGradient(
        colors: [AppTheme.accentRose.withOpacity(0.18), AppTheme.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentRose.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone_in_talk, color: AppTheme.accentRose, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activeCall.callState}: ${activeCall.callerName}',
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'AI Assistant is currently communicating...',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/live-call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRose,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('Open Call', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterAssistantCard(BuildContext context, WidgetRef ref, AssistantSettingsState settings) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderColor: settings.isEnabled ? AppTheme.primaryBlue.withOpacity(0.5) : AppTheme.border,
      gradient: LinearGradient(
        colors: settings.isEnabled
            ? [const Color(0xFF1E3A8A).withOpacity(0.35), AppTheme.surface]
            : [AppTheme.surfaceLight, AppTheme.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: settings.isEnabled ? AppTheme.accentEmerald : AppTheme.textMuted,
                          shape: BoxShape.circle,
                          boxShadow: settings.isEnabled
                              ? [BoxShadow(color: AppTheme.accentEmerald.withOpacity(0.8), blurRadius: 8)]
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        settings.isEnabled ? 'AI ASSISTANT ACTIVE' : 'AI ASSISTANT PAUSED',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: settings.isEnabled ? AppTheme.accentEmerald : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Answering as "${settings.ownerName}\'s Assistant"',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              Switch(
                value: settings.isEnabled,
                activeColor: AppTheme.accentEmerald,
                activeTrackColor: AppTheme.accentEmerald.withOpacity(0.3),
                inactiveThumbColor: AppTheme.textMuted,
                inactiveTrackColor: AppTheme.surfaceLight,
                onChanged: (val) {
                  ref.read(assistantSettingsProvider.notifier).toggleAssistant(val);
                },
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: AppTheme.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge.mode(settings.aiMode),
              Row(
                children: [
                  const Icon(Icons.language_rounded, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    settings.language.toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(int handled, int missed, int screened, int pendingReminders) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem('Handled by AI', handled.toString(), Icons.smart_toy_rounded, AppTheme.primaryBlue),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem('Pending Callbacks', pendingReminders.toString(), Icons.alarm_rounded, AppTheme.accentRose),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem('Screened Calls', screened.toString(), Icons.shield_outlined, AppTheme.accentEmerald),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      borderColor: color.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionHub(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assistant Control Hub',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildHubCard(
                title: 'Live Voice Simulator',
                subtitle: 'Test Hindi/English AI voice responses',
                icon: Icons.record_voice_over_rounded,
                color: AppTheme.primaryBlue,
                onTap: () => context.push('/simulator'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildHubCard(
                title: 'Carrier Forwarding',
                subtitle: 'MMI setup for Jio, Airtel, Vi',
                icon: Icons.phone_forwarded_rounded,
                color: AppTheme.accentCyan,
                onTap: () => context.push('/call-forwarding'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHubCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      borderColor: color.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCallItem(BuildContext context, dynamic call) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GlassCard(
        onTap: () => context.push('/call-details/${call.id}'),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(Icons.person_rounded, color: AppTheme.textPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.callerName,
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${PhoneUtils.formatPhoneNumber(call.phoneNumber)} • ${DateFormatter.formatRelativeTime(call.startTime)}',
                    style: GoogleFonts.inter(fontSize: 11.5, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormatter.formatDuration(call.duration),
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    call.handlingMode.toUpperCase(),
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCallsCard(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.phone_missed_rounded, size: 36, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text(
            'No Calls Logged Yet',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Launch the Voice Simulator to experience live incoming AI call handling.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Launch Simulator',
            icon: Icons.play_arrow_rounded,
            onPressed: () => context.push('/simulator'),
          ),
        ],
      ),
    );
  }
}
