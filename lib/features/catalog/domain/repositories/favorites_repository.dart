abstract class FavoritesRepository {
  Future<Set<int>> getFavoriteIds();

  Future<void> setFavorite(int itemId, bool isFavorite);

  Future<void> toggleFavorite(int itemId);
}
