import 'package:dio/dio.dart';
import 'package:shartflix/core/error/exceptions.dart';
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
      throw ServerException.fromDioException(e, customMessages: {
        400: 'Email veya şifre hatalı'.localized,
        500: 'Sunucuda bir sorun oluştu, lütfen daha sonra tekrar deneyin.'.localized,
      });
    }
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post(ApiEndPoints.register, data: request.toJson());
      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e, customMessages: {
        400: 'Bu e-posta ile zaten bir hesap var.'.localized,
        500: 'Sunucuda bir sorun oluştu, lütfen daha sonra tekrar deneyin.'.localized,
      });
    }
  }
}
