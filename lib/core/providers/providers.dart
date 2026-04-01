import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = defaultDioClient;
  ref.onDispose(() => dio.close(force: true));
  return dio;
});

final sharedPreferencesProvider = Provider<Future<SharedPreferences>>((ref) {
  return SharedPreferences.getInstance();
});
