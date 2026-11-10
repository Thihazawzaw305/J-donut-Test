import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/connectivity/connectivity_status.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/di/catalog_providers.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/home_collapsing_header.dart';
import '../widgets/home_donut_refresh_control.dart';
import '../widgets/home_loading_skeleton.dart';
import '../widgets/home_offline_banner.dart';
import '../widgets/home_pinned_notification.dart';
import '../widgets/home_product_section.dart';
import '../widgets/home_shops_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final offline = ref.watch(connectivityOfflineProvider).value ?? false;

    return ColoredBox(
      color: AppColors.homeScreenBackground,
      child: db.when(
        loading: () => const HomeLoadingSkeleton(),
        error: (error, _) => _HomeError(
          message: error.toString(),
          onRetry: () => ref.invalidate(databaseProvider),
        ),
        data: (_) => _HomeCatalogBody(showOffline: offline),
      ),
    );
  }
}

class _HomeCatalogBody extends ConsumerWidget {
  const _HomeCatalogBody({required this.showOffline});

  final bool showOffline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(catalogMemberProvider);
    final bannersAsync = ref.watch(catalogBannersProvider);
    final sectionsAsync = ref.watch(catalogSectionsProvider);
    final shopsAsync = ref.watch(catalogShopsProvider);

    final loading = memberAsync.isLoading ||
        bannersAsync.isLoading ||
        sectionsAsync.isLoading ||
        shopsAsync.isLoading;

    if (loading) {
      return const HomeLoadingSkeleton();
    }

    final member = memberAsync.value;
    final sections = sectionsAsync.value ?? [];
    final shops = shopsAsync.value ?? [];

    if (member == null) {
      return _HomeError(
        message: context.l10n.homeEmptyCatalog,
        onRetry: () => ref.invalidate(databaseProvider),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomScrollView(
          physics: AppMotion.homeScrollPhysics(context),
          slivers: [
            if (showOffline)
              const SliverToBoxAdapter(child: HomeOfflineBanner()),
            HomeCollapsingHeader(
              member: member,
              banners: bannersAsync.value ?? [],
            ),
            HomeDonutRefreshControl.sliver(
              onRefresh: () => refreshCatalogFromSeed(ref),
            ),
            for (final section in sections)
              SliverToBoxAdapter(child: HomeProductSection(section: section)),
            SliverToBoxAdapter(child: HomeShopsSection(shops: shops)),
          ],
        ),
        HomePinnedNotification(count: member.notificationCount),
      ],
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            const SizedBox(height: AppDimens.spaceMd),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.homeRetry),
            ),
          ],
        ),
      ),
    );
  }
}
