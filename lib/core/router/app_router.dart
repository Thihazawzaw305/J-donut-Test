import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_flow.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/phone_page.dart';
import '../l10n/l10n_extension.dart';
import '../widgets/placeholder_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.registerPhone,
        builder: (_, _) => const PhonePage(flow: AuthFlow.register),
      ),
      GoRoute(
        path: AppRoutes.loginPhone,
        builder: (_, _) => const PhonePage(flow: AuthFlow.login),
      ),
      GoRoute(
        path: AppRoutes.registerOtp,
        builder: (_, _) => const OtpPage(flow: AuthFlow.register),
      ),
      GoRoute(
        path: AppRoutes.loginOtp,
        builder: (_, _) => const OtpPage(flow: AuthFlow.login),
      ),
      GoRoute(
        path: AppRoutes.registerName,
        builder: (context, _) =>
            PlaceholderPage(title: context.l10n.nameTitle),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, _) =>
            PlaceholderPage(title: context.l10n.welcomeTitle),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, _) => PlaceholderPage(title: context.l10n.homeTitle),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
