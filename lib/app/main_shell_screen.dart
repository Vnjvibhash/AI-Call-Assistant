import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/fluid_glass_nav_bar.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainShellScreen({
    super.key,
    required this.child,
    required this.currentPath,
  });

  int _calculateSelectedIndex(String path) {
    if (path.startsWith('/history')) return 1;
    if (path.startsWith('/ai-chat')) return 2;
    if (path.startsWith('/reminders')) return 3;
    if (path.startsWith('/settings')) return 4;
    return 0; // /dashboard
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/ai-chat');
        break;
      case 3:
        context.go('/reminders');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(currentPath);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: FluidGlassNavBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}
