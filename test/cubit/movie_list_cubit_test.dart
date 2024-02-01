import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/data/cubit/movie_list_cubit.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/state/movie_list_state.dart';

import '../unit/movie_dao_test.mocks.dart';

void main() {
  late MovieListCubit mockCubit;
  late MockMovieRepository movieRepository;
  Movie testMovie = Movie(
    id: 0,
    title: 'Test Movie1',
    creationTime: 1,
    isWatched: false,
  );
  List<Movie> testMovies = List.generate(10, (index) => testMovie);

  setUp(
    () async {
      movieRepository = MockMovieRepository();
      mockCubit = MovieListCubit(repository: movieRepository);
    },
  );

  group(
    'Movie screen bloc test',
    () {
      blocTest<MovieListCubit, MovieListState>(
        'Check if get all movies works',
        build: () => mockCubit,
        setUp: () => when(movieRepository.getMovies())
            .thenAnswer((invocation) async => testMovies),
        act: (cubit) => cubit.observeAllMovies(),
        expect: () => [isA<LoadingState>(), isA<LoadedState>()],
      );

      blocTest<MovieListCubit, MovieListState>(
        'Check if delete movie works',
        build: () => mockCubit,
        setUp: () {
          when(movieRepository.deleteMovie(testMovie.id))
              .thenAnswer((realInvocation) async => 0);
          when(movieRepository.getMovies())
              .thenAnswer((realInvocation) async => testMovies);
        },
        act: (cubit) => cubit.deleteMovie(testMovie),
        expect: () => [isA<MovieListLoadedStateDeleteSuccess>()],
      );

      blocTest<MovieListCubit, MovieListState>(
        'Check if restore movie works',
        build: () => mockCubit,
        setUp: () {
          when(movieRepository.insertMovie(testMovie))
              .thenAnswer((realInvocation) async => 0);
          when(movieRepository.getMovies())
              .thenAnswer((realInvocation) async => testMovies);
        },
        act: (cubit) => cubit.restoreMovie(movie: testMovie),
        expect: () => [isA<MovieListLoadedStateUndoDeleteSuccess>()],
      );
    },
  );
}
