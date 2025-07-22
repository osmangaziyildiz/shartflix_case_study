import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  static const String _baseUrl = "https://caseapi.servicelabs.tech/";

  late final Dio _dio;

  // Private constructor for singleton
  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {"Content-Type": "application/json"},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🚀 REQUEST: ${options.method} ${options.path}');
          debugPrint('📤 Headers: ${options.headers}');
          if (options.data != null) {
            debugPrint('📦 Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
          );
          debugPrint('📥 Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('❌ ERROR: ${e.message}');
          debugPrint('🔍 Path: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
  }

  // Singleton instance
  static final DioClient _instance = DioClient._();
  static DioClient get instance => _instance;

  Dio get dio => _dio;
}
