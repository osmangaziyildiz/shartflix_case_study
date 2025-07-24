import 'package:shartflix/core/error/exceptions.dart';
import 'package:shartflix/core/network/api_endpoints.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/profile/data/models/user_profile_model.dart';
import 'package:shartflix/features/profile/data/models/movie_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> uploadPhoto(File file);
  Future<List<MovieModel>> getFavoriteMovies();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final response = await dio.get(ApiEndPoints.myProfile);
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e, customMessages: {
        400: 'Beklenmedik bir hata oluştu'.localized,
        401: 'Lütfen hesabınızdan çıkıp tekrar giriş yapınız'.localized,
        500: 'Sunucuda bir sorun oluştu, lütfen daha sonra tekrar deneyin.'.localized,
      });
    }
  }

  @override
  Future<UserProfileModel> uploadPhoto(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });
      final response = await dio.post(ApiEndPoints.uploadPhoto, data: formData);
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e, customMessages: {
        400: 'Beklenmedik bir hata oluştu'.localized,
        401: 'Lütfen hesabınızdan çıkıp tekrar giriş yapınız'.localized,
        500: 'Sunucuda bir sorun oluştu, lütfen daha sonra tekrar deneyin.'.localized,
      });
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    try {
      final response = await dio.get(ApiEndPoints.getFavoriteMovies);
      final data = response.data['data'] as List;
      return data.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException.fromDioException(e, customMessages: {
        400: 'Beklenmedik bir hata oluştu'.localized,
        401: 'Lütfen hesabınızdan çıkıp tekrar giriş yapınız'.localized,
        500: 'Sunucuda bir sorun oluştu, lütfen daha sonra tekrar deneyin.'.localized,
      });
    }
  }
} 