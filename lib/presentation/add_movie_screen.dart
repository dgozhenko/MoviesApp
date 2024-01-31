import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/add_movie_cubit.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/enums/add_movie_screen_mode.dart';
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
  Movie? _movieForEdit;
  AddMovieScreenMode _addMovieScreenMode = AddMovieScreenMode.create;

  @override
  void initState() {
    _movieTitleEditingController.addListener(_updateTitleLength);
    _movieTitleEditingController.addListener(_checkForEditingChanges);
    context.read<AddMovieCubit>().loadMovieScreen(movieId: widget.movieId);
    if (widget.movieId != null) {
      _addMovieScreenMode = AddMovieScreenMode.editDisabled;
    }
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

  void _saveLocalMovie(Movie movie) {
    setState(() {
      _movieForEdit = movie;
    });
  }

  void _checkForEditingChanges() {
    if (_movieForEdit != null) {
      print('Listener triggered');
      setState(() {
        if (_movieForEdit!.title == _movieTitleEditingController.text) {
          _addMovieScreenMode = AddMovieScreenMode.editDisabled;
        } else {
          _addMovieScreenMode = AddMovieScreenMode.edit;
        }
      });
    }
  }

  void _saveMovie() {
    context
        .read<AddMovieCubit>()
        .addMovie(title: _movieTitleEditingController.text);
  }

  void _editAndSaveMovie(Movie movie) {
    context.read<AddMovieCubit>().updateMovie(
        movie: movie, updatedTitle: _movieTitleEditingController.text);
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
              _saveLocalMovie(state.movie!);
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
                                onPressed: (state
                                            is AddMovieInsertLoadingState) ||
                                        _addMovieScreenMode ==
                                            AddMovieScreenMode.editDisabled
                                    ? null
                                    : () {
                                        switch (_addMovieScreenMode) {
                                          case AddMovieScreenMode.create:
                                            _saveMovie();
                                            break;
                                          case AddMovieScreenMode.edit:
                                            final movie =
                                                (state as LoadedAddMovieState)
                                                    .movie;
                                            _editAndSaveMovie(movie!);
                                            break;
                                          case AddMovieScreenMode.editDisabled:
                                            null;
                                            break;
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
                                  return Text(_addMovieScreenMode ==
                                          AddMovieScreenMode.create
                                      ? 'Save'
                                      : _addMovieScreenMode ==
                                              AddMovieScreenMode.edit
                                          ? "Edit and Save"
                                          : "No changes detected");
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
