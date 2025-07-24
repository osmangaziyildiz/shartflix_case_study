import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/upload_photo_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/get_favorite_movies_usecase.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_state.dart';
import 'dart:io';

class ProfileViewModel extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UploadPhotoUseCase uploadPhotoUseCase;
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;
  ProfileViewModel({
    required this.getProfileUseCase,
    required this.uploadPhotoUseCase,
    required this.getFavoriteMoviesUseCase,
  }) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    try {
      emit(ProfileLoading());
      final user = await getProfileUseCase();
      final movies = await getFavoriteMoviesUseCase();
      emit(ProfileLoaded(user: user, favoriteMovies: movies));
    } catch (e) {
      emit(ProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> uploadPhoto(File file) async {
    try {
      emit(ProfileLoading());
      await uploadPhotoUseCase(file);
      await fetchProfile();
    } catch (e) {
      emit(ProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
