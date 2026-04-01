import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/routes.dart';
import '../../../../core/errors/app_exception.dart';
import '../../application/catalog_state.dart';
import '../../application/providers.dart';
import '../models/catalog_item_presentation_model.dart';
import '../widgets/catalog_item_card.dart';
import '../widgets/catalog_states_view.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(catalogControllerProvider.notifier).loadCatalog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(catalogControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: switch (state.status) {
          CatalogStatus.initial ||
          CatalogStatus.loading => const CatalogLoadingView(),
          CatalogStatus.error => CatalogErrorView(
            message: state.errorMessage ?? 'Unable to load catalog items.',
            onRetry: () => ref.read(catalogControllerProvider.notifier).retry(),
          ),
          CatalogStatus.empty => CatalogEmptyView(
            onRetry: () => ref.read(catalogControllerProvider.notifier).retry(),
          ),
          CatalogStatus.success => _CatalogGrid(
            items: state.items,
            isRefreshing: state.isRefreshing,
            isStale: state.isStale,
            lastUpdatedUtc: state.lastUpdatedUtc,
          ),
        },
      ),
    );
  }
}

class _CatalogGrid extends ConsumerWidget {
  const _CatalogGrid({
    required this.items,
    required this.isRefreshing,
    required this.isStale,
    required this.lastUpdatedUtc,
  });

  final List<CatalogItemPresentationModel> items;
  final bool isRefreshing;
  final bool isStale;
  final DateTime? lastUpdatedUtc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (isRefreshing) const LinearProgressIndicator(minHeight: 2),
        if (isStale) _StaleDataBanner(lastUpdatedUtc: lastUpdatedUtc),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(catalogControllerProvider.notifier).loadCatalog(),
            child: GridView.builder(
              padding: EdgeInsets.only(
                left: AppTheme.spacing4,
                right: AppTheme.spacing4,
                top: AppTheme.spacing4 + (!isRefreshing ? 2 : 0),
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                crossAxisSpacing: AppTheme.spacing3,
                mainAxisSpacing: AppTheme.spacing3,
                childAspectRatio: .65,
                maxCrossAxisExtent: 250,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final isFavorite = ref.watch(
                  catalogControllerProvider.select(
                    (state) => state.favoriteIds.contains(item.id),
                  ),
                );

                return CatalogItemCard(
                  item: item,
                  isFavorite: isFavorite,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(Routes.details, arguments: item);
                  },
                  onFavoriteTap: () {
                    unawaited(_onFavoriteTap(context, ref, item.id));
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onFavoriteTap(
    BuildContext context,
    WidgetRef ref,
    int itemId,
  ) async {
    try {
      await ref.read(catalogControllerProvider.notifier).toggleFavorite(itemId);
    } on AppException catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.userMessage)));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
    }
  }
}

class _StaleDataBanner extends StatelessWidget {
  const _StaleDataBanner({required this.lastUpdatedUtc});

  final DateTime? lastUpdatedUtc;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final updatedAtText = lastUpdatedUtc == null
        ? 'unknown time'
        : _asLocalTimestamp(lastUpdatedUtc!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing4,
        vertical: AppTheme.spacing2,
      ),
      color: colorScheme.surface,
      child: Text(
        'Showing cached data (updated $updatedAtText).',
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: AppTheme.fontWeightSemiBold,
        ),
      ),
    );
  }

  String _asLocalTimestamp(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$month/$day ${local.year} $hour:$minute';
  }
}
