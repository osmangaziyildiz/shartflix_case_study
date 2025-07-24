import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchMovies extends HomeEvent {}

class RefreshMovies extends HomeEvent {}

class ToggleFavorite extends HomeEvent {
  final String movieId;
  final int movieIndex;

  const ToggleFavorite({required this.movieId, required this.movieIndex});

  @override
  List<Object> get props => [movieId, movieIndex];
} 