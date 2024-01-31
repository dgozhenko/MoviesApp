import 'package:equatable/equatable.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';

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
  LoadedState(this.movies);
  final List<Movie> movies;

  @override
  List<Object?> get props => [movies];
}

class ErrorState extends MovieListState {
  ErrorState(this.errorMessage);
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class MovieListLoadedStateDeleteSuccess extends LoadedState {
  final Movie deletedMovie;
  MovieListLoadedStateDeleteSuccess(super.movies, {required this.deletedMovie});
  @override
  List<Object?> get props => [movies, deletedMovie];
}
