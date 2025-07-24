import 'package:dio/dio.dart';
import 'package:shartflix/core/network/api_endpoints.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/auth/data/models/login_request_model.dart';
import 'package:shartflix/features/auth/data/models/login_response_model.dart';
import 'package:shartflix/features/auth/data/models/register_request_model.dart';
import 'package:shartflix/features/auth/data/models/register_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegisterResponseModel> register(RegisterRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post(ApiEndPoints.login, data: request.toJson());
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginError(e);
    }
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post(ApiEndPoints.register, data: request.toJson());
      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRegisterError(e);
    }
  }

  Exception _handleLoginError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Bağlantı zaman aşımı'.localized);
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 400) {
          return Exception('Email veya şifre hatalı'.localized);
        } else if (statusCode == 500) {
          return Exception('Sunucu hatası'.localized);
        }
        return Exception('Bir hata oluştu: $statusCode'.localized);
      default:
        return Exception('İnternet bağlantınızı kontrol edin'.localized);
    }
  }

  Exception _handleRegisterError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Bağlantı zaman aşımı'.localized);
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 400) {
          return Exception('Bu e-posta ile zaten bir hesap var.'.localized);
        } else if (statusCode == 500) {
          return Exception('Sunucu hatası'.localized);
        }
        return Exception('Bir hata oluştu: $statusCode'.localized);
      default:
        return Exception('İnternet bağlantınızı kontrol edin'.localized);
    }
  }
}
