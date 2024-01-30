import 'package:bloc/bloc.dart';
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
}
