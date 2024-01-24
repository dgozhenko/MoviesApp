import 'package:movies_app/domain/entity/movie_entity.dart';

abstract class MovieListDataSource {
  Future<List<Movie>> getAllMovies();
  Stream<List<Movie>> observeAllMovies();
  Future<void> deleteMovie(Movie movie);
}
