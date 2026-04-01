import '../entities/catalog_item.dart';

enum CatalogLoadSource { cache, network }

class CatalogItemsSnapshot {
  const CatalogItemsSnapshot({
    required this.items,
    required this.source,
    required this.lastUpdatedUtc,
    required this.isStale,
  });

  final List<CatalogItem> items;
  final CatalogLoadSource source;
  final DateTime? lastUpdatedUtc;
  final bool isStale;
}
