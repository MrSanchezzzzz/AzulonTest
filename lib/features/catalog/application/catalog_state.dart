import '../presentation/models/catalog_item_presentation_model.dart';

enum CatalogStatus { initial, loading, success, empty, error }

class CatalogState {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.items = const <CatalogItemPresentationModel>[],
    this.favoriteIds = const <int>{},
    this.isRefreshing = false,
    this.isStale = false,
    this.lastUpdatedUtc,
    this.errorMessage,
  });

  final CatalogStatus status;
  final List<CatalogItemPresentationModel> items;
  final Set<int> favoriteIds;
  final bool isRefreshing;
  final bool isStale;
  final DateTime? lastUpdatedUtc;
  final String? errorMessage;

  CatalogState copyWith({
    CatalogStatus? status,
    List<CatalogItemPresentationModel>? items,
    Set<int>? favoriteIds,
    bool? isRefreshing,
    bool? isStale,
    DateTime? lastUpdatedUtc,
    String? errorMessage,
  }) {
    return CatalogState(
      status: status ?? this.status,
      items: items ?? this.items,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isStale: isStale ?? this.isStale,
      lastUpdatedUtc: lastUpdatedUtc ?? this.lastUpdatedUtc,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  CatalogState get noErrors {
    return CatalogState(
      status: status,
      items: items,
      favoriteIds: favoriteIds,
      isRefreshing: isRefreshing,
      isStale: isStale,
      lastUpdatedUtc: lastUpdatedUtc,
      errorMessage: null,
    );
  }
}
