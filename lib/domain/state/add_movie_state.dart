import 'package:equatable/equatable.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';

abstract class AddMovieState extends Equatable {}

abstract class AddMovieStateAction extends AddMovieState {}

class AddMovieNavigateBackAction extends AddMovieStateAction {
  @override
  List<Object?> get props => [];
}

class InitialAddMovieState extends AddMovieState {
  @override
  List<Object?> get props => [];
}

class LoadingAddMovieState extends AddMovieState {
  @override
  List<Object?> get props => [];
}

class LoadedAddMovieState extends AddMovieState {
  final Movie? movie;
  LoadedAddMovieState({this.movie});

  @override
  List<Object?> get props => [movie];
}

class ErrorAddMovieState extends AddMovieState {
  final String errorMessage;
  ErrorAddMovieState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AddMovieInsertLoadingState extends AddMovieState {
  @override
  List<Object?> get props => [];
}
