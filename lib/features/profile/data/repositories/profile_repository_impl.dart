import 'package:shartflix/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';
import 'package:shartflix/features/profile/domain/repositories/profile_repository.dart';
import 'dart:io';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getProfile() async {
    final model = await remoteDataSource.getProfile();
    return model.toEntity();
  }

  @override
  Future<UserProfileEntity> uploadPhoto(File file) async {
    final model = await remoteDataSource.uploadPhoto(file);
    return model.toEntity();
  }

  @override
  Future<List<MovieEntity>> getFavoriteMovies() async {
    final models = await remoteDataSource.getFavoriteMovies();
    return models.map((model) => model.toEntity()).toList();
  }
} 