import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo({
    super.key,
    required this.finalPrice,
    required this.discount,
    this.spacing = 8,
    this.finalPriceStyle,
    this.discountStyle,
    this.discountedFinalPriceColor,
  });

  final num finalPrice;
  final num discount;
  final double spacing;
  final TextStyle? finalPriceStyle;
  final TextStyle? discountStyle;
  final Color? discountedFinalPriceColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final hasDiscount = discount > 0;

    final baseFinalPriceStyle =
        finalPriceStyle ??
        textTheme.titleMedium?.copyWith(
          fontWeight: AppTheme.fontWeightExtraBold,
        );
    final effectiveFinalPriceStyle = hasDiscount && finalPriceStyle == null
        ? baseFinalPriceStyle?.copyWith(color: colors.secondary)
        : hasDiscount && discountedFinalPriceColor != null
        ? baseFinalPriceStyle?.copyWith(color: discountedFinalPriceColor)
        : baseFinalPriceStyle;

    final effectiveDiscountStyle =
        discountStyle ??
        textTheme.bodySmall?.copyWith(
          color: colors.error,
          fontWeight: AppTheme.fontWeightBold,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: spacing,
      children: [
        Text(_asCurrency(finalPrice), style: effectiveFinalPriceStyle),
        if (hasDiscount)
          Text('-${_asCurrency(discount)}', style: effectiveDiscountStyle),
      ],
    );
  }

  String _asCurrency(num value) => '\$${value.toStringAsFixed(2)}';
}
