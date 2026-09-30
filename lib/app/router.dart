import 'package:go_router/go_router.dart';
import 'main_shell_screen.dart';
import '../features/ai_assistant/presentation/ai_chat_screen.dart';
import '../features/call_history/presentation/call_details_screen.dart';
import '../features/call_history/presentation/call_history_screen.dart';
import '../features/call_management/presentation/call_forwarding_setup_screen.dart';
import '../features/call_management/presentation/call_simulator_screen.dart';
import '../features/call_management/presentation/live_call_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/onboarding/presentation/permission_setup_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/reminders/presentation/reminders_screen.dart';
import '../features/settings/presentation/call_settings_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/permissions',
      builder: (context, state) => const PermissionSetupScreen(),
    ),

    // Persistent Shell for the 5 primary tabs with FluidGlassNavBar
    ShellRoute(
      builder: (context, state, child) {
        return MainShellScreen(
          currentPath: state.uri.path,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const CallHistoryScreen(),
        ),
        GoRoute(
          path: '/ai-chat',
          builder: (context, state) => const AiChatScreen(),
        ),
        GoRoute(
          path: '/reminders',
          builder: (context, state) => const RemindersScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    // Dedicated Full-Screen Views (without bottom bar)
    GoRoute(
      path: '/live-call',
      builder: (context, state) => const LiveCallScreen(),
    ),
    GoRoute(
      path: '/simulator',
      builder: (context, state) => const CallSimulatorScreen(),
    ),
    GoRoute(
      path: '/call-forwarding',
      builder: (context, state) => const CallForwardingSetupScreen(),
    ),
    GoRoute(
      path: '/call-details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return CallDetailsScreen(callId: id);
      },
    ),
    GoRoute(
      path: '/call-settings',
      builder: (context, state) => const CallSettingsScreen(),
    ),
  ],
);
