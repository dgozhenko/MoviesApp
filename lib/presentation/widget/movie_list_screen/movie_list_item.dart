import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/util/converter/timestamp.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final void Function(bool?) onCheckboxValueChanged;
  final void Function() onItemTap;

  const MovieListItem({
    required this.movie,
    required this.onCheckboxValueChanged,
    required this.onItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final date = fromTimestamp(movie.creationTime);
    final formattedDate = DateFormat.yMMMMd().format(date);
    return InkWell(
      onTap: onItemTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            color: movie.isWatched ? Colors.white60 : Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Checkbox(value: movie.isWatched, onChanged: onCheckboxValueChanged),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                      color: movie.isWatched ? Colors.black54 : Colors.black),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                      color: movie.isWatched
                          ? const Color(0x501f1f1f)
                          : const Color(0x501f1f1f)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
