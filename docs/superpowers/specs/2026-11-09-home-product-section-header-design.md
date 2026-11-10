# Home product section header sizing

Date: 2026-11-09  
Scope: `HomeProductSection` row header (title + see-all chevron) only.

## Goals

- Section titles (Seasonal Specials, Popular, etc.) slightly smaller than current **26px** → **22px**.
- See-all control smaller: **32×32** circle, **20px** chevron.
- Circle fill **white** (`AppColors.surface`), not gray track (`quantityTrack`).

## Non-goals

- Shops sky block title (stays 26 until aligned separately).
- Product tile sizes, horizontal list height, see-all navigation (still toast).

## Tokens

| Token | Value | Location |
|---|---|---|
| `AppDimens.homeSectionTitleSize` | 22 | `app_dimens.dart` |
| `AppDimens.homeSeeAllButtonSize` | 32 | `app_dimens.dart` |
| `AppDimens.homeSeeAllIconSize` | 20 | `app_dimens.dart` |
| `AppTextStyles.homeSectionTitle` | `headline` + `homeSectionTitleSize` | `app_text_styles.dart` |

## Widget changes

- `HomeProductSection` title: `AppTextStyles.homeSectionTitle`.
- `_SeeAllButton`: `Material(color: AppColors.surface)`, `SizedBox` uses `homeSeeAllButtonSize`, `Icon` size `homeSeeAllIconSize`.

## Tests

- `test/features/home/presentation/widgets/home_product_section_test.dart`
  - Pump section with one product; assert title `fontSize`, see-all `Material.color`, box and icon sizes.

## Verification

- `flutter test test/features/home/presentation/widgets/home_product_section_test.dart`
- `flutter analyze` clean on touched files.
