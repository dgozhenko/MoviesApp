import 'package:movies_app/domain/entity/movie_entity.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();

  Stream<List<Movie>> observeMovies();

  Stream<List<Movie>> findMoviesById(int id);

  Future<int> insertMovie(Movie movie);

  Future<void> deleteMovie(Movie movie);

  Future<void> updateMovie(Movie movie);
}
