class CatalogItemModel {
  CatalogItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.discount,
    required this.rating,
  });

  final int id;
  final String name;
  final String description;
  final String category;
  final num price;
  final num? discount;
  final double? rating;

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: json['price'] as num,
      discount: json['discount'] as num?,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'discount': discount,
      'rating': rating,
    };
  }
}
