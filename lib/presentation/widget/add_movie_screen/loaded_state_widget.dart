import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/add_movie_cubit.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/enums/add_movie_screen_mode.dart';
import 'package:movies_app/domain/state/add_movie_state.dart';

class LoadedAddMovieWidget extends StatefulWidget {
  final Movie? movie;

  const LoadedAddMovieWidget({required this.movie, super.key});

  @override
  State<LoadedAddMovieWidget> createState() => _LoadedAddMovieWidgetState();
}

class _LoadedAddMovieWidgetState extends State<LoadedAddMovieWidget> {
  final _movieTitleEditingController = TextEditingController();
  var _titleLength = 0;
  late AddMovieSaveButtonMode _addMovieSaveButtonMode;

  @override
  void initState() {
    _checkForSaveButtonInitialState();
    _preloadDataToUi();
    _addListenersForMovieTextEdittingController();
    super.initState();
  }

  void _preloadDataToUi() {
    if (widget.movie != null) {
      _movieTitleEditingController.text = widget.movie!.title;
    }
  }

  void _addListenersForMovieTextEdittingController() {
    _movieTitleEditingController.addListener(_updateTitleLength);
    if (widget.movie == null) {
      _movieTitleEditingController.addListener(_checkForAbilityToSave);
    } else {
      _movieTitleEditingController.addListener(_checkForEditingChanges);
    }
  }

  void _checkForAbilityToSave() {
    if (_movieTitleEditingController.text.replaceAll(' ', '').isNotEmpty) {
      setState(() {
        _addMovieSaveButtonMode = AddMovieSaveButtonMode.save;
      });
    } else {
      setState(() {
        _addMovieSaveButtonMode = AddMovieSaveButtonMode.saveDisabled;
      });
    }
  }

  void _updateTitleLength() {
    setState(() {
      _titleLength = _movieTitleEditingController.text.length;
    });
  }

  void _checkForEditingChanges() {
    if (widget.movie!.title == _movieTitleEditingController.text) {
      setState(() {
        _addMovieSaveButtonMode = AddMovieSaveButtonMode.editDisabled;
      });
    } else {
      setState(() {
        _addMovieSaveButtonMode = AddMovieSaveButtonMode.edit;
      });
    }
  }

  void _checkForSaveButtonInitialState() {
    if (widget.movie != null) {
      _addMovieSaveButtonMode = AddMovieSaveButtonMode.editDisabled;
    } else {
      _addMovieSaveButtonMode = AddMovieSaveButtonMode.saveDisabled;
    }
  }

  void _saveMovie() {
    context
        .read<AddMovieCubit>()
        .addMovie(title: _movieTitleEditingController.text.trim());
  }

  void _editAndSaveMovie(Movie movie) {
    context.read<AddMovieCubit>().updateMovie(
        movie: movie, updatedTitle: _movieTitleEditingController.text.trim());
  }

  @override
  void dispose() {
    _movieTitleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          TextField(
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              switch (_addMovieSaveButtonMode) {
                case AddMovieSaveButtonMode.save:
                  _saveMovie();
                  break;
                case AddMovieSaveButtonMode.edit:
                  final movie = widget.movie;
                  _editAndSaveMovie(movie!);
                  break;
                case AddMovieSaveButtonMode.saveDisabled:
                case AddMovieSaveButtonMode.editDisabled:
                  null;
                  break;
              }
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
                    onPressed: (state is AddMovieInsertLoadingState) ||
                            _addMovieSaveButtonMode ==
                                AddMovieSaveButtonMode.editDisabled ||
                            _addMovieSaveButtonMode ==
                                AddMovieSaveButtonMode.saveDisabled
                        ? null
                        : () {
                            switch (_addMovieSaveButtonMode) {
                              case AddMovieSaveButtonMode.save:
                                _saveMovie();
                                break;
                              case AddMovieSaveButtonMode.edit:
                                final movie =
                                    (state as LoadedAddMovieState).movie;
                                _editAndSaveMovie(movie!);
                                break;
                              case AddMovieSaveButtonMode.saveDisabled:
                              case AddMovieSaveButtonMode.editDisabled:
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
                                child: CircularProgressIndicator()));
                      }
                      return Text(
                          _addMovieSaveButtonMode == AddMovieSaveButtonMode.save
                              ? 'Save'
                              : _addMovieSaveButtonMode ==
                                      AddMovieSaveButtonMode.edit
                                  ? "Edit and Save"
                                  : "No changes detected");
                    })),
              );
            },
          )
        ],
      ),
    );
  }
}
