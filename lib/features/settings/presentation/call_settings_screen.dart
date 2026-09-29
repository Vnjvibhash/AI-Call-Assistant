import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/glass_card.dart';

class CallSettingsScreen extends ConsumerStatefulWidget {
  const CallSettingsScreen({super.key});

  @override
  ConsumerState<CallSettingsScreen> createState() => _CallSettingsScreenState();
}

class _CallSettingsScreenState extends ConsumerState<CallSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _greetingEnController;
  late TextEditingController _greetingHiController;
  late TextEditingController _greetingHinglishController;
  bool _blockSpam = true;
  double _autoAnswerDelay = 2.0;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(assistantSettingsProvider);
    final storage = ref.read(secureStorageServiceProvider);

    _nameController = TextEditingController(text: settings.ownerName);
    _greetingEnController = TextEditingController(text: storage.getGreetingMessage(AppConstants.langEnglish));
    _greetingHiController = TextEditingController(text: storage.getGreetingMessage(AppConstants.langHindi));
    _greetingHinglishController = TextEditingController(text: storage.getGreetingMessage(AppConstants.langHinglish));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _greetingEnController.dispose();
    _greetingHiController.dispose();
    _greetingHinglishController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    final storage = ref.read(secureStorageServiceProvider);
    await ref.read(assistantSettingsProvider.notifier).setOwnerName(_nameController.text.trim());
    await storage.setGreetingMessage(AppConstants.langEnglish, _greetingEnController.text.trim());
    await storage.setGreetingMessage(AppConstants.langHindi, _greetingHiController.text.trim());
    await storage.setGreetingMessage(AppConstants.langHinglish, _greetingHinglishController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Call settings saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Call Handling Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Owner Profile & Identity', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The assistant introduces itself on calls as: "[Name]\'s personal AI assistant".',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name (Displayed & Spoken)',
                      prefixIcon: Icon(Icons.person_rounded),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text('Custom Spoken Greetings', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('English Greeting', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _greetingEnController,
                    maxLines: 2,
                    decoration: const InputDecoration(hintText: 'Enter English greeting...'),
                  ),
                  const SizedBox(height: 14),
                  Text('Hindi Greeting (हिंदी)', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _greetingHiController,
                    maxLines: 2,
                    decoration: const InputDecoration(hintText: 'हिंदी अभिवादन लिखें...'),
                  ),
                  const SizedBox(height: 14),
                  Text('Hinglish Greeting', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _greetingHinglishController,
                    maxLines: 2,
                    decoration: const InputDecoration(hintText: 'Hinglish greeting likhein...'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text('Answering & Screening Rules', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Block Known Spam Numbers', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Silences or rejects telemarketers automatically.', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                    value: _blockSpam,
                    activeColor: AppTheme.accentEmerald,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _blockSpam = val),
                  ),
                  const Divider(height: 20, color: AppTheme.border),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Auto-Answer Delay', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text('${_autoAnswerDelay.toStringAsFixed(1)} seconds', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                        ],
                      ),
                      Slider(
                        value: _autoAnswerDelay,
                        min: 1.0,
                        max: 8.0,
                        divisions: 7,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) => setState(() => _autoAnswerDelay = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            CustomButton(
              text: 'Save Call Settings',
              icon: Icons.save_rounded,
              width: double.infinity,
              onPressed: _saveSettings,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
