import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/di/catalog_providers.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../catalog/domain/entities/catalog_member.dart';
import '../../../home/presentation/providers/home_shell_tab_provider.dart';
import '../../../home/presentation/widgets/home_bottom_nav.dart';
import '../../domain/rewards_ring_progress.dart';
import '../widgets/rewards_donut_ring.dart';
import '../widgets/rewards_error_body.dart';
import '../widgets/rewards_hero_row.dart';
import '../widgets/rewards_loading_skeleton.dart';
import '../widgets/rewards_screen_background.dart';
import '../widgets/rewards_segmented_tabs.dart';
import '../widgets/rewards_tier_ladder.dart';

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
    if (_pillPopStarted || _entranceController == null || _pillPopController == null) {
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

  void _ensureControllers(CatalogMember member) {
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

    return RewardsScreenBackground(
      child: SafeArea(
        left: true,
        top: true,
        right: false,
        bottom: true,
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
            _ensureControllers(member);
            return _RewardsBody(
              member: member,
              entrance: _entranceController!,
              pillPop: _pillPopController!,
            );
          },
        ),
      ),
    );
  }
}

class _RewardsBody extends StatelessWidget {
  const _RewardsBody({
    required this.member,
    required this.entrance,
    required this.pillPop,
  });

  final CatalogMember member;
  final Animation<double> entrance;
  final Animation<double> pillPop;

  double _leftFade(Animation<double> parent, double start, double end) {
    final curve = CurvedAnimation(
      parent: parent,
      curve: Interval(start, end, curve: AppMotion.standardCurve),
    );
    return curve.value;
  }

  double _leftSlide(Animation<double> parent, double start, double end) {
    final curve = CurvedAnimation(
      parent: parent,
      curve: Interval(start, end, curve: AppMotion.standardCurve),
    );
    return (1 - curve.value) * AppMotion.rewardsEntranceOffset;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final connectorTarget = rewardsRingSweepFraction(member);
    const ringTarget = AppDimens.rewardsDonutDisplaySweep;

    return AnimatedBuilder(
      animation: Listenable.merge([entrance, pillPop]),
      builder: (context, _) {
        final t = entrance.value;
        final progressAnim = reduceMotion ? 1.0 : t;
        final ringProgress = progressAnim * ringTarget;
        final connectorFill = progressAnim * connectorTarget;
        final points = (member.pointsBalance * progressAnim).round();

        final tierStagger = reduceMotion
            ? const [1.0, 1.0, 1.0]
            : [
                _leftFade(entrance, 0, 0.35),
                _leftFade(entrance, 0.12, 0.5),
                _leftFade(entrance, 0.24, 0.65),
              ];

        final tierSlides = reduceMotion
            ? const [0.0, 0.0, 0.0]
            : [
                _leftSlide(entrance, 0, 0.35),
                _leftSlide(entrance, 0.12, 0.5),
                _leftSlide(entrance, 0.24, 0.65),
              ];

        final rightFade = reduceMotion
            ? 1.0
            : CurvedAnimation(
                parent: entrance,
                curve: const Interval(0.15, 0.55, curve: AppMotion.standardCurve),
              ).value;

        final rightSlide = reduceMotion
            ? 0.0
            : (1 -
                    CurvedAnimation(
                      parent: entrance,
                      curve: const Interval(0.15, 0.55, curve: AppMotion.standardCurve),
                    ).value) *
                AppMotion.rewardsEntranceOffset;

        final titleFade = reduceMotion
            ? 1.0
            : CurvedAnimation(
                parent: entrance,
                curve: const Interval(0, 0.4, curve: AppMotion.standardCurve),
              ).value;

        final titleSlide = reduceMotion
            ? 0.0
            : (1 -
                    CurvedAnimation(
                      parent: entrance,
                      curve: const Interval(0, 0.4, curve: AppMotion.standardCurve),
                    ).value) *
                AppMotion.rewardsEntranceOffset;

        final pillFade = rightFade;
        final pillSlide = rightSlide;
        final pillScale = 0.85 + 0.15 * pillPop.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RewardsHeroRow(
              pillCount: member.rewardsPillCount,
              pillScale: pillScale,
              titleFade: titleFade,
              titleSlide: titleSlide,
              pillFade: pillFade,
              pillSlide: pillSlide,
              onPillPressed: () {},
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -AppDimens.rewardsMainContentLift),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      right:
                          (AppDimens.rewardsDonutDiameter -
                              AppDimens.rewardsDonutEdgeOverflow) +
                          AppDimens.rewardsLadderDonutGap,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RewardsTierLadder(
                          member: member,
                          tierOpacities: tierStagger,
                          tierSlides: tierSlides,
                          connectorFill: connectorFill,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: RewardsDonutRing(
                          ringProgress: ringProgress,
                          displayedPoints: points,
                          fade: rightFade,
                          slide: rightSlide,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            const RewardsSegmentedTabs(),
            const SizedBox(height: AppDimens.spaceMd),
          ],
        );
      },
    );
  }
}
