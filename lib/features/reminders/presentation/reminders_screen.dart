import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../shared/widgets/glass_card.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  void _callNumber(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _markCompleted(WidgetRef ref, String id) async {
    final db = ref.read(databaseProvider);
    await db.updateReminderStatus(id, 'completed');
  }

  void _dismissReminder(WidgetRef ref, String id) async {
    final db = ref.read(databaseProvider);
    await db.deleteReminder(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(pendingRemindersStreamProvider);
    final reminders = remindersAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Callback Reminders'),
      ),
      body: SafeArea(
        child: reminders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.alarm_on_rounded, size: 52, color: AppTheme.accentEmerald),
                    const SizedBox(height: 16),
                    Text(
                      'All Callbacks Completed!',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'When callers request a callback, the AI assistant schedules it here automatically.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: AppTheme.accentRose.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                reminder.callerName,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentRose.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  reminder.reminderStatus.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentRose,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            PhoneUtils.formatPhoneNumber(reminder.phoneNumber),
                            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textMuted),
                              const SizedBox(width: 6),
                              Text(
                                'Scheduled for: ${DateFormatter.formatDateTime(reminder.reminderTime)}',
                                style: GoogleFonts.inter(fontSize: 11.5, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          if (reminder.note != null && reminder.note!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              reminder.note!,
                              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                          ],
                          const Divider(height: 20, thickness: 1, color: AppTheme.border),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _dismissReminder(ref, reminder.id),
                                child: const Text('Dismiss', style: TextStyle(color: AppTheme.textMuted)),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.check_rounded, size: 16),
                                label: const Text('Done'),
                                onPressed: () => _markCompleted(ref, reminder.id),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.phone_rounded, size: 16),
                                label: const Text('Call'),
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentEmerald),
                                onPressed: () => _callNumber(reminder.phoneNumber),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
