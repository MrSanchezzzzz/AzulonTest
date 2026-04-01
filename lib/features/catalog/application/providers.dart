import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/providers.dart';
import '../data/repositories/catalog_repository_impl.dart';
import '../data/repositories/favorites_repository_local_impl.dart';
import '../data/sources/catalog_data_source.dart';
import '../data/sources/catalog_local_source.dart';
import '../data/sources/catalog_remote_source.dart';
import '../data/sources/favorites_data_source.dart';
import '../data/sources/favorites_local_source.dart';
import '../domain/repositories/catalog_repository.dart';
import '../domain/repositories/favorites_repository.dart';
import 'catalog_controller.dart';
import 'catalog_state.dart';

final catalogRemoteSourceProvider = Provider<CatalogDataSource>((ref) {
  return CatalogRemoteSource(dio: ref.watch(dioProvider));
});

final catalogLocalSourceProvider = Provider<CatalogLocalSource>((ref) {
  return CatalogLocalSource(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final favoritesLocalSourceProvider = Provider<FavoritesDataSource>((ref) {
  return FavoritesLocalSource(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl(
    remoteSource: ref.watch(catalogRemoteSourceProvider),
    localSource: ref.watch(catalogLocalSourceProvider),
  );
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryLocalImpl(
    localSource: ref.watch(favoritesLocalSourceProvider),
  );
});

final catalogControllerProvider =
    StateNotifierProvider<CatalogController, CatalogState>((ref) {
  return CatalogController(
    catalogRepository: ref.watch(catalogRepositoryProvider),
    favoritesRepository: ref.watch(favoritesRepositoryProvider),
  );
});
