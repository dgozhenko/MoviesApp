import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/movie_list_cubit.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/enums/filtering_option.dart';
import 'package:movies_app/domain/state/movie_list_state.dart';
import 'package:movies_app/presentation/screen/add_movie_screen.dart';
import 'package:movies_app/presentation/widget/movie_list_screen/bottom_dialog/sorting_filtering_bottom_dialog.dart';
import 'package:movies_app/presentation/widget/movie_list_screen/empty_state_screen.dart';
import 'package:movies_app/presentation/widget/movie_list_screen/movie_list_widget.dart';
import 'package:movies_app/presentation/widget/snackbars.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  static const routeName = '/movie-list-screen';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const MovieListScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  void _navigateToAddMovieScreen({required int? movieIdArgument}) {
    Navigator.pushNamed(context, AddMovieScreen.routeName,
            arguments: movieIdArgument)
        .then(
      (value) => context.read<MovieListCubit>().observeAllMovies(),
    );
  }

  void _deleteMovie({required Movie movie}) {
    context.read<MovieListCubit>().deleteMovie(movie);
  }

  void _restoreMovie({required Movie movie}) {
    context.read<MovieListCubit>().restoreMovie(movie: movie);
  }

  void _changeIsWatchedStatus({required Movie movie}) {
    context.read<MovieListCubit>().changeIsWatchedStatus(movie: movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddMovieScreen(movieIdArgument: null);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('My Watchlist'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (contex) {
                      return const SortingAndFilteringBottomDialog();
                    });
              },
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: BlocListener<MovieListCubit, MovieListState>(
        listener: (context, state) {
          if (state is MovieListLoadedStateUndoDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildRestoreMovieSuccessSnackbar(),
            );
          }

          if (state is MovieListLoadedStateDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildDeletedMovieSnackbar(
                movie: state.deletedMovie,
                onUndoPressed: () {
                  _restoreMovie(movie: state.deletedMovie);
                },
              ),
            );
          }
        },
        child: BlocBuilder<MovieListCubit, MovieListState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ErrorState) {
              return Center(
                child: Text(state.errorMessage),
              );
            }

            if (state is LoadedState) {
              final movies = state.filteredMovies;
              final sortingAndFiltering = state.sortingAndFiltering;
              if (movies.isEmpty) {
                return EmptyScreenWidget(addMoviePressed: () {
                  _navigateToAddMovieScreen(movieIdArgument: null);
                });
              } else {
                return MovieListWidget(
                    movies: movies,
                    sortingAndFilteringModel: sortingAndFiltering,
                    onDeleteTap: (index) {
                      _deleteMovie(movie: movies[index]);
                    },
                    onWatchedTap: (index) {
                      _changeIsWatchedStatus(movie: movies[index]);
                    },
                    onMovieTap: (index) {
                      _navigateToAddMovieScreen(
                        movieIdArgument: movies[index].id!,
                      );
                    });
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
