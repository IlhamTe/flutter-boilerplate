import 'package:dio/dio.dart';

/// A failed API call, as repositories return it inside `Result.error`.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    return ApiException(
      e.message ?? e.type.name,
      statusCode: e.response?.statusCode,
    );
  }

  final String message;

  /// Null when no response came back (timeout, no connection).
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
