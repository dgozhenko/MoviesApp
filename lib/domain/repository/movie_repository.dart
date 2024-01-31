import 'package:movies_app/domain/entity/movie_entity.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();

  Future<int> insertMovie(Movie movie);

  Future<int> deleteMovie(int movieId);

  Future<Movie?> getMovieById(int movieId);

  Future<int> updateMovie(Movie movie);
}
