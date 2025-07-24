import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:shartflix/features/home/domain/usecases/toggle_favorite_usecase.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_event.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_state.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final GetMoviesUsecase _getMoviesUsecase;
  final ToggleFavoriteUsecase _toggleFavoriteUsecase;
  bool _isFetching = false;

  HomeViewModel({
    required GetMoviesUsecase getMoviesUsecase,
    required ToggleFavoriteUsecase toggleFavoriteUsecase,
  }) : _getMoviesUsecase = getMoviesUsecase,
       _toggleFavoriteUsecase = toggleFavoriteUsecase,
       super(const HomeState()) {
    on<FetchMovies>(_onFetchMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final updatedMovie = await _toggleFavoriteUsecase.call(event.movieId);

      final List<MovieEntity> updatedMovies = List.from(state.movies);
      updatedMovies[event.movieIndex] = updatedMovie;

      emit(state.copyWith(movies: updatedMovies));

      // Notify other parts of the app
      sl<StreamController<String>>().add('favorites_updated');

    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState(status: HomeStatus.loading));
    await _onFetchMovies(FetchMovies(), emit, isRefresh: true);
  }

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<HomeState> emit, {
    bool isRefresh = false,
  }) async {
    if (state.hasReachedMax || _isFetching) return;

    _isFetching = true;

    try {
      if (state.status == HomeStatus.initial || isRefresh) {
        emit(
          state.copyWith(
            status: HomeStatus.loading,
            movies: isRefresh ? [] : null,
          ),
        );
      } else {
        emit(state.copyWith(status: HomeStatus.loadingMore));
      }

      final pageToFetch = isRefresh ? 1 : state.currentPage;
      final result = await _getMoviesUsecase.call(pageToFetch);
      final movies = result.movies;
      final pagination = result.pagination;

      emit(
        state.copyWith(
          status: HomeStatus.success,
          movies: isRefresh ? movies : (List.of(state.movies)..addAll(movies)),
          currentPage: pageToFetch + 1,
          hasReachedMax: pagination.currentPage >= pagination.maxPage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    } finally {
      _isFetching = false;
    }
  }
}
