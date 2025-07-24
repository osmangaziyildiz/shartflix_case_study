import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';
import 'dart:io';
 
abstract class ProfileRepository {
  Future<UserProfileEntity> getProfile();
  Future<UserProfileEntity> uploadPhoto(File file);
  Future<List<MovieEntity>> getFavoriteMovies();
} 