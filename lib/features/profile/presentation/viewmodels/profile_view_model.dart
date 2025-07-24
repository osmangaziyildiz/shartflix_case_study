import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/features/profile/domain/usecases/get_favorite_movies_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/upload_photo_usecase.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_state.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UploadPhotoUseCase uploadPhotoUseCase;
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;
  late final StreamSubscription _favoriteUpdateSubscription;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.uploadPhotoUseCase,
    required this.getFavoriteMoviesUseCase,
  }) : super(const ProfileState()) {
    _listenToFavoriteUpdates();
  }

  void _listenToFavoriteUpdates() {
    _favoriteUpdateSubscription = sl<StreamController<String>>().stream.listen((event) {
      if (event == 'favorites_updated') {
        fetchFavoriteMovies();
      }
    });
  }

  @override
  Future<void> close() {
    _favoriteUpdateSubscription.cancel();
    return super.close();
  }

  Future<void> fetchFavoriteMovies() async {
    try {
      final movies = await getFavoriteMoviesUseCase();
      emit(state.copyWith(
        status: ProfileStatus.success,
        favoriteMovies: movies,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> fetchProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await getProfileUseCase();
      final movies = await getFavoriteMoviesUseCase();
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          user: user,
          favoriteMovies: movies,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> uploadPhoto(File file) async {
    try {
      // Here we want a loading indicator
      emit(state.copyWith(status: ProfileStatus.loading));
      await uploadPhotoUseCase(file);
      await fetchProfile(); // This will handle the subsequent state updates
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
