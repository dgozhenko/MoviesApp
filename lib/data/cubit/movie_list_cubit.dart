import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/data/repository/sqlite_movie_repository.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';
import 'package:movies_app/domain/state/movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  late MovieRepository _repository;
  MovieListCubit() : super(InitialState()) {
    _repository = GetIt.instance.get<SQLiteMovieRepository>();
    observeAllMovies();
  }

  void observeAllMovies() async {
    try {
      emit(LoadingState());
      final movies = await _repository.getMovies();
      emit(LoadedState(movies));
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }
}
