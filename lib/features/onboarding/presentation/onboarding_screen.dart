import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Personal AI Voice Assistant',
      'subtitle':
          'Answers your incoming phone calls when you are busy. Greets callers politely in Hindi, English, or Hinglish, takes messages, and clarifies reasons.',
      'icon': Icons.record_voice_over_rounded,
      'accent': AppTheme.primaryBlue,
    },
    {
      'title': 'Live Real-Time Transcripts',
      'subtitle':
          'Read incoming conversations as they happen in real time. Instant speaker labeling, timestamped segments, and search functionality.',
      'icon': Icons.transcribe_rounded,
      'accent': AppTheme.accentCyan,
    },
    {
      'title': 'AI Summaries & Action Items',
      'subtitle':
          'Get structured executive summaries after every call. Detect urgency levels, extract follow-ups, and auto-schedule callback reminders.',
      'icon': Icons.auto_awesome_rounded,
      'accent': AppTheme.accentRose,
    },
    {
      'title': 'Privacy-First Architecture',
      'subtitle':
          'Choose between offline Local Mode (zero cloud transmission) or Google Gemini Cloud Mode. You own your call data and transcripts.',
      'icon': Icons.shield_rounded,
      'accent': AppTheme.accentEmerald,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Bar with Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AI CALL ASSISTANT',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: () => context.go('/permissions'),
                      child: const Text('Skip', style: TextStyle(color: AppTheme.textSecondary)),
                    ),
                ],
              ),
              const Spacer(),

              // PageView Carousel
              SizedBox(
                height: 380,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    final Color accent = item['accent'];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(color: accent.withOpacity(0.4), width: 2),
                          ),
                          child: Icon(
                            item['icon'],
                            size: 54,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          item['title'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            item['subtitle'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(),

              // Indicators & Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppTheme.primaryBlue : AppTheme.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                width: double.infinity,
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (_currentPage == _pages.length - 1) {
                    context.go('/permissions');
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
