import 'catalog_item_model.dart';

class CatalogCacheModel {
  const CatalogCacheModel({
    required this.version,
    required this.updatedAtUtc,
    required this.items,
  });

  final int version;
  final String updatedAtUtc;
  final List<CatalogItemModel> items;

  factory CatalogCacheModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;

    return CatalogCacheModel(
      version: json['version'] as int,
      updatedAtUtc: json['updatedAtUtc'] as String,
      items: rawItems
          .map(
            (item) =>
                CatalogItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'version': version,
      'updatedAtUtc': updatedAtUtc,
      'items': items.map((item) => item.toJson()).toList(growable: false),
    };
  }
}
