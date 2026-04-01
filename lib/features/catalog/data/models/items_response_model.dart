import 'catalog_item_model.dart';

enum CatalogApiStatus {
  success,
}

class ItemsResponseModel {
  ItemsResponseModel({
    required this.status,
    required this.total,
    required this.items,
  });

  final String status;
  final int total;
  final List<CatalogItemModel> items;

  factory ItemsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;

    return ItemsResponseModel(
      status: json['status'] as String,
      total: json['total'] as int,
      items: rawItems
          .map(
            (item) =>
                CatalogItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }
}
