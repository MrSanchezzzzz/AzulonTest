import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/catalog_cache_model.dart';
import '../models/catalog_item_model.dart';
import 'catalog_data_source.dart';

class CatalogLocalSource implements CatalogDataSource {
  CatalogLocalSource({required Future<SharedPreferences> sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  static const String storageKey = 'catalog_items_cache';
  static const int cacheVersion = 1;
  final Future<SharedPreferences> _sharedPreferences;

  @override
  Future<List<CatalogItemModel>> getItems() async {
    final cache = await _readCache();
    return cache?.items ?? const <CatalogItemModel>[];
  }

  Future<DateTime?> getLastUpdatedUtc() async {
    final cache = await _readCache();
    if (cache == null) {
      return null;
    }

    try {
      return DateTime.parse(cache.updatedAtUtc).toUtc();
    } catch (error, stackTrace) {
      throw StorageException(
        'Failed to read cached catalog timestamp.',
        error,
        stackTrace,
      );
    }
  }

  Future<void> updateItems(
    List<CatalogItemModel> items,
    DateTime updatedAtUtc,
  ) async {
    final prefs = await _sharedPreferences;
    final cache = CatalogCacheModel(
      version: cacheVersion,
      updatedAtUtc: updatedAtUtc.toUtc().toIso8601String(),
      items: items,
    );
    final payload = jsonEncode(cache.toJson());
    final saved = await prefs.setString(storageKey, payload);

    if (!saved) {
      throw const StorageException('Failed to persist catalog cache.');
    }
  }

  Future<void> clear() async {
    final prefs = await _sharedPreferences;
    final removed = await prefs.remove(storageKey);
    if (!removed) {
      throw const StorageException('Failed to clear catalog cache.');
    }
  }

  Future<CatalogCacheModel?> _readCache() async {
    final prefs = await _sharedPreferences;
    final payload = prefs.getString(storageKey);
    if (payload == null || payload.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final cache = CatalogCacheModel.fromJson(decoded);
      if (cache.version != cacheVersion) {
        return null;
      }
      return cache;
    } on FormatException catch (error, stackTrace) {
      throw StorageException(
        'Failed to decode cached catalog items.',
        error,
        stackTrace,
      );
    } on TypeError catch (error, stackTrace) {
      throw StorageException(
        'Failed to decode cached catalog items.',
        error,
        stackTrace,
      );
    } catch (error, stackTrace) {
      throw StorageException(
        'Failed to read cached catalog items.',
        error,
        stackTrace,
      );
    }
  }
}
