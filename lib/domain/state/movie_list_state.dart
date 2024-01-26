import 'package:equatable/equatable.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';

abstract class MovieListState extends Equatable {}

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
