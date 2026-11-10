import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/di/catalog_providers.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../catalog/presentation/catalog_strings.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';
import '../../domain/format_mmk_price.dart';
import '../widgets/product_detail_footer.dart';
import '../widgets/product_quantity_stepper.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.homeScreenBackground,
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (product) {
          if (product == null) {
            return Center(child: Text(context.l10n.productNotFound));
          }

          final name = catalogString(context.l10n, product.nameKey);
          final description = catalogString(context.l10n, product.descriptionKey);
          final unitPrice = formatMmkPrice(product.priceMmk);
          final lineTotal = formatMmkPrice(product.priceMmk * _quantity);

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMd,
                    vertical: AppDimens.spaceSm,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: context.l10n.productFavorite,
                        onPressed: () => AppToast.show(
                          context,
                          message: context.l10n.comingSoon,
                        ),
                        icon: const Icon(Icons.favorite_border),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Material(
                          color: AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppDimens.homeCardRadius),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimens.spaceLg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: AppTextStyles.headline),
                                const SizedBox(height: AppDimens.spaceXs),
                                Text(unitPrice, style: AppTextStyles.bodyBold),
                                const SizedBox(height: AppDimens.spaceLg),
                                Center(
                                  child: SizedBox(
                                    height: 220,
                                    child: CatalogImage(
                                      asset: product.imageAsset,
                                      networkUrl: product.imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDimens.spaceLg),
                                Center(
                                  child: ProductQuantityStepper(
                                    quantity: _quantity,
                                    onDecrease: () {
                                      if (_quantity <= 1) return;
                                      setState(() => _quantity -= 1);
                                    },
                                    onIncrease: () =>
                                        setState(() => _quantity += 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.productHelpGreen,
                              child: Icon(
                                Icons.help_outline,
                                size: 14,
                                color: AppColors.onPrimary,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceSm),
                            Text(
                              context.l10n.productWhatsThis,
                              style: AppTextStyles.bodyBold,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spaceSm),
                        Text(description, style: AppTextStyles.body),
                      ],
                    ),
                  ),
                ),
                ProductDetailFooter(
                  totalLabel: lineTotal,
                  onAddToCart: () => AppToast.show(
                    context,
                    message: context.l10n.addedToCart,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
