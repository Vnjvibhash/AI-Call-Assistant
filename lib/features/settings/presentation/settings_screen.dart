import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/status_badge.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _obscureKey = true;
  bool _isSavingKey = false;
  Map<String, dynamic> _audioCapabilities = {};

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _loadCapabilities();
  }

  Future<void> _loadApiKey() async {
    final storage = ref.read(secureStorageServiceProvider);
    final key = await storage.getGeminiApiKey();
    if (key != null && mounted) {
      _apiKeyController.text = key;
    }
  }

  Future<void> _loadCapabilities() async {
    final telecom = ref.read(telecomBridgeServiceProvider);
    final caps = await telecom.getAudioRoutingCapabilities();
    if (mounted) {
      setState(() => _audioCapabilities = caps);
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveApiKey() async {
    setState(() => _isSavingKey = true);
    final storage = ref.read(secureStorageServiceProvider);
    final key = _apiKeyController.text.trim();
    if (key.isNotEmpty) {
      await storage.saveGeminiApiKey(key);
      ref.invalidate(geminiApiKeyProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gemini API Key securely saved!')),
        );
      }
    } else {
      await storage.deleteGeminiApiKey();
      ref.invalidate(geminiApiKeyProvider);
    }
    setState(() => _isSavingKey = false);
  }

  void _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete All Call Records & Settings?'),
        content: const Text(
          'This will permanently erase all local transcripts, SQLite call records, summaries, and API keys. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Erase Everything', style: TextStyle(color: AppTheme.accentRed)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final db = ref.read(databaseProvider);
      final storage = ref.read(secureStorageServiceProvider);
      await db.clearAllData();
      await storage.clearAllUserData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data has been wiped.')),
        );
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(assistantSettingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Settings & Privacy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section 1: AI Provider & Mode
            Text('AI Processing & Mode', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Current Processing Mode', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                      StatusBadge.mode(settings.aiMode),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(assistantSettingsProvider.notifier).setAiMode(AppConstants.modeCloud);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: settings.aiMode == AppConstants.modeCloud
                                ? AppTheme.primaryBlue.withOpacity(0.2)
                                : Colors.transparent,
                            side: BorderSide(
                              color: settings.aiMode == AppConstants.modeCloud
                                  ? AppTheme.primaryBlue
                                  : AppTheme.border,
                            ),
                          ),
                          child: const Text('Cloud (Gemini)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(assistantSettingsProvider.notifier).setAiMode(AppConstants.modeLocal);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: settings.aiMode == AppConstants.modeLocal
                                ? AppTheme.accentEmerald.withOpacity(0.2)
                                : Colors.transparent,
                            side: BorderSide(
                              color: settings.aiMode == AppConstants.modeLocal
                                  ? AppTheme.accentEmerald
                                  : AppTheme.border,
                            ),
                          ),
                          child: const Text('Local (Private)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Google Gemini API Key',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _obscureKey,
                    decoration: InputDecoration(
                      hintText: 'AIzaSy...',
                      prefixIcon: const Icon(Icons.key_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureKey ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                        onPressed: () => setState(() => _obscureKey = !_obscureKey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: 'Save Key',
                      icon: Icons.check_rounded,
                      isLoading: _isSavingKey,
                      onPressed: _saveApiKey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 2: Preferred Language
            Text('Language & Voice Settings', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preferred Spoken Language', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    'Select automatic language detection or lock to Hindi, English, or Hinglish.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: settings.language,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: AppConstants.langAuto, child: Text('Automatic Detection (Hindi/English)')),
                      DropdownMenuItem(value: AppConstants.langHindi, child: Text('Hindi Only (हिंदी)')),
                      DropdownMenuItem(value: AppConstants.langEnglish, child: Text('English Only')),
                      DropdownMenuItem(value: AppConstants.langHinglish, child: Text('Hinglish')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(assistantSettingsProvider.notifier).setLanguage(val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    label: const Text('Test AI Voice Synthesis'),
                    onPressed: () {
                      final tts = ref.read(ttsServiceProvider);
                      final lang = settings.language;
                      final text = lang == 'hi'
                          ? "नमस्ते! यह एआई कॉल असिस्टेंट का परीक्षण स्वर है।"
                          : "Hello! This is a voice test of the AI Call Assistant.";
                      tts.speak(text, lang);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 3: Telephony & Call Hub Links
            Text('Telephony & Telecom Configuration', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            GlassCard(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.tune_rounded, color: AppTheme.primaryBlue),
                    title: Text('Call Handling & Greetings', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Edit greetings, spam blocking, delay', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/call-settings'),
                  ),
                  const Divider(height: 1, color: AppTheme.border),
                  ListTile(
                    leading: const Icon(Icons.phone_forwarded_rounded, color: AppTheme.accentCyan),
                    title: Text('Carrier Call Forwarding Setup', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Jio, Airtel, Vi GSM MMI codes', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/call-forwarding'),
                  ),
                  const Divider(height: 1, color: AppTheme.border),
                  ListTile(
                    leading: const Icon(Icons.verified_user_rounded, color: AppTheme.accentEmerald),
                    title: Text('System Telephony Permissions', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Default dialer & screening access', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/permissions'),
                  ),
                  if (_audioCapabilities.isNotEmpty) ...[
                    const Divider(height: 1, color: AppTheme.border),
                    ExpansionTile(
                      leading: const Icon(Icons.developer_board_rounded, color: AppTheme.accentRose),
                      title: Text('Hardware & Telecom Diagnostics', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text('Direct PCM capture & audio routing specs', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _audioCapabilities.entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.key, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                    Text('${e.value}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 4: Privacy & Security
            Text('Privacy & Data Governance', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            GlassCard(
              padding: const EdgeInsets.all(16),
              borderColor: AppTheme.accentRose.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock_rounded, color: AppTheme.accentEmerald, size: 20),
                      const SizedBox(width: 8),
                      Text('Local Encrypted Storage', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'All call logs and transcripts are stored inside your device\'s SQLite database. Your Gemini API key is encrypted using Android Keystore / EncryptedSharedPreferences.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  CustomButton(
                    text: 'Delete All Data & Wipe Database',
                    isDestructive: true,
                    icon: Icons.delete_forever_rounded,
                    onPressed: _clearAllData,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
