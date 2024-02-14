import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/presentation/widget/movie_list_screen/movie_list_slidable_item.dart';

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
              child: MovieListSlidableItem(
                movie: movie,
                onWatchedTap: () => onWatchedTap(index),
                onDeleteTap: () => onDeleteTap(index),
                onMovieTap: () => onMovieTap(index),
              ),
            );
          },
        ));
  }
}
