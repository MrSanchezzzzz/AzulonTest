import '../models/catalog_items_snapshot.dart';

abstract class CatalogRepository {
  Future<CatalogItemsSnapshot> fetchItems();

  Future<CatalogItemsSnapshot> refreshItems();
}
