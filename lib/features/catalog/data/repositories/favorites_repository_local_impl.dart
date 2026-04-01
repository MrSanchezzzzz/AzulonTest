import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../sources/favorites_data_source.dart';

class FavoritesRepositoryLocalImpl implements FavoritesRepository {
  FavoritesRepositoryLocalImpl({required FavoritesDataSource localSource})
      : _localSource = localSource;

  final FavoritesDataSource _localSource;

  @override
  Future<Set<int>> getFavoriteIds() async {
    try {
      return await _localSource.getFavorites();
    } on StorageException {
      rethrow;
    } catch (error, stackTrace) {
      throw StorageException(
        'Failed to read favorite items.',
        error,
        stackTrace,
      );
    }
  }

  @override
  Future<void> setFavorite(int itemId, bool isFavorite) async {
    try {
      final ids = await _localSource.getFavorites();
      final updated = Set<int>.from(ids);

      if (isFavorite) {
        updated.add(itemId);
      } else {
        updated.remove(itemId);
      }

      await _localSource.updateFavorites(updated);
    } on StorageException {
      rethrow;
    } catch (error, stackTrace) {
      throw StorageException(
        'Failed to update favorite item.',
        error,
        stackTrace,
      );
    }
  }

  @override
  Future<void> toggleFavorite(int itemId) async {
    try {
      final ids = await _localSource.getFavorites();
      final updated = Set<int>.from(ids);

      if (updated.contains(itemId)) {
        updated.remove(itemId);
      } else {
        updated.add(itemId);
      }

      await _localSource.updateFavorites(updated);
    } on StorageException {
      rethrow;
    } catch (error, stackTrace) {
      throw StorageException(
        'Failed to update favorite item.',
        error,
        stackTrace,
      );
    }
  }
}
