class CatalogItem {
  const CatalogItem({
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
  final num discount;
  final double rating;
}
