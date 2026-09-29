import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/call_session_controller.dart';

class CallSimulatorScreen extends ConsumerStatefulWidget {
  const CallSimulatorScreen({super.key});

  @override
  ConsumerState<CallSimulatorScreen> createState() => _CallSimulatorScreenState();
}

class _CallSimulatorScreenState extends ConsumerState<CallSimulatorScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Rahul Sharma');
  final TextEditingController _numberController = TextEditingController(text: '+91 98765 43210');

  final List<Map<String, dynamic>> _scenarios = [
    {
      'id': 'project_en',
      'name': 'Rahul (English)',
      'number': '+91 98765 43210',
      'title': 'Project Inquiry & Quote',
      'desc': 'Caller asks to discuss website development project and asks for callback.',
      'language': 'en',
      'accent': AppTheme.primaryBlue,
    },
    {
      'id': 'urgent_hi',
      'name': 'पूजा वर्मा (Hindi)',
      'number': '+91 91234 56789',
      'title': 'ज़रूरी मीटिंग अनुरोध (Urgent Meeting)',
      'desc': 'Caller speaks pure Hindi and requests an urgent afternoon meeting.',
      'language': 'hi',
      'accent': AppTheme.accentRose,
    },
    {
      'id': 'callback_hinglish',
      'name': 'Vikram Patel (Hinglish)',
      'number': '+91 99887 76655',
      'title': 'Invoice & Payment Followup',
      'desc': 'Caller speaks Hinglish: "Vivek se payment ke regarding baat karni hai, callback de do."',
      'language': 'hinglish',
      'accent': AppTheme.accentCyan,
    },
    {
      'id': 'robocall_spam',
      'name': 'Credit Card Offer (Spam)',
      'number': '+91 14099 88776',
      'title': 'Telemarketing Spam Call',
      'desc': 'Automated marketing promotion; assistant screens and flags as low-priority spam.',
      'language': 'en',
      'accent': AppTheme.accentAmber,
    },
  ];

  void _launchSimulation(Map<String, dynamic> scenario) {
    final callId = 'sim_${const Uuid().v4()}';

    // Start incoming call
    ref.read(activeCallSessionProvider.notifier).startIncomingCall(
      callId: callId,
      phoneNumber: scenario['number'],
      callerName: scenario['name'],
      autoAnswer: true,
    );

    // Navigate to live call screen
    context.push('/live-call');
  }

  void _launchCustomSimulation() {
    final name = _nameController.text.trim().isEmpty ? 'Unknown Caller' : _nameController.text.trim();
    final number = _numberController.text.trim().isEmpty ? '+91 90000 00000' : _numberController.text.trim();
    final callId = 'sim_${const Uuid().v4()}';

    ref.read(activeCallSessionProvider.notifier).startIncomingCall(
      callId: callId,
      phoneNumber: number,
      callerName: name,
      autoAnswer: true,
    );

    context.push('/live-call');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Call Simulation Studio'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Interactive Telecom & Voice Simulator',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Select a preset scenario or configure a custom incoming call to test real-time speech recognition, Gemini AI turns, and Hindi/English voice responses.',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),

            Text(
              'Preset Scenarios',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 10),

            ..._scenarios.map((sc) {
              final Color accent = sc['accent'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: GlassCard(
                  borderColor: accent.withOpacity(0.3),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.phone_callback_rounded, color: accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sc['title'],
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${sc['name']} • ${sc['language'].toString().toUpperCase()}',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accent),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              sc['desc'],
                              style: GoogleFonts.inter(fontSize: 11.5, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _launchSimulation(sc),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Simulate', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 18),
            Text(
              'Custom Caller Simulation',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 10),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Caller Name',
                      prefixIcon: Icon(Icons.person_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Simulate Incoming Call',
                    icon: Icons.play_arrow_rounded,
                    width: double.infinity,
                    onPressed: _launchCustomSimulation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
