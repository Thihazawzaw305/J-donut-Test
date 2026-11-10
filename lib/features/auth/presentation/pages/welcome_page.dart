import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/welcome_donut_tiles.dart';
import '../widgets/welcome_hero_gradient_overlay.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      vsync: this,
      duration: AppMotion.welcomeTitleEntrance,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTitleEntrance());
  }

  Future<void> _startTitleEntrance() async {
    if (!mounted) return;
    final delay = AppMotion.of(context, AppMotion.welcomeTitleDelay);
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (!mounted) return;
    final duration = AppMotion.of(context, AppMotion.welcomeTitleEntrance);
    _titleController.duration = duration;
    if (duration == Duration.zero) {
      _titleController.value = 1;
    } else {
      await _titleController.forward();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.backgroundBottom),
          const WelcomeDonutTiles(),
          const WelcomeHeroGradientOverlay(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _titleController,
                      curve: AppMotion.standardCurve,
                    ),
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.12),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _titleController,
                              curve: AppMotion.standardCurve,
                            ),
                          ),
                      child: Text(
                        context.l10n.welcomeHeadline,
                        style: AppTextStyles.headline,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _titleController,
                      curve: AppMotion.standardCurve,
                    ),
                    child: PrimaryButton(
                      label: context.l10n.letsExplore,
                      onPressed: () => context.go(AppRoutes.home),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
