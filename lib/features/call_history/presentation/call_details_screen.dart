import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/status_badge.dart';

class CallDetailsScreen extends ConsumerStatefulWidget {
  final String callId;

  const CallDetailsScreen({super.key, required this.callId});

  @override
  ConsumerState<CallDetailsScreen> createState() => _CallDetailsScreenState();
}

class _CallDetailsScreenState extends ConsumerState<CallDetailsScreen> {
  CallRecord? _callRecord;
  CallSummary? _callSummary;
  List<TranscriptSegment> _segments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCallData();
  }

  Future<void> _loadCallData() async {
    final db = ref.read(databaseProvider);
    final call = await db.getCallById(widget.callId);
    final summary = await db.getSummaryForCall(widget.callId);
    final segments = await db.getTranscriptForCall(widget.callId);

    if (mounted) {
      setState(() {
        _callRecord = call;
        _callSummary = summary;
        _segments = segments;
        _isLoading = false;
      });
    }
  }

  void _callBackCaller() async {
    if (_callRecord == null) return;
    final uri = Uri.parse('tel:${_callRecord!.phoneNumber}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _exportPdf() async {
    if (_callRecord == null) return;
    await PdfExportService.exportAndShareCallReport(
      call: _callRecord!,
      summary: _callSummary,
      segments: _segments,
    );
  }

  void _exportTxt() async {
    if (_callRecord == null) return;
    await PdfExportService.exportAndShareAsText(
      call: _callRecord!,
      summary: _callSummary,
      segments: _segments,
    );
  }

  void _deleteCall() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete Call Record?'),
        content: const Text('This will delete the transcript, audio record, and AI summary.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppTheme.accentRed)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final db = ref.read(databaseProvider);
      await db.deleteCallRecord(widget.callId);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_callRecord == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: const Text('Call Record')),
        body: const Center(child: Text('Call not found.')),
      );
    }

    final call = _callRecord!;
    final summary = _callSummary;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(call.callerName),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: 'Export PDF',
            onPressed: _exportPdf,
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Export Text',
            onPressed: _exportTxt,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.accentRose),
            tooltip: 'Delete Call',
            onPressed: _deleteCall,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Caller Information Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppTheme.surfaceLight,
                        child: const Icon(Icons.person_rounded, size: 30, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              call.callerName,
                              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              PhoneUtils.formatPhoneNumber(call.phoneNumber),
                              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormatter.formatDateTime(call.startTime),
                              style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormatter.formatDuration(call.duration),
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          if (summary != null) StatusBadge.priority(summary.priority),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Call Back',
                          icon: Icons.phone_rounded,
                          backgroundColor: AppTheme.accentEmerald,
                          onPressed: _callBackCaller,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // AI Executive Summary Card
            if (summary != null) ...[
              GlassCard(
                padding: const EdgeInsets.all(16),
                borderColor: AppTheme.primaryBlue.withOpacity(0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome_rounded, size: 18, color: AppTheme.primaryBlue),
                            const SizedBox(width: 8),
                            Text(
                              'AI Call Summary',
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            summary.intent.toUpperCase(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      summary.summary,
                      style: GoogleFonts.inter(fontSize: 13.5, color: AppTheme.textPrimary, height: 1.5),
                    ),
                    if (summary.callbackRequired) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentRose.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.accentRose.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.alarm_on_rounded, size: 16, color: AppTheme.accentRose),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Callback Requested by Caller',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentRose,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (summary.actionItems != null && summary.actionItems!.isNotEmpty) ...[
                      const Divider(height: 24, thickness: 1, color: AppTheme.border),
                      Text(
                        'Action Items',
                        style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      ...summary.actionItems!.split('|').map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 14, color: AppTheme.accentEmerald),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.trim(),
                                  style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Full Timestamped Conversation Transcript
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Conversation Transcript',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_segments.length} turns',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_segments.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No spoken turns recorded for this call.',
                    style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                  ),
                ),
              )
            else
              ..._segments.map((seg) {
                final isAi = seg.speaker.toLowerCase() == 'ai';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: isAi ? AppTheme.primaryBlue.withOpacity(0.3) : AppTheme.border,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isAi ? 'AI ASSISTANT' : call.callerName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: isAi ? AppTheme.accentCyan : AppTheme.accentRose,
                              ),
                            ),
                            Text(
                              DateFormatter.formatTime(seg.timestamp),
                              style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          seg.textContent,
                          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textPrimary, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
