import 'package:get_it/get_it.dart';
import 'package:movies_app/data/repository/sqlite_movie_repository.dart';
import 'package:movies_app/domain/datasource/movie_list_data_source.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';

class SQLiteMovieListDataSource extends MovieListDataSource {
  late MovieRepository _movieRepository;

  SQLiteMovieListDataSource() {
    _movieRepository = GetIt.instance.get<SQLiteMovieRepository>();
  }
  @override
  Future<void> deleteMovie(Movie movie) {
    return _movieRepository.deleteMovie(movie);
  }

  @override
  Future<List<Movie>> getAllMovies() {
    return _movieRepository.getMovies();
  }

  @override
  Stream<List<Movie>> observeAllMovies() {
    return _movieRepository.observeMovies();
  }
}
