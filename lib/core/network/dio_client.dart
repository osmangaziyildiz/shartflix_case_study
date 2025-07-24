import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static const String _baseUrl = "https://caseapi.servicelabs.tech/";

  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Private constructor for singleton
  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {"Content-Type": "application/json"},
      ),
    );

    // Token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Token'ı storage'dan oku ve header'a ekle
          final token = await _secureStorage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
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
