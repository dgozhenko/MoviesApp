import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/add_movie_cubit.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/enums/add_movie_screen_mode.dart';
import 'package:movies_app/domain/state/add_movie_state.dart';
import 'package:movies_app/presentation/widget/add_movie_screen/loaded_state_widget.dart';
import 'package:movies_app/presentation/widget/snackbars.dart';

class AddMovieScreen extends StatefulWidget {
  static const routeName = '/add-movie-screen';
  final int? movieId;

  const AddMovieScreen({required this.movieId, super.key});
  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  @override
  void initState() {
    _loadScreenData();
    super.initState();
  }

  void _loadScreenData() {
    context.read<AddMovieCubit>().loadMovieScreen(movieId: widget.movieId);
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddMovieCubit, AddMovieState>(
        listener: (context, state) {
          if (state is ErrorAddMovieState) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildErrorSnackbar(
                errorMessage: state.errorMessage,
              ),
            );
          }

          if (state is AddMovieNavigateBackAction) _navigateBack();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add a Movie'),
          ),
          body: BlocBuilder<AddMovieCubit, AddMovieState>(
            builder: (context, state) {
              if (state is LoadedAddMovieState) {
                return LoadedAddMovieWidget(
                  movie: state.movie,
                );
              } else if (state is LoadingAddMovieState) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            },
          ),
        ));
  }
}
