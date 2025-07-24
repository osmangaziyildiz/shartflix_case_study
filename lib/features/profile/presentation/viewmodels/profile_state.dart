import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileEntity user;
  final List<MovieEntity> favoriteMovies;
  ProfileLoaded({required this.user, required this.favoriteMovies});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
