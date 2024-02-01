import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/data/database.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'movie_dao_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late Database database;
  late MockMovieRepository movieRepository;
  Movie testMovie = Movie(
    id: 0,
    title: 'Test Movie1',
    creationTime: 1,
    isWatched: false,
  );
  List<Movie> testMovies = List.generate(10, (index) => testMovie);
  setUpAll(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute("CREATE TABLE $movieTable ("
        "id INTEGER PRIMARY KEY, "
        "title TEXT, "
        "is_watched INTEGER, "
        "image_url TEXT, "
        "creation_time INTEGET "
        ")");
    movieRepository = MockMovieRepository();
    when(movieRepository.insertMovie(any)).thenAnswer(
      (realInvocation) async => 0,
    );
    when(movieRepository.deleteMovie(any)).thenAnswer(
      (realInvocation) async => 0,
    );
    when(movieRepository.updateMovie(any)).thenAnswer(
      (realInvocation) async => 0,
    );
    when(movieRepository.getMovieById(any)).thenAnswer(
      (realInvocation) async => testMovie,
    );
    when(movieRepository.getMovies()).thenAnswer(
      (realInvocation) async => testMovies,
    );
  });

  group('Database test', () {
    test(
      'database version',
      () async {
        expect(await database.getVersion(), 0);
      },
    );
    test(
      'Add movie to database',
      () async {
        await database.insert(movieTable, testMovie.toDatabaseJson());
        var itemsInDatabase = await database.query(movieTable);
        expect(itemsInDatabase.length, 1);
      },
    );

    test(
      'Find movie by id',
      () async {
        var movieRaw = await database
            .query(movieTable, where: 'id = ?', whereArgs: [testMovie.id]);
        final movie = Movie.fromDatabaseJson(movieRaw.first);
        expect(movie.id, testMovie.id);
      },
    );

    test(
      'Update first movie',
      () async {
        await database.update(
            movieTable, testMovie.copyWith(title: 'Updated').toDatabaseJson(),
            where: 'id = ?', whereArgs: [testMovie.id]);
        var movies = await database.query(movieTable);
        expect(movies.first['title'], 'Updated');
      },
    );

    test(
      'Delete movie',
      () async {
        await database.delete(
          movieTable,
          where: 'id = ?',
          whereArgs: [testMovie.id],
        );
        var movies = await database.query(movieTable);
        expect(movies.length, 0);
      },
    );

    test(
      'Close database',
      () async {
        await database.close();
        expect(database.isOpen, false);
      },
    );
  });

  group(
    'Movie Repository test',
    () {
      test('Create a movie', () async {
        verifyNever(movieRepository.insertMovie(testMovie));
        expect(await movieRepository.insertMovie(testMovie), 0);
        verify(movieRepository.insertMovie(testMovie)).called(1);
      });

      test(
        'Update a movie',
        () async {
          verifyNever(movieRepository.updateMovie(testMovie));
          expect(await movieRepository.updateMovie(testMovie), 0);
          verify(movieRepository.updateMovie(testMovie)).called(1);
        },
      );

      test(
        'Delete a movie',
        () async {
          verifyNever(movieRepository.deleteMovie(testMovie.id));
          expect(await movieRepository.deleteMovie(testMovie.id), 0);
          verify(movieRepository.deleteMovie(testMovie.id)).called(1);
        },
      );

      test(
        'Get movie by Id',
        () async {
          verifyNever(movieRepository.getMovieById(testMovie.id));
          expect(await movieRepository.getMovieById(testMovie.id), testMovie);
          verify(movieRepository.getMovieById(testMovie.id)).called(1);
        },
      );

      test(
        'Get all movies',
        () async {
          verifyNever(movieRepository.getMovies());
          expect(await movieRepository.getMovies(), testMovies);
          verify(movieRepository.getMovies());
        },
      );
    },
  );
}
