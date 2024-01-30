import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';
import 'package:movies_app/domain/state/add_movie_state.dart';

class AddMovieCubit extends Cubit<AddMovieState> {
  late MovieRepository repository;
  AddMovieCubit({required this.repository}) : super((InitialAddMovieState())) {}

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
