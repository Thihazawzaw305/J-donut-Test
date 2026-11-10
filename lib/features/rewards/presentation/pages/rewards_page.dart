import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/rewards_system_ui.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/di/catalog_providers.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../home/presentation/providers/home_shell_tab_provider.dart';
import '../../../home/presentation/widgets/home_bottom_nav.dart';
import '../widgets/rewards_body.dart';
import '../widgets/rewards_error_body.dart';
import '../widgets/rewards_loading_skeleton.dart';

class RewardsPage extends ConsumerStatefulWidget {
  const RewardsPage({super.key});

  @override
  ConsumerState<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends ConsumerState<RewardsPage>
    with TickerProviderStateMixin {
  AnimationController? _entranceController;
  AnimationController? _pillPopController;
  var _pillPopStarted = false;

  @override
  void dispose() {
    _entranceController?.removeListener(_onEntranceTick);
    _entranceController?.dispose();
    _pillPopController?.dispose();
    super.dispose();
  }

  void _onEntranceTick() {
    if (_pillPopStarted ||
        _entranceController == null ||
        _pillPopController == null) {
      return;
    }
    if (_entranceController!.value >= 0.15) {
      _pillPopStarted = true;
      _pillPopController!.forward();
    }
  }

  bool get _isRewardsTabActive =>
      ref.read(homeShellTabProvider) == HomeShellTab.rewards;

  void _startEntrance() {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final entrance = _entranceController;
    final pill = _pillPopController;
    if (entrance == null || pill == null) return;

    _pillPopStarted = false;
    entrance.reset();
    pill.reset();
    if (reduceMotion) {
      entrance.value = 1;
      pill.value = 1;
      _pillPopStarted = true;
      return;
    }
    entrance.forward();
  }

  void _holdEntranceAtStart() {
    _pillPopStarted = false;
    _entranceController?.value = 0;
    _pillPopController?.value = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initEntranceControllersIfNeeded();
  }

  void _initEntranceControllersIfNeeded() {
    if (_entranceController != null) return;

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final sweepDuration = AppMotion.of(context, AppMotion.rewardsRingSweep);

    _entranceController = AnimationController(
      vsync: this,
      duration: reduceMotion ? Duration.zero : sweepDuration,
    );
    _pillPopController = AnimationController(
      vsync: this,
      duration: AppMotion.of(context, AppMotion.rewardsPillPop),
    );

    _entranceController!.addListener(_onEntranceTick);
    if (_isRewardsTabActive) {
      _startEntrance();
    } else {
      _holdEntranceAtStart();
    }
  }

  void _onRewardsTabBecameActive() {
    if (_entranceController == null) return;
    _startEntrance();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HomeShellTab>(homeShellTabProvider, (previous, next) {
      if (next != HomeShellTab.rewards) return;
      if (previous == null || previous == HomeShellTab.rewards) return;
      _onRewardsTabBecameActive();
    });

    final memberAsync = ref.watch(catalogMemberProvider);

    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: RewardsSystemUi.overlayStyle,
      child: ColoredBox(
        color: AppColors.homeScreenBackground,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              left: true,
              top: true,
              right: false,
              bottom: false,
              child: memberAsync.when(
                loading: () => const RewardsLoadingSkeleton(),
                error: (_, _) => RewardsErrorBody(
                  message: context.l10n.rewardsLoadError,
                  onRetry: () => ref.invalidate(catalogMemberProvider),
                ),
                data: (member) {
                  if (member == null) {
                    return RewardsErrorBody(
                      message: context.l10n.rewardsEmptyMember,
                      onRetry: () => ref.invalidate(databaseProvider),
                    );
                  }
                  final entrance = _entranceController;
                  final pillPop = _pillPopController;
                  if (entrance == null || pillPop == null) {
                    return const RewardsLoadingSkeleton();
                  }
                  return RewardsBody(
                    member: member,
                    entrance: entrance,
                    pillPop: pillPop,
                    badgePop: pillPop,
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topInset,
              child: const ColoredBox(color: AppColors.rewardsBackgroundTop),
            ),
          ],
        ),
      ),
    );
  }
}
