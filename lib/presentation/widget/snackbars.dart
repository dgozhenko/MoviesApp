import 'package:flutter/material.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';

SnackBar buildRestoreMovieSuccessSnackbar() {
  return const SnackBar(content: Text('Successfuly restored movie'));
}

SnackBar buildDeletedMovieSnackbar({
  required Movie movie,
  required Function() onUndoPressed,
}) {
  return SnackBar(
      action: SnackBarAction(
        label: 'Undo',
        onPressed: onUndoPressed,
      ),
      content: Text('Deleted movie: ${movie.title}'));
}

SnackBar buildErrorSnackbar({required String errorMessage}) {
  return SnackBar(
    content: Text(errorMessage),
  );
}
