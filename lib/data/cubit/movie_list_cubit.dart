import 'package:bloc/bloc.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/enums/filtering_option.dart';
import 'package:movies_app/domain/enums/sorting_option.dart';
import 'package:movies_app/domain/enums/sorting_order.dart';
import 'package:movies_app/domain/model/sorting_filtering_model.dart';
import 'package:movies_app/domain/model/sorting_model.dart';
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
      emit(
        LoadedState(
          movies: movies,
          filteredMovies: movies,
          sortingAndFiltering: SortingAndFilteringModel(
            filteringOptions: [],
            sortingOptions: SortingModel(
              sortingOption: SortingOption.byName,
              sortingOrder: SortingOrder.ascending,
            ),
          ),
        ),
      );
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  void changeIsWatchedStatus({required Movie movie}) async {
    try {
      final loadedState = state as LoadedState;

      final movies = loadedState.movies;
      final filteredMovies = loadedState.filteredMovies;
      final sortingAndFilteringOptions = loadedState.sortingAndFiltering;

      final updatedMovie = movie.copyWith(isWatched: !movie.isWatched);
      await repository.updateMovie(updatedMovie);

      final updatedMovies =
          movies.where((element) => element.id != updatedMovie.id).toList();

      if (movie.isWatched) {
        updatedMovies.insert(0, updatedMovie);
      } else {
        updatedMovies.add(updatedMovie);
      }

      final updatedFilteredMovies = reorderListDependingOnWatchStatus(
        movies: filteredMovies,
        updatedMovie: updatedMovie,
        sortingAndFiltering: sortingAndFilteringOptions,
        isWatched: movie.isWatched,
      );

      emit(MovieListWatchChanged(
          movies: updatedMovies,
          filteredMovies: updatedFilteredMovies,
          sortingAndFiltering: sortingAndFilteringOptions));
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  List<Movie> reorderListDependingOnWatchStatus({
    required List<Movie> movies,
    required Movie updatedMovie,
    required SortingAndFilteringModel sortingAndFiltering,
    required bool isWatched,
  }) {
    if (isWatched) {
      final updatedFilteredMovies =
          movies.where((element) => element.id != updatedMovie.id).toList();
      if (sortingAndFiltering.filteringOptions.contains(
        FilteringOption.watched,
      )) {
      } else {
        updatedFilteredMovies.insert(0, updatedMovie);
      }
      return updatedFilteredMovies;
    } else {
      final updatedFilteredMovies =
          movies.where((element) => element.id != updatedMovie.id).toList();

      if (sortingAndFiltering.filteringOptions.contains(
        FilteringOption.notWatched,
      )) {
      } else {
        updatedFilteredMovies.add(updatedMovie);
      }
      return updatedFilteredMovies;
    }
  }

  void deleteMovie(Movie movie) async {
    try {
      final loadedState = state as LoadedState;

      final movies = loadedState.movies;
      final filteredMovies = loadedState.filteredMovies;
      final sortingAndFilteringOptions = loadedState.sortingAndFiltering;

      await repository.deleteMovie(movie.id!);

      movies.removeWhere((movieItem) => movieItem.id == movie.id);
      filteredMovies.removeWhere((movieItem) => movieItem.id == movie.id);

      emit(MovieListLoadedStateDeleteSuccess(
          movies: movies,
          filteredMovies: filteredMovies,
          deletedMovie: movie,
          sortingAndFiltering: sortingAndFilteringOptions));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void restoreMovie({required Movie movie}) async {
    try {
      final loadedState = state as LoadedState;

      final movies = loadedState.movies;
      final filteredMovies = loadedState.filteredMovies;
      final sortingAndFilteringOptions = loadedState.sortingAndFiltering;

      await repository.insertMovie(movie);

      movies.add(movie);
      filteredMovies.add(movie);

      emit(MovieListLoadedStateUndoDeleteSuccess(
          movies: movies,
          filteredMovies: filteredMovies,
          restoredMovie: movie,
          sortingAndFiltering: sortingAndFilteringOptions));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void addFilteringOption({required FilteringOption option}) {
    final loadedState = state as LoadedState;

    final movies = loadedState.movies;
    final sortingAndFilteringOptions = loadedState.sortingAndFiltering;

    sortingAndFilteringOptions.filteringOptions.add(option);

    final filteredMovies = filterMovies(
      filteringOptions: sortingAndFilteringOptions.filteringOptions,
      movies: movies,
    );

    emit(
      LoadedState(
        movies: movies,
        filteredMovies: filteredMovies,
        sortingAndFiltering: sortingAndFilteringOptions.copyWith(
          filtering: sortingAndFilteringOptions.filteringOptions,
        ),
      ),
    );
  }

  void removeFilteringOption({required FilteringOption option}) {
    final loadedState = state as LoadedState;

    final movies = loadedState.movies;
    final sortingAndFilteringOptions = loadedState.sortingAndFiltering;

    sortingAndFilteringOptions.filteringOptions.remove(option);

    final filteredMovies = filterMovies(
      filteringOptions: sortingAndFilteringOptions.filteringOptions,
      movies: movies,
    );

    emit(
      LoadedState(
        movies: movies,
        filteredMovies: filteredMovies,
        sortingAndFiltering: sortingAndFilteringOptions.copyWith(
          filtering: sortingAndFilteringOptions.filteringOptions,
        ),
      ),
    );
  }

  List<Movie> filterMovies({
    required List<FilteringOption> filteringOptions,
    required List<Movie> movies,
  }) {
    for (var filter in filteringOptions) {
      if (filter == FilteringOption.watched) {
        return movies.where((element) => element.isWatched).toList();
      } else {
        return movies.where((element) => !element.isWatched).toList();
      }
    }
    return movies;
  }

  void changeSortingOption({required SortingOption option}) {
    final movies = (state as LoadedState).movies;
    final filteredMovies = (state as LoadedState).filteredMovies;
    final sortingAndFilteringOptions =
        (state as LoadedState).sortingAndFiltering;
    emit(
      LoadedState(
        movies: movies,
        filteredMovies: filteredMovies,
        sortingAndFiltering: sortingAndFilteringOptions.copyWith(
          sorting: sortingAndFilteringOptions.sortingOptions.copyWith(
            option: option,
          ),
        ),
      ),
    );
  }

  void changeSortingOrder({required SortingOrder order}) {
    final movies = (state as LoadedState).movies;
    final filteredMovies = (state as LoadedState).filteredMovies;
    final sortingAndFilteringOptions =
        (state as LoadedState).sortingAndFiltering;
    emit(
      LoadedState(
        movies: movies,
        filteredMovies: filteredMovies,
        sortingAndFiltering: sortingAndFilteringOptions.copyWith(
          sorting: sortingAndFilteringOptions.sortingOptions.copyWith(
            order: order,
          ),
        ),
      ),
    );
  }
}
