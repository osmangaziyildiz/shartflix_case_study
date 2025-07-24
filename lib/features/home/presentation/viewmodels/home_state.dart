import 'package:equatable/equatable.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

enum HomeStatus { initial, loading, success, error, loadingMore }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<MovieEntity> movies;
  final int currentPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.movies = const <MovieEntity>[],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<MovieEntity>? movies,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movies, currentPage, hasReachedMax, errorMessage];
} 