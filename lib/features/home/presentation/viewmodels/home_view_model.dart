import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_event.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final GetMoviesUsecase _getMoviesUsecase;
  bool _isFetching = false;

  HomeViewModel({required GetMoviesUsecase getMoviesUsecase})
    : _getMoviesUsecase = getMoviesUsecase,
      super(const HomeState()) {
    on<FetchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax || _isFetching) return;

    _isFetching = true;

    try {
      if (state.status == HomeStatus.initial) {
        emit(state.copyWith(status: HomeStatus.loading));
      } else {
        emit(state.copyWith(status: HomeStatus.loadingMore));
      }

      final result = await _getMoviesUsecase.call(state.currentPage);
      final movies = result.movies;
      final pagination = result.pagination;

      emit(
        state.copyWith(
          status: HomeStatus.success,
          movies: List.of(state.movies)..addAll(movies),
          currentPage: state.currentPage + 1,
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
