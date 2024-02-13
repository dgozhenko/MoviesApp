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

  void changeIsWatchedStatus({required Movie updatedMovie}) async {
    try {
      final movies = (state as LoadedState).movies;
      await repository.updateMovie(
          updatedMovie.copyWith(isWatched: !updatedMovie.isWatched));
      final updatedMovies = movies.map((movie) {
        if (movie.id == updatedMovie.id) {
          return movie.copyWith(isWatched: !movie.isWatched);
        } else {
          return movie;
        }
      }).toList();
      emit(MovieListWatchChanged(updatedMovies));
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  void deleteMovie(Movie movie) async {
    try {
      final movies = (state as LoadedState).movies;
      await repository.deleteMovie(movie.id!);
      movies.removeWhere((movieItem) => movieItem.id == movie.id);
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
