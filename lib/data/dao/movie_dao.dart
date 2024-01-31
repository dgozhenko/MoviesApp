import 'package:movies_app/data/database.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';

class MovieDao {
  final databaseProvider = DatabaseProvider.databaseProvider;

  Future<int> createMovie(Movie movie) async {
    final database = await databaseProvider.database;
    var results = database.insert(movieTable, movie.toDatabaseJson());
    return results;
  }

  Future<int> updateMovie(Movie movie) async {
    final database = await databaseProvider.database;
    var results = database.update(movieTable, movie.toDatabaseJson(),
        where: 'id = ?', whereArgs: [movie.id]);
    return results;
  }

  Future<int> deleteMovie(int movieId) async {
    final database = await databaseProvider.database;
    var results =
        database.delete(movieTable, where: 'id LIKE ?', whereArgs: [movieId]);
    return results;
  }

  Future<Movie?> getMovieById(
      {List<String>? columns, required int movieId}) async {
    final database = await databaseProvider.database;
    final databaseMovie = await database.query(movieTable,
        columns: columns, where: 'id LIKE ?', whereArgs: [movieId]);
    return databaseMovie.isNotEmpty
        ? databaseMovie
            .map((movie) => Movie.fromDatabaseJson(databaseMovie.first))
            .first
        : null;
  }

  Future<List<Movie>> getMovies({List<String>? columns, String? query}) async {
    final database = await databaseProvider.database;
    List<Map<String, dynamic>> result = [];
    if (query != null) {
      if (query.isNotEmpty) {
        result = await database.query(movieTable,
            columns: columns, where: 'title LIKE ?', whereArgs: ["%query%"]);
      }
    } else {
      result = await database.query(movieTable, columns: columns);
    }

    List<Movie> movies = result.isNotEmpty
        ? result.map((movie) => Movie.fromDatabaseJson(movie)).toList()
        : [];
    return movies;
  }
}
