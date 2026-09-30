import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/constants/telecom_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../shared/widgets/glass_card.dart';

class CallHistoryScreen extends ConsumerStatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  ConsumerState<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends ConsumerState<CallHistoryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all'; // 'all', 'ai', 'missed'

  @override
  Widget build(BuildContext context) {
    final callsAsync = ref.watch(allCallsStreamProvider);
    final calls = callsAsync.valueOrNull ?? [];

    final filtered = calls.where((c) {
      if (_selectedFilter == 'ai' && c.status != TelecomConstants.statusAnsweredByAi) {
        return false;
      }
      if (_selectedFilter == 'missed' && c.status != TelecomConstants.statusMissed) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return c.callerName.toLowerCase().contains(q) ||
            c.phoneNumber.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Call History'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by caller name or number...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildFilterChip('All Calls (${calls.length})', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('AI Handled', 'ai'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Missed', 'missed'),
                    ],
                  ),
                ],
              ),
            ),

            // Call List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history_rounded, size: 48, color: AppTheme.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty ? 'No calls matched your search.' : 'No calls recorded yet.',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Calls intercepted or simulated will appear here with full transcripts.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 90),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final call = filtered[index];
                        return _buildCallCard(context, call);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11.5, color: isSelected ? Colors.white : AppTheme.textSecondary)),
      selected: isSelected,
      selectedColor: AppTheme.primaryBlue,
      backgroundColor: AppTheme.surfaceLight,
      side: BorderSide(color: isSelected ? AppTheme.primaryBlue : AppTheme.border),
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = value);
      },
    );
  }

  Widget _buildCallCard(BuildContext context, CallRecord call) {
    final isAi = call.status == TelecomConstants.statusAnsweredByAi;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GlassCard(
        onTap: () => context.push('/call-details/${call.id}'),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isAi ? AppTheme.primaryBlue.withOpacity(0.15) : AppTheme.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(color: isAi ? AppTheme.primaryBlue.withOpacity(0.4) : AppTheme.border),
              ),
              child: Icon(
                isAi ? Icons.smart_toy_rounded : Icons.phone_missed_rounded,
                color: isAi ? AppTheme.primaryBlue : AppTheme.accentRose,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.callerName,
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    PhoneUtils.formatPhoneNumber(call.phoneNumber),
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        DateFormatter.formatRelativeTime(call.startTime),
                        style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          call.handlingMode.toUpperCase(),
                          style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppTheme.accentCyan),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormatter.formatDuration(call.duration),
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
