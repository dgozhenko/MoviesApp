import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/add_movie_cubit.dart';
import 'package:movies_app/domain/state/add_movie_state.dart';

class AddMovieScreen extends StatefulWidget {
  static const routeName = '/add-movie-screen';
  final int? movieId;

  const AddMovieScreen({required this.movieId, super.key});
  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _movieTitleEditingController = TextEditingController();
  var _titleLength = 0;

  @override
  void initState() {
    _movieTitleEditingController.addListener(_updateTitleLength);
    context.read<AddMovieCubit>().loadMovieScreen(movieId: widget.movieId);
    super.initState();
  }

  @override
  void dispose() {
    _movieTitleEditingController.dispose();
    super.dispose();
  }

  void _updateTitleLength() {
    setState(() {
      _titleLength = _movieTitleEditingController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddMovieCubit, AddMovieState>(
        listener: (context, state) {
          if (state is ErrorAddMovieState) {
            final snackBar = SnackBar(
              content: Text(state.errorMessage),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

          if (state is AddMovieNavigateBackAction) {
            Navigator.pop(context);
          }

          if (state is LoadedAddMovieState) {
            if (state.movie != null) {
              _movieTitleEditingController.text = state.movie!.title;
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add a movie'),
          ),
          body: BlocBuilder<AddMovieCubit, AddMovieState>(
            builder: (context, state) {
              if (state is LoadedAddMovieState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: _movieTitleEditingController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text('Movie Title'),
                          counterText: '$_titleLength / 50',
                        ),
                        maxLength: 50,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      BlocBuilder<AddMovieCubit, AddMovieState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: (state is AddMovieInsertLoadingState)
                                    ? null
                                    : () {
                                        if (widget.movieId == null) {
                                          context.read<AddMovieCubit>().addMovie(
                                              title:
                                                  _movieTitleEditingController
                                                      .text);
                                        } else {
                                          final movie =
                                              (state as LoadedAddMovieState)
                                                  .movie;
                                          context
                                              .read<AddMovieCubit>()
                                              .updateMovie(
                                                  movie: movie!,
                                                  updatedTitle:
                                                      _movieTitleEditingController
                                                          .text);
                                        }
                                      },
                                child: Builder(builder: (context) {
                                  if (state is AddMovieInsertLoadingState) {
                                    return const Center(
                                        child: SizedBox(
                                            height: 16,
                                            width: 16,
                                            child:
                                                CircularProgressIndicator()));
                                  }
                                  return const Text('Create');
                                })),
                          );
                        },
                      )
                    ],
                  ),
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
