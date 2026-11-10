import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/connectivity/connectivity_status.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/di/catalog_providers.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../catalog/domain/entities/catalog_section.dart';
import '../providers/home_catalog_refresh_provider.dart';
import '../widgets/home_collapsing_header.dart';
import '../widgets/home_donut_refresh_control.dart';
import '../widgets/home_loading_skeleton.dart';
import '../widgets/home_offline_banner.dart';
import '../widgets/home_pinned_notification.dart';
import '../widgets/home_product_section.dart';
import '../widgets/home_section_entrance.dart';
import '../widgets/home_product_section_skeleton.dart';
import '../widgets/home_shops_section.dart';
import '../widgets/home_shops_section_skeleton.dart';

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
        error: (_, _) => _HomeError(
          message: context.l10n.homeCatalogLoadError,
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

    final refreshing = ref.watch(homeCatalogRefreshingProvider);
    final loading = memberAsync.isLoading ||
        bannersAsync.isLoading ||
        sectionsAsync.isLoading ||
        shopsAsync.isLoading;

    final hadCatalog = memberAsync.hasValue && sectionsAsync.hasValue;
    if (loading && !hadCatalog) {
      return const HomeLoadingSkeleton();
    }

    final member = memberAsync.value;
    final sections = sectionsAsync.value ?? [];
    final shops = shopsAsync.value ?? [];
    final sectionsLoadFailed = sectionsAsync.hasError;
    final sectionErrorMessage =
        sectionsLoadFailed ? context.l10n.homeSectionError : null;
    final retrySections = sectionsLoadFailed
        ? () => ref.invalidate(catalogSectionsProvider)
        : null;

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
              onRefresh: () => handleHomePullRefresh(ref),
            ),
            if (refreshing)
              ..._sectionSkeletonSlivers(sections)
            else
              for (var i = 0; i < sections.length; i++)
                SliverToBoxAdapter(
                  child: HomeSectionEntrance(
                    index: i,
                    child: HomeProductSection(
                      section: sections[i],
                      errorMessage: sectionErrorMessage,
                      onRetry: retrySections,
                    ),
                  ),
                ),
            if (refreshing)
              SliverToBoxAdapter(
                child: HomeShopsSectionSkeleton(
                  itemCount: shops.isEmpty ? 3 : shops.length,
                ),
              )
            else
              SliverToBoxAdapter(child: HomeShopsSection(shops: shops)),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimens.homeScrollBottomInset),
            ),
          ],
        ),
        HomePinnedNotification(count: member.notificationCount),
      ],
    );
  }
}

List<Widget> _sectionSkeletonSlivers(List<CatalogSection> sections) {
  final specs = sections.isEmpty
      ? HomeSectionSkeletonSpec.defaults
      : [
          for (final section in sections)
            HomeSectionSkeletonSpec(
              sectionId: section.id,
              cardStyle: section.cardStyle,
              itemCount: section.products.isEmpty
                  ? 3
                  : section.products.length,
            ),
        ];
  return [
    for (final spec in specs)
      SliverToBoxAdapter(child: HomeProductSectionSkeleton(spec: spec)),
  ];
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
