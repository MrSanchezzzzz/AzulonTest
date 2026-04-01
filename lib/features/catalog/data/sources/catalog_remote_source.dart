import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/catalog_item_model.dart';
import '../models/items_response_model.dart';
import 'catalog_data_source.dart';

class CatalogRemoteSource implements CatalogDataSource {
  static const String defaultEndpoint =
      'https://azulonstudio.github.io/azulon-flutter-test-api/api/items.json';
  static const int defaultMaxRetries = 2;
  CatalogRemoteSource({
    required Dio dio,
    this.endpoint = defaultEndpoint,
    this.maxRetries = defaultMaxRetries,
  }) : _dio = dio;

  final Dio _dio;
  final String endpoint;
  final int maxRetries;

  @override
  Future<List<CatalogItemModel>> getItems() async {
    var attempt = 0;

    while (true) {
      try {
        final response = await _dio.get<dynamic>(endpoint);
        final statusCode = response.statusCode ?? 0;

        if (statusCode < 200 || statusCode >= 300) {
          if (_canRetryStatus(statusCode) && attempt < maxRetries) {
            attempt += 1;
            await _applyBackoff(attempt);
            continue;
          }

          throw ServerException(
            requestOptions: response.requestOptions,
            statusCode: statusCode,
            response: response,
          );
        }

        final payload = ItemsResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        if (payload.status.toLowerCase() != CatalogApiStatus.success.name) {
          throw ParsingException('Unexpected API status: ${payload.status}');
        }

        return payload.items.toList(growable: false);
      } on DioException catch (error) {
        if (_shouldRetryDioException(error) && attempt < maxRetries) {
          attempt += 1;
          await _applyBackoff(attempt);
          continue;
        }
        throw _mapDioException(error);
      } on ParsingException {
        rethrow;
      } on TypeError {
        throw const ParsingException();
      } on FormatException catch (error) {
        throw ParsingException(error.message, error.source, error.offset);
      } catch (error, stackTrace) {
        throw UnknownAppException(error: error, stackTrace: stackTrace);
      }
    }
  }

  bool _canRetryStatus(int statusCode) => statusCode >= 500;

  bool _shouldRetryDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        return statusCode >= 500;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return false;
    }
  }

  AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(
          requestOptions: error.requestOptions,
          type: error.type,
          error: error.error,
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          requestOptions: error.requestOptions,
          statusCode: error.response?.statusCode,
          response: error.response,
          error: error.error,
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return UnknownAppException(
          error: error.error,
          stackTrace: error.stackTrace,
        );
    }
  }

  Future<void> _applyBackoff(int attempt) {
    final delay = Duration(milliseconds: 250 * attempt);
    return Future<void>.delayed(delay);
  }
}
