import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  factory ServerException.fromDioException(
    DioException error, {
    Map<int, String>? customMessages,
  }) {
    // 1. Check for custom message first
    if (error.response?.statusCode != null &&
        customMessages != null &&
        customMessages.containsKey(error.response!.statusCode)) {
      return ServerException(
        message: customMessages[error.response!.statusCode]!,
        statusCode: error.response!.statusCode,
      );
    }

    // 2. Try to parse the standard API error response
    try {
      final responseData = error.response?.data;
      if (responseData != null && responseData['response']['message'] != null) {
        return ServerException(
          message: responseData['response']['message'],
          statusCode: responseData['response']['code'],
        );
      }
    } catch (_) {
      // Fallback if parsing fails
    }

    // 3. Fallback to generic Dio error types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException(message: 'Bağlantı zaman aşımı.');
      case DioExceptionType.cancel:
        return const ServerException(message: 'İstek iptal edildi.');
      default:
        return ServerException(
          message: 'Bir hata oluştu. Lütfen tekrar deneyin.',
          statusCode: error.response?.statusCode,
        );
    }
  }

  @override
  List<Object?> get props => [message, statusCode];
} 