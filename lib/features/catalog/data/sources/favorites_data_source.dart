abstract interface class FavoritesDataSource {
  Future<Set<int>> getFavorites();

  Future<void> updateFavorites(Set<int> ids);
}
