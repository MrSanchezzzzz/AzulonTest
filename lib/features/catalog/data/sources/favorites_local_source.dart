import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/app_exception.dart';
import 'favorites_data_source.dart';

class FavoritesLocalSource implements FavoritesDataSource {
  FavoritesLocalSource({required Future<SharedPreferences> sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  static const String storageKey = 'favorite_item_ids_v1';
  final Future<SharedPreferences> _sharedPreferences;

  @override
  Future<Set<int>> getFavorites() async {
    final prefs = await _sharedPreferences;
    final stored = prefs.getStringList(storageKey) ?? const <String>[];
    return stored.map(int.parse).toSet();
  }

  @override
  Future<void> updateFavorites(Set<int> ids) async {
    final prefs = await _sharedPreferences;
    final value = ids.toList()..sort();
    final saved = await prefs.setStringList(
      storageKey,
      value.map((id) => id.toString()).toList(growable: false),
    );

    if (!saved) {
      throw const StorageException('Failed to persist favorites.');
    }
  }
}
