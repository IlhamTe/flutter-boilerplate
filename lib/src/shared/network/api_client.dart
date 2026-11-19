import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract final class ApiClient {
  static Dio create({required String baseUrl}) {
    return Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      )
      ..interceptors.addAll([
        // Bodies can hold tokens and personal data: log them in debug only.
        if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }
}
