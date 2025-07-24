import 'package:dio/dio.dart';
import 'package:shartflix/core/network/api_endpoints.dart';
import 'package:shartflix/features/home/data/models/movie_list_response_model.dart';
import 'package:shartflix/features/home/data/models/toggle_favorite_response_model.dart';

abstract class HomeRemoteDatasource {
  Future<MovieListResponseModel> getMovies(int page);
  Future<ToggleFavoriteResponseModel> toggleFavorite(String movieId);
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final Dio dio;

  const HomeRemoteDatasourceImpl({required this.dio});

  @override
  Future<MovieListResponseModel> getMovies(int page) async {
    try {
      final response = await dio.get('${ApiEndPoints.movieList}?page=$page');
      return MovieListResponseModel.fromJson(response.data['data']);
    } catch (e) {
      // TODO: Add specific error handling like in AuthRemoteDataSource
      rethrow;
    }
  }

  @override
  Future<ToggleFavoriteResponseModel> toggleFavorite(String movieId) async {
    try {
      final response = await dio.post('${ApiEndPoints.toggleFavorite}$movieId');
      return ToggleFavoriteResponseModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
} 