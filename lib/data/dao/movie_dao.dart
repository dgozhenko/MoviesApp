import 'package:movies_app/data/database.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';

class MovieDao {
  final databaseProvider = DatabaseProvider.databaseProvider;

  Future<int> createMovie(Movie movie) async {
    final database = await databaseProvider.database;
    await Future.delayed(Duration(seconds: 2));
    var results = database.insert(movieTable, movie.toDatabaseJson());
    return results;
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
