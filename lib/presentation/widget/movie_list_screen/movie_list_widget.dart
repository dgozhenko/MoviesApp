import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/presentation/widget/movie_list_screen/movie_list_item.dart';

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
    return Container(
        decoration: const BoxDecoration(color: Color(0xffefefef)),
        child: ImplicitlyAnimatedList<Movie>(
          items: movies,
          areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, animation, movie, index) {
            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: Container(
                key: Key(movie.id.toString()),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.6,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            onWatchedTap(index);
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
                            onDeleteTap(index);
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
                          onWatchedTap(index);
                        },
                        onItemTap: () {
                          onMovieTap(index);
                        })),
              ),
            );
          },
        ));
  }
}
