import 'package:dio/dio.dart';

final Dio defaultDioClient = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    responseType: ResponseType.json,
    validateStatus: (_) => true,
  ),
);
