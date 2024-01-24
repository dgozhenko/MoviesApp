import 'package:floor/floor.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM movie')
  Future<List<Movie>> getAllMovies();

  @Query('SELECT * FROM movie')
  Stream<List<Movie>> observeAllMovie();

  @Query('SELECT * FROM movie WHERE id = :id')
  Stream<List<Movie>> findMoviesById(int id);

  @insert
  Future<int> insertMovie(Movie movie);

  @delete
  Future<void> deleteMovie(Movie movie);

  @update
  Future<void> updateMovie(Movie movie);
}
