import 'package:azulon_test/app/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../models/catalog_item_presentation_model.dart';
import 'price_info.dart';

class CatalogItemCard extends StatelessWidget {
  const CatalogItemCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final CatalogItemPresentationModel item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.controlsBg,
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: AppTheme.cardImageAspectRatio,
                  child: Hero(
                    tag: item.imageHeroTag,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return ColoredBox(
                          color: AppTheme.controlsBg,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, _, __) {
                        return ColoredBox(
                          color: AppTheme.controlsBg,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 36,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 0,
                  top: 0,
                  child: IconButton(
                    tooltip: isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                    onPressed: onFavoriteTap,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        key: ValueKey<bool>(isFavorite),
                        color: isFavorite ? AppTheme.primary : AppTheme.outline,
                      ),
                    ),
                  ),
                ),
                Positioned.directional(
                  top: 0,
                  start: 0,
                  textDirection: Directionality.of(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.controlsBg,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(AppTheme.radiusSmall),
                        bottomEnd: Radius.circular(AppTheme.radiusSmall),
                      ),
                    ),
                    child: Text(
                      item.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacing2),
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        height: AppTheme.lineHeightTight,
                      ),
                    ),
                    Spacer(),
                    PriceInfo(
                      finalPrice: item.finalPrice,
                      discount: item.discount,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppTheme.spacing2,
                right: AppTheme.spacing2,
                bottom: AppTheme.spacing,
              ),
              child: AppButton.primary(
                label: 'View',
                onPressed: onTap,
                isExpanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
