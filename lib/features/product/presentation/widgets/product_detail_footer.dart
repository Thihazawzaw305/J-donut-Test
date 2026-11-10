import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProductDetailFooter extends StatelessWidget {
  const ProductDetailFooter({
    super.key,
    required this.totalLabel,
    required this.onAddToCart,
  });

  final String totalLabel;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(32),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onAddToCart,
            child: SizedBox(
              height: AppDimens.buttonHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        context.l10n.addToCart,
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 28, color: AppColors.onPrimary),
                  Expanded(
                    child: Center(
                      child: Text(totalLabel, style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
