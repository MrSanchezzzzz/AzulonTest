import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/widgets/app_button.dart';
import '../../application/providers.dart';
import '../models/catalog_item_presentation_model.dart';
import '../widgets/price_info.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  static const double _appBarTransitionOffset = 140;

  late final ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final double offset = _scrollController.hasClients
        ? _scrollController.offset
        : 0;
    final double normalizedOffset = offset < 0 ? 0 : offset;
    if ((normalizedOffset - _scrollOffset).abs() < 0.5) {
      return;
    }

    setState(() {
      _scrollOffset = normalizedOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)?.settings.arguments;
    if (item is! CatalogItemPresentationModel) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item Details')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48),
                const SizedBox(height: AppTheme.spacing3),
                const Text('Unable to open item details.'),
                const SizedBox(height: AppTheme.spacing3),
                AppButton.primary(
                  onPressed: () => Navigator.of(context).maybePop(),
                  label: 'Go Back',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isFavorite = ref.watch(
      catalogControllerProvider.select(
        (state) => state.favoriteIds.contains(item.id),
      ),
    );
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;
    const minOverlayHeight = 120.0;
    final imageHeight = (MediaQuery.sizeOf(context).height * 0.45)
        .clamp(260.0, 360.0)
        .toDouble();
    final overlayStart = (imageHeight * (2 / 3))
        .clamp(0.0, imageHeight - minOverlayHeight)
        .toDouble();
    final appBarOpacityStartOffset = imageHeight * 0.1;
    final appBarOpacity =
        ((_scrollOffset - appBarOpacityStartOffset) / _appBarTransitionOffset)
            .clamp(0.0, 1.0);
    final appBarColor = AppTheme.appBg.withAlpha(
      (255 * appBarOpacity).truncate(),
    );
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: appBarColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () {
              unawaited(_onFavoriteTap(ref, item.id));
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey<bool>(isFavorite),
                color: isFavorite ? AppTheme.primary : null,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: Hero(
                        tag: item.imageHeroTag,
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) {
                            return ColoredBox(
                              color: colors.surface,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 42,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: overlayStart,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.appBg.withAlpha(192),
                              AppTheme.appBg,
                            ],
                            begin: AlignmentGeometry.topCenter,
                            end: AlignmentGeometry.bottomCenter,
                            stops: [0, .25, .75],
                          ),
                        ),
                        padding: EdgeInsets.only(
                          left: AppTheme.spacing4 + viewPadding.left,
                          right: AppTheme.spacing4 + viewPadding.right,
                          top: AppTheme.spacing4,
                          bottom: AppTheme.spacing6,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: AppTheme.fontWeightBold,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing3),
                            PriceInfo(
                              finalPrice: item.finalPrice,
                              discount: item.discount,
                              spacing: 10,
                              finalPriceStyle: textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: AppTheme.fontWeightExtraBold,
                                    color: colors.primary,
                                  ),
                              discountStyle: textTheme.bodyLarge?.copyWith(
                                color: colors.error,
                                fontWeight: AppTheme.fontWeightBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: AppTheme.spacing4 + viewPadding.left,
                    right: AppTheme.spacing4 + viewPadding.right,
                    bottom: AppTheme.spacing6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall,
                          ),
                        ),
                        child: Text(item.category, style: textTheme.labelLarge),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        item.description,
                        style: textTheme.bodyLarge?.copyWith(
                          height: AppTheme.lineHeightRelaxed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onFavoriteTap(WidgetRef ref, int itemId) async {
    try {
      await ref.read(catalogControllerProvider.notifier).toggleFavorite(itemId);
    } catch (_) {
      // Intentionally silent on details screen.
    }
  }
}
