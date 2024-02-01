import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/data/cubit/add_movie_cubit.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/state/add_movie_state.dart';

import '../unit/movie_dao_test.mocks.dart';

void main() {
  late AddMovieCubit mockCubit;
  late MockMovieRepository movieRepository;
  Movie testMovie = Movie(
    id: 0,
    title: 'Test Movie1',
    creationTime: 1,
    isWatched: false,
  );
  List<Movie> testMovies = List.generate(10, (index) => testMovie);

  setUp(
    () {
      movieRepository = MockMovieRepository();
      mockCubit = AddMovieCubit(repository: movieRepository);
    },
  );

  group(
    'Add movie screen bloc test',
    () {
      blocTest<AddMovieCubit, AddMovieState>(
        'load screen without movie id',
        build: () => mockCubit,
        act: (cubit) => cubit.loadMovieScreen(movieId: null),
        expect: () => [isA<LoadingAddMovieState>(), isA<LoadedAddMovieState>()],
      );

      blocTest<AddMovieCubit, AddMovieState>(
        'load screen with movie id',
        build: () => mockCubit,
        setUp: () {
          when(movieRepository.getMovieById(testMovie.id))
              .thenAnswer((invocation) async => testMovie);
        },
        act: (cubit) => cubit.loadMovieScreen(movieId: testMovie.id),
        expect: () => [
          isA<LoadingAddMovieState>(),
          isA<LoadedAddMovieState>(),
        ],
      );

      blocTest<AddMovieCubit, AddMovieState>(
        'save movie',
        build: () => mockCubit,
        setUp: () => when(
          movieRepository.insertMovie(any),
        ).thenAnswer(
          (realInvocation) async => 0,
        ),
        act: (cubit) => cubit.addMovie(title: 'Test Movie1'),
        expect: () => [
          isA<AddMovieInsertLoadingState>(),
          isA<AddMovieNavigateBackAction>(),
        ],
      );

      blocTest(
        'update movie',
        build: () => mockCubit,
        setUp: () => when(movieRepository.updateMovie(any))
          ..thenAnswer((realInvocation) async => 0),
        act: (cubit) =>
            cubit.updateMovie(movie: testMovie, updatedTitle: 'Updated'),
        expect: () => [
          isA<AddMovieInsertLoadingState>(),
          isA<AddMovieNavigateBackAction>()
        ],
      );
    },
  );
}
