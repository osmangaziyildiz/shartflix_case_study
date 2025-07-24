import 'package:shartflix/features/home/data/datasources/home_remote_datasource.dart';
import 'package:shartflix/features/home/domain/entities/movie_list_entity.dart';
import 'package:shartflix/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MovieListEntity> getMovies(int page) async {
    final movieResponseModel = await remoteDataSource.getMovies(page);
    return movieResponseModel.toEntity();
  }
}
