import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/util/converter/timestamp.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  final Function({
    required DismissDirection direction,
    required int index,
  }) onMovieDismissed;
  final Function(int) onMovieTap;

  const MovieListWidget({
    required this.movies,
    required this.onMovieDismissed,
    required this.onMovieTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final date = fromTimestamp(movie.creationTime);
        final formattedDate = DateFormat.yMMMMd().format(date);

        return Dismissible(
          key: Key(movies[index].id.toString()),
          onDismissed: (direction) {
            onMovieDismissed(direction: direction, index: index);
          },
          background: Container(
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            title: Text(movie.title),
            subtitle: Text(formattedDate),
            onTap: () => onMovieTap(index),
          ),
        );
      },
    );
  }
}
