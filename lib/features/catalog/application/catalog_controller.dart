import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/models/catalog_items_snapshot.dart';
import '../domain/repositories/catalog_repository.dart';
import '../domain/repositories/favorites_repository.dart';
import '../presentation/models/catalog_item_presentation_model.dart';
import 'catalog_state.dart';

class CatalogController extends StateNotifier<CatalogState> {
  CatalogController({
    required CatalogRepository catalogRepository,
    required FavoritesRepository favoritesRepository,
  }) : _catalogRepository = catalogRepository,
       _favoritesRepository = favoritesRepository,
       super(const CatalogState());

  final CatalogRepository _catalogRepository;
  final FavoritesRepository _favoritesRepository;
  bool _isBackgroundRefreshing = false;

  Future<void> loadCatalog() async {
    if (state.status == CatalogStatus.loading) {
      return;
    }

    state = const CatalogState(status: CatalogStatus.loading);
    var favoriteIds = <int>{};

    try {
      favoriteIds = await _favoritesRepository.getFavoriteIds();
    } catch (_) {
      favoriteIds = <int>{};
    }

    try {
      final snapshot = await _catalogRepository.fetchItems();
      final presentationItems = snapshot.items
          .map<CatalogItemPresentationModel>(_mapToPresentationItem)
          .toList(growable: false);
      final nextStatus = presentationItems.isEmpty
          ? CatalogStatus.empty
          : CatalogStatus.success;
      final fromCache = snapshot.source == CatalogLoadSource.cache;

      state = CatalogState(
        status: nextStatus,
        items: presentationItems,
        favoriteIds: favoriteIds,
        isRefreshing: fromCache,
        isStale: snapshot.isStale,
        lastUpdatedUtc: snapshot.lastUpdatedUtc,
      );

      if (fromCache) {
        unawaited(_refreshInBackground());
      }
    } on AppException catch (error) {
      state = CatalogState(
        status: CatalogStatus.error,
        favoriteIds: favoriteIds,
        errorMessage: error.userMessage,
      );
    } catch (_) {
      state = CatalogState(
        status: CatalogStatus.error,
        favoriteIds: favoriteIds,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> retry() => loadCatalog();

  bool isFavorite(int itemId) => state.favoriteIds.contains(itemId);

  Future<void> toggleFavorite(int itemId) async {
    final wasFavorite = state.favoriteIds.contains(itemId);
    final updated = Set<int>.from(state.favoriteIds);

    if (wasFavorite) {
      updated.remove(itemId);
    } else {
      updated.add(itemId);
    }

    state = state.copyWith(favoriteIds: updated);

    try {
      await _favoritesRepository.setFavorite(itemId, !wasFavorite);
    } catch (_) {
      final rollback = Set<int>.from(state.favoriteIds);
      if (wasFavorite) {
        rollback.add(itemId);
      } else {
        rollback.remove(itemId);
      }

      state = state.copyWith(favoriteIds: rollback);
      rethrow;
    }
  }

  Future<void> _refreshInBackground() async {
    if (_isBackgroundRefreshing) {
      return;
    }

    _isBackgroundRefreshing = true;
    try {
      final snapshot = await _catalogRepository.refreshItems();
      final presentationItems = snapshot.items
          .map<CatalogItemPresentationModel>(_mapToPresentationItem)
          .toList(growable: false);
      final nextStatus = presentationItems.isEmpty
          ? CatalogStatus.empty
          : CatalogStatus.success;

      state = CatalogState(
        status: nextStatus,
        items: presentationItems,
        favoriteIds: state.favoriteIds,
        isRefreshing: false,
        isStale: snapshot.isStale,
        lastUpdatedUtc: snapshot.lastUpdatedUtc,
      );
    } catch (_) {
      state = state.copyWith(isRefreshing: false);
    } finally {
      _isBackgroundRefreshing = false;
    }
  }

  CatalogItemPresentationModel _mapToPresentationItem(CatalogItem item) {
    final basePrice = item.price;
    final discount = item.discount;
    final finalPrice = max<num>(0, basePrice - discount);
    final imageSeed = Uri.encodeComponent('item-${item.id}');

    return CatalogItemPresentationModel(
      id: item.id,
      name: item.name,
      description: item.description,
      category: item.category,
      basePrice: basePrice,
      discount: discount,
      finalPrice: finalPrice,
      imageUrl: 'https://picsum.photos/seed/$imageSeed/900/600',
      rating: item.rating,
    );
  }
}
