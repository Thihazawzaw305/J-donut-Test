import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../catalog/domain/entities/catalog_banner.dart';
import '../../../catalog/domain/entities/catalog_member.dart';
import '../../../catalog/presentation/catalog_strings.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';
import 'home_banner_carousel.dart';

class HomeHeaderPanel extends StatelessWidget {
  const HomeHeaderPanel({
    super.key,
    required this.member,
    required this.banners,
  });

  final CatalogMember member;
  final List<CatalogBanner> banners;

  static const _headerShape = BorderRadius.only(
    bottomLeft: Radius.circular(AppDimens.homeHeaderRadius),
    bottomRight: Radius.circular(AppDimens.homeHeaderRadius),
  );

  @override
  Widget build(BuildContext context) {
    final tierText = catalogMemberTierProgress(context.l10n, member);

    return ClipRRect(
      borderRadius: _headerShape,
      child: ColoredBox(
        color: AppColors.homeHeader,
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spaceMd,
                  AppDimens.homeHeaderTopPadding,
                  AppDimens.homeNotificationLayoutReserve,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: CatalogImage(
                              asset: member.avatarAsset,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.displayName,
                                style: AppTextStyles.homeMemberName,
                              ),
                              Text(
                                catalogString(context.l10n, member.subtitleKey),
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.homeHeaderGapProfileToPill),
                    IntrinsicWidth(
                      child: Container(
                        key: const Key('home_tier_pill'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.homeTierPillPaddingH,
                          vertical: AppDimens.homeTierPillPaddingV,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppDimens.homeTierPillRadius,
                          ),
                          border: Border.all(color: AppColors.tierCapsuleBorder),
                        ),
                        child: Text(
                          tierText,
                          style: AppTextStyles.homeTierPill,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.homeHeaderGapPillToBanner),
              HomeBannerCarousel(banners: banners),
            ],
          ),
        ),
      ),
    );
  }
}
