import 'package:equatable/equatable.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';
import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfileEntity? user;
  final List<MovieEntity> favoriteMovies;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.favoriteMovies = const [],
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileEntity? user,
    List<MovieEntity>? favoriteMovies,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, favoriteMovies, errorMessage];
}
