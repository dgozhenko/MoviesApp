import 'package:movies_app/data/dao/movie_dao.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';

class SQLiteMovieRepository extends MovieRepository {
  final movieDao = MovieDao();

  @override
  Future<List<Movie>> getMovies() {
    return movieDao.getMovies();
  }

  @override
  Future<int> insertMovie(Movie movie) {
    return movieDao.createMovie(movie);
  }

  @override
  Future<int> deleteMovie(int movieId) {
    return movieDao.deleteMovie(movieId);
  }
}
