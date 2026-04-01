class CatalogItemPresentationModel {
  const CatalogItemPresentationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.basePrice,
    required this.discount,
    required this.finalPrice,
    required this.imageUrl,
    required this.rating,
  });

  final int id;
  final String name;
  final String description;
  final String category;
  final num basePrice;
  final num discount;
  final num finalPrice;
  final String imageUrl;
  final double rating;

  String get imageHeroTag => 'catalog-item-image-$id';
}
