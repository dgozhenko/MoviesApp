import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/util/converter/timestamp.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  final Function(int) onWatchedTap;
  final Function(int) onDeleteTap;
  final Function(int) onMovieTap;

  const MovieListWidget({
    required this.movies,
    required this.onDeleteTap,
    required this.onWatchedTap,
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

        return Slidable(
          key: Key(movies[index].id.toString()),
          endActionPane: ActionPane(
            extentRatio: 0.6,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  onWatchedTap(index);
                },
                flex: 1,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.visibility,
                label: movie.isWatched ? 'Unwatch' : 'Watch',
              ),
              SlidableAction(
                onPressed: (context) {
                  onDeleteTap(index);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              movie.title,
              style: TextStyle(
                decoration: movie.isWatched
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(formattedDate),
            onTap: () => onMovieTap(index),
          ),
        );
      },
    );
  }
}
