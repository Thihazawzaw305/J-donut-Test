import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/di/catalog_providers.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../catalog/presentation/catalog_strings.dart';
import '../../domain/format_mmk_price.dart';
import '../widgets/product_detail_description_panel.dart';
import '../widgets/product_detail_footer.dart';
import '../product_detail_close.dart';
import '../widgets/product_detail_hero_card.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  static const _minQuantity = 1;

  int _quantity = _minQuantity;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
        backgroundColor: AppColors.homeScreenBackground,
        body: productAsync.when(
        loading: () => const ColoredBox(
          color: AppColors.homeScreenBackground,
          child: SizedBox.expand(),
        ),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (product) {
          if (product == null) {
            return Center(child: Text(context.l10n.productNotFound));
          }

          final name = catalogString(context.l10n, product.nameKey);
          final description =
              catalogString(context.l10n, product.descriptionKey);
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
                        onPressed: () => closeProductDetail(context),
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
                        ProductDetailHeroCard(
                          productId: product.id,
                          productCode: product.code,
                          name: name,
                          unitPriceLabel: unitPrice,
                          imageAsset: product.imageAsset,
                          imageUrl: product.imageUrl,
                          showNewBadge: product.isNew,
                          newBadgeLabel: context.l10n.productNewBadge,
                          quantity: _quantity,
                          onDecrease: () {
                            if (_quantity <= _minQuantity) return;
                            setState(() => _quantity -= 1);
                          },
                          onIncrease: () => setState(() => _quantity += 1),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),
                        ProductDetailDescriptionPanel(
                          whatsThisLabel: context.l10n.productWhatsThis,
                          description: description,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.medium),
                  switchInCurve: AppMotion.standardCurve,
                  switchOutCurve: AppMotion.standardCurve,
                  transitionBuilder: (child, animation) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: AppMotion.standardCurve,
                      ),
                    );
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: ProductDetailFooter(
                    key: const ValueKey('product_detail_cart_footer'),
                    totalLabel: lineTotal,
                    onAddToCart: () => AppToast.show(
                      context,
                      message: context.l10n.addedToCart,
                    ),
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
