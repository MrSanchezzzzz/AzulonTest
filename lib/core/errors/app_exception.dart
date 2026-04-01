import 'package:dio/dio.dart';

abstract interface class AppException implements Exception {
  String get userMessage;
}

final class NetworkException extends DioException implements AppException {
  NetworkException({
    required super.requestOptions,
    super.type = DioExceptionType.connectionError,
    super.error,
    super.stackTrace,
    String? userMessage,
  }) : _userMessage =
           userMessage ??
           'Unable to reach server. Check your internet connection.',
       super(
         message:
             userMessage ??
             'Unable to reach server. Check your internet connection.',
       );

  final String _userMessage;

  @override
  String get userMessage => _userMessage;
}

final class ServerException extends DioException implements AppException {
  ServerException({
    required super.requestOptions,
    required int? statusCode,
    Response<dynamic>? response,
    super.error,
    super.stackTrace,
    String? userMessage,
  }) : _userMessage = userMessage ?? _defaultServerMessage(statusCode),
       super(
         response:
             response ??
             Response<dynamic>(
               requestOptions: requestOptions,
               statusCode: statusCode,
             ),
         type: DioExceptionType.badResponse,
         message: userMessage ?? _defaultServerMessage(statusCode),
       );

  final String _userMessage;

  @override
  String get userMessage => _userMessage;

  static String _defaultServerMessage(int? statusCode) {
    final code = statusCode?.toString() ?? 'unknown';
    return 'Server request failed with code $code.';
  }
}

final class ParsingException extends FormatException implements AppException {
  const ParsingException([
    super.message = 'Received invalid data from server.',
    super.source,
    super.offset,
  ]);

  @override
  String get userMessage => message;
}

final class StorageException implements AppException {
  const StorageException([
    this.userMessage = 'Unable to save local data.',
    this.error,
    this.stackTrace,
  ]);

  @override
  final String userMessage;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => userMessage;
}

final class UnknownAppException implements AppException {
  const UnknownAppException({
    this.userMessage = 'Something went wrong. Please try again.',
    this.error,
    this.stackTrace,
  });

  @override
  final String userMessage;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => userMessage;
}
