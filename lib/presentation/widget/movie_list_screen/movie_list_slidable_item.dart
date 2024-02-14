import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/presentation/widget/movie_list_screen/movie_list_item.dart';

class MovieListSlidableItem extends StatelessWidget {
  final Movie movie;
  final Function() onWatchedTap;
  final Function() onDeleteTap;
  final Function() onMovieTap;

  const MovieListSlidableItem({
    required this.movie,
    required this.onWatchedTap,
    required this.onDeleteTap,
    required this.onMovieTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(movie.id.toString()),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.6,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  onWatchedTap();
                },
                flex: 1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.visibility,
                label: movie.isWatched ? 'Unwatch' : 'Watch',
              ),
              SlidableAction(
                onPressed: (context) {
                  onDeleteTap();
                },
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: MovieListItem(
              movie: movie,
              onCheckboxValueChanged: (_) {
                onWatchedTap();
              },
              onItemTap: () {
                onMovieTap();
              })),
    );
  }
}
