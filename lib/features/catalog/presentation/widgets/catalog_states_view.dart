import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/widgets/app_button.dart';

class CatalogLoadingView extends StatelessWidget {
  const CatalogLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholderColor = colorScheme.surfaceContainerHighest;

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: AppTheme.spacing3,
        mainAxisSpacing: AppTheme.spacing3,
        childAspectRatio: .65,
        maxCrossAxisExtent: 250,
      ),
      itemBuilder: (_, __) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.85),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: AppTheme.cardImageAspectRatio,
                child: Container(
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 120, color: placeholderColor),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 80, color: placeholderColor),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CatalogErrorView extends StatelessWidget {
  const CatalogErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.spacing4),
            SizedBox(
              width: 128,
              child: AppButton.primary(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: 'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogEmptyView extends StatelessWidget {
  const CatalogEmptyView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              'No items found in catalog.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing2),
            Text(
              'Try refreshing to load latest data.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacing4),
            AppButton.secondary(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: 'Refresh',
            ),
          ],
        ),
      ),
    );
  }
}
