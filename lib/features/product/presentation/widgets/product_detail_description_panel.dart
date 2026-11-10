import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProductDetailDescriptionPanel extends StatelessWidget {
  const ProductDetailDescriptionPanel({
    super.key,
    required this.whatsThisLabel,
    required this.description,
  });

  final String whatsThisLabel;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppDimens.productDetailHelpColumnWidth,
          child: Column(
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
              const SizedBox(height: AppDimens.spaceSm),
              Text(whatsThisLabel, style: AppTextStyles.bodyBold),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Container(
          width: AppDimens.productDetailHelpDividerWidth,
          height: 72,
          color: AppColors.tierCapsuleBorder,
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(child: Text(description, style: AppTextStyles.body)),
      ],
    );
  }
}
