import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/models/catalog_items_snapshot.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../models/catalog_item_model.dart';
import '../sources/catalog_data_source.dart';
import '../sources/catalog_local_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({
    required CatalogDataSource remoteSource,
    required CatalogLocalSource localSource,
    this.hardTtl = const Duration(hours: 1),
  }) : _remoteSource = remoteSource,
       _localSource = localSource;

  final CatalogDataSource _remoteSource;
  final CatalogLocalSource _localSource;
  final Duration hardTtl;

  List<CatalogItem>? _memoryItems;
  DateTime? _memoryUpdatedAtUtc;

  @override
  Future<CatalogItemsSnapshot> fetchItems() async {
    if (_memoryItems != null && _memoryUpdatedAtUtc != null) {
      return CatalogItemsSnapshot(
        items: _memoryItems!,
        source: CatalogLoadSource.cache,
        lastUpdatedUtc: _memoryUpdatedAtUtc,
        isStale: _isStale(_memoryUpdatedAtUtc),
      );
    }

    try {
      final cachedModels = await _localSource.getItems();
      final updatedAtUtc = await _localSource.getLastUpdatedUtc();
      if (updatedAtUtc != null) {
        final cachedItems = _mapModelsToEntities(cachedModels);
        _saveMemoryCache(cachedItems, updatedAtUtc);

        return CatalogItemsSnapshot(
          items: cachedItems,
          source: CatalogLoadSource.cache,
          lastUpdatedUtc: updatedAtUtc,
          isStale: _isStale(updatedAtUtc),
        );
      }
    } on StorageException {
      await _tryClearLocalCache();
    } catch (_) {
      await _tryClearLocalCache();
    }

    return refreshItems();
  }

  @override
  Future<CatalogItemsSnapshot> refreshItems() async {
    final models = await _remoteSource.getItems();
    final items = _mapModelsToEntities(models);
    final nowUtc = DateTime.now().toUtc();

    _saveMemoryCache(items, nowUtc);
    await _tryPersistCache(models, nowUtc);

    return CatalogItemsSnapshot(
      items: items,
      source: CatalogLoadSource.network,
      lastUpdatedUtc: nowUtc,
      isStale: false,
    );
  }

  CatalogItem _mapModelToEntity(CatalogItemModel model) {
    return CatalogItem(
      id: model.id,
      name: model.name,
      description: model.description,
      category: model.category,
      price: model.price,
      discount: model.discount ?? 0,
      rating: model.rating ?? 0,
    );
  }

  List<CatalogItem> _mapModelsToEntities(List<CatalogItemModel> models) {
    return models.map<CatalogItem>(_mapModelToEntity).toList(growable: false);
  }

  bool _isStale(DateTime? updatedAtUtc) {
    if (updatedAtUtc == null) {
      return true;
    }
    return DateTime.now().toUtc().difference(updatedAtUtc) > hardTtl;
  }

  void _saveMemoryCache(List<CatalogItem> items, DateTime updatedAtUtc) {
    _memoryItems = items;
    _memoryUpdatedAtUtc = updatedAtUtc;
  }

  Future<void> _tryPersistCache(
    List<CatalogItemModel> models,
    DateTime updatedAtUtc,
  ) async {
    try {
      await _localSource.updateItems(models, updatedAtUtc);
    } on StorageException {
      // Cache write failure should not block rendering fresh network data.
    } catch (_) {
      // Cache write failure should not block rendering fresh network data.
    }
  }

  Future<void> _tryClearLocalCache() async {
    try {
      await _localSource.clear();
    } catch (_) {
      // Ignore cleanup failures and continue with remote fetch.
    }
  }
}
