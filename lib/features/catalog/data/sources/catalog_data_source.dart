import '../models/catalog_item_model.dart';

abstract interface class CatalogDataSource {
  Future<List<CatalogItemModel>> getItems();
}
