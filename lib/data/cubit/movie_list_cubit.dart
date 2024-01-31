import 'package:bloc/bloc.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';
import 'package:movies_app/domain/state/movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  late MovieRepository repository;
  MovieListCubit({required this.repository}) : super(InitialState()) {
    observeAllMovies();
  }

  void observeAllMovies() async {
    try {
      emit(LoadingState());
      final movies = await repository.getMovies();
      emit(LoadedState(movies));
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  void deleteMovie(Movie movie) async {
    try {
      await repository.deleteMovie(movie.id!);
      final movies = await repository.getMovies();
      emit(MovieListLoadedStateDeleteSuccess(movies, deletedMovie: movie));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void restoreMovie({required Movie movie}) async {
    try {
      await repository.insertMovie(movie);
      final movies = await repository.getMovies();
      emit(MovieListLoadedStateUndoDeleteSuccess(movies, restoredMovie: movie));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
