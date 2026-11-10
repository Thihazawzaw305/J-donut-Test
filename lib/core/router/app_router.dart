import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_flow.dart';
import '../../features/auth/presentation/pages/dob_page.dart';
import '../../features/auth/presentation/pages/name_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/phone_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/providers/session_notifier.dart';
import '../../features/auth/presentation/providers/session_providers.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/settings_page.dart';
import '../../features/home/presentation/widgets/home_tab_shell_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/rewards/presentation/pages/rewards_page.dart';
import 'app_page_transitions.dart';
import 'app_routes.dart';

bool _requiresSession(String location) =>
    location == AppRoutes.home ||
    location == AppRoutes.rewards ||
    location == AppRoutes.settings ||
    location.startsWith('/product/');

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(sessionRefreshProvider);
  ref.listen(sessionProvider, (_, _) => refresh.bump());

  String? redirect(GoRouterState state) {
    final session = ref.read(sessionProvider);
    if (session.isLoading) return null;

    final loggedIn = session.asData?.value != null;
    final location = state.matchedLocation;

    if (loggedIn) {
      if (location == AppRoutes.onboarding ||
          location == AppRoutes.loginPhone ||
          location == AppRoutes.loginOtp) {
        return AppRoutes.home;
      }
      return null;
    }

    if (_requiresSession(location)) return AppRoutes.onboarding;
    return null;
  }

  final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    refreshListenable: refresh,
    redirect: (_, state) => redirect(state),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          fadeThrough: true,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerPhone,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          child: const PhonePage(flow: AuthFlow.register),
        ),
      ),
      GoRoute(
        path: AppRoutes.loginPhone,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          child: const PhonePage(flow: AuthFlow.login),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerOtp,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          child: const OtpPage(flow: AuthFlow.register),
        ),
      ),
      GoRoute(
        path: AppRoutes.loginOtp,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          child: const OtpPage(flow: AuthFlow.login),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerName,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          child: const NamePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerDob,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          child: const DobPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          fadeThrough: true,
          child: const WelcomePage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeTabShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.rewards,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RewardsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        pageBuilder: (context, state) => AppPageTransitions.page(
          context: context,
          state: state,
          sharedAxis: SharedAxisTransitionType.scaled,
          child: ProductDetailPage(productId: state.pathParameters['id']!),
        ),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
