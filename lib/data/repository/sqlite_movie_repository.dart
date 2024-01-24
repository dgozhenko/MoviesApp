import 'package:get_it/get_it.dart';
import 'package:movies_app/domain/dao/movie_dao.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';

class SQLiteMovieRepository extends MovieRepository {
  late MovieDao _movieDao;

  SQLiteMovieRepository() {
    _movieDao = GetIt.instance.get<MovieDao>();
  }

  @override
  Future<void> deleteMovie(Movie movie) {
    return _movieDao.deleteMovie(movie);
  }

  @override
  Stream<List<Movie>> findMoviesById(int id) {
    return _movieDao.findMoviesById(id);
  }

  @override
  Future<List<Movie>> getMovies() {
    return _movieDao.getAllMovies();
  }

  @override
  Future<int> insertMovie(Movie movie) {
    return _movieDao.insertMovie(movie);
  }

  @override
  Stream<List<Movie>> observeMovies() {
    return _movieDao.observeAllMovie();
  }

  @override
  Future<void> updateMovie(Movie movie) {
    return _movieDao.updateMovie(movie);
  }
}
