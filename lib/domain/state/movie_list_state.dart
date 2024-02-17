import 'package:equatable/equatable.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/model/sorting_filtering_model.dart';

abstract class MovieListState extends Equatable {}

abstract class MovieListActionState extends MovieListState {}

class MovieListNavigateToAddMovieScreenAction extends MovieListActionState {
  final String? movieId;
  MovieListNavigateToAddMovieScreenAction({this.movieId});

  @override
  List<Object?> get props => [movieId];
}

class InitialState extends MovieListState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends MovieListState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends MovieListState {
  LoadedState(
      {required this.movies,
      required this.filteredMovies,
      required this.sortingAndFiltering});
  final List<Movie> movies;
  final List<Movie> filteredMovies;
  final SortingAndFilteringModel sortingAndFiltering;

  @override
  List<Object?> get props => [movies, sortingAndFiltering];
}

class ErrorState extends MovieListState {
  ErrorState(this.errorMessage);
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class MovieListWatchChanged extends LoadedState {
  MovieListWatchChanged(
      {required super.sortingAndFiltering,
      required super.movies,
      required super.filteredMovies});
  @override
  List<Object?> get props => [movies, filteredMovies, sortingAndFiltering];
}

class MovieListLoadedStateDeleteSuccess extends LoadedState {
  final Movie deletedMovie;
  MovieListLoadedStateDeleteSuccess(
      {required this.deletedMovie,
      required super.sortingAndFiltering,
      required super.movies,
      required super.filteredMovies});
  @override
  List<Object?> get props => [movies, deletedMovie];
}

class MovieListLoadedStateUndoDeleteSuccess extends LoadedState {
  final Movie restoredMovie;
  MovieListLoadedStateUndoDeleteSuccess(
      {required this.restoredMovie,
      required super.sortingAndFiltering,
      required super.movies,
      required super.filteredMovies});
  @override
  List<Object?> get props => [movies, restoredMovie];
}
