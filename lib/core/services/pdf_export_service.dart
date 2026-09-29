import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../database/app_database.dart';
import '../utils/date_formatter.dart';

class PdfExportService {
  /// Generate and share a PDF call report
  static Future<void> exportAndShareCallReport({
    required CallRecord call,
    required CallSummary? summary,
    required List<TranscriptSegment> segments,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'AI CALL ASSISTANT',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.Text(
                      'Official Call Summary & Transcript Report',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.circular(6),
                    border: pw.Border.all(color: PdfColors.blue300),
                  ),
                  child: pw.Text(
                    'MODE: ${call.handlingMode.toUpperCase()}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ),
              ],
            ),
            pw.Divider(thickness: 1.5, color: PdfColors.grey300),
            pw.SizedBox(height: 12),

            // Call Metadata Card
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetaItem('Caller Name', call.callerName),
                      _buildMetaItem('Phone Number', call.phoneNumber),
                      _buildMetaItem('Duration', DateFormatter.formatDuration(call.duration)),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetaItem('Date & Time', DateFormatter.formatDateTime(call.startTime)),
                      _buildMetaItem('Status', call.status.replaceAll('_', ' ').toUpperCase()),
                      _buildMetaItem('Priority', (summary?.priority ?? 'MEDIUM').toUpperCase()),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // AI Executive Summary
            if (summary != null) ...[
              pw.Text(
                'AI Call Summary',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: PdfColors.amber200),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      summary.summary,
                      style: const pw.TextStyle(fontSize: 11, color: PdfColors.black),
                    ),
                    if (summary.callbackRequired) ...[
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Action: Callback required for this caller.',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.red800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
            ],

            // Conversation Transcript
            pw.Text(
              'Conversation Transcript',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
            ),
            pw.SizedBox(height: 6),
            ...segments.map((segment) {
              final isAi = segment.speaker.toLowerCase() == 'ai';
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 6),
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: isAi ? PdfColors.blue50 : PdfColors.grey50,
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(
                    color: isAi ? PdfColors.blue200 : PdfColors.grey300,
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        isAi ? 'AI ASSISTANT' : 'CALLER',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: isAi ? PdfColors.blue800 : PdfColors.grey800,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        segment.textContent,
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
                      ),
                    ),
                    pw.Text(
                      DateFormatter.formatTime(segment.timestamp),
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                    ),
                  ],
                ),
              );
            }),
          ];
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Call_Report_${call.callerName}_${call.id.substring(0, 6)}.pdf',
    );
  }

  /// Export as plain text
  static Future<void> exportAndShareAsText({
    required CallRecord call,
    required CallSummary? summary,
    required List<TranscriptSegment> segments,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln("=== AI CALL ASSISTANT REPORT ===");
    buffer.writeln("Caller: ${call.callerName} (${call.phoneNumber})");
    buffer.writeln("Date: ${DateFormatter.formatDateTime(call.startTime)}");
    buffer.writeln("Duration: ${DateFormatter.formatDuration(call.duration)}");
    buffer.writeln("Status: ${call.status}");
    buffer.writeln("Handling Mode: ${call.handlingMode}");
    if (summary != null) {
      buffer.writeln("\n--- AI SUMMARY ---");
      buffer.writeln("Summary: ${summary.summary}");
      buffer.writeln("Intent: ${summary.intent}");
      buffer.writeln("Priority: ${summary.priority}");
      buffer.writeln("Callback Required: ${summary.callbackRequired}");
    }
    buffer.writeln("\n--- FULL TRANSCRIPT ---");
    for (final s in segments) {
      buffer.writeln("[${s.speaker.toUpperCase()} - ${DateFormatter.formatTime(s.timestamp)}]: ${s.textContent}");
    }

    await Share.share(
      buffer.toString(),
      subject: "Call Transcript: ${call.callerName}",
    );
  }

  static pw.Widget _buildMetaItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
}
