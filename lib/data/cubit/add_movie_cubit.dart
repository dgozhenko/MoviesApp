import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';
import 'package:movies_app/domain/state/add_movie_state.dart';

class AddMovieCubit extends Cubit<AddMovieState> {
  late MovieRepository repository;
  AddMovieCubit({required this.repository}) : super((InitialAddMovieState()));

  void loadMovieScreen({required int? movieId}) async {
    emit(LoadingAddMovieState());
    if (movieId != null) {
      await findMovieById(movieId: movieId);
    } else {
      emit(LoadedAddMovieState());
    }
  }

  Future<void> findMovieById({required int movieId}) async {
    try {
      final movie = await repository.getMovieById(movieId);
      if (movie != null) {
        emit(LoadedAddMovieState(movie: movie));
      } else {
        emit(ErrorAddMovieState(
            errorMessage: 'There no movie with id: $movieId'));
      }
    } catch (e) {
      emit(ErrorAddMovieState(errorMessage: e.toString()));
    }
  }

  void updateMovie({required Movie movie, required String updatedTitle}) async {
    final updatedMovie = movie.copyWith(title: updatedTitle);
    try {
      emit(AddMovieInsertLoadingState());
      await repository.updateMovie(updatedMovie);
      emit(AddMovieNavigateBackAction());
    } catch (e) {
      emit(ErrorAddMovieState(errorMessage: e.toString()));
    }
  }

  void addMovie({required String title}) async {
    final movie = Movie(
        title: title,
        creationTime: DateTime.now().millisecondsSinceEpoch,
        isWatched: false);
    try {
      emit(AddMovieInsertLoadingState());
      await repository.insertMovie(movie);
      emit(AddMovieNavigateBackAction());
    } catch (e) {
      emit(ErrorAddMovieState(errorMessage: e.toString()));
    }
  }
}
