import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/movie_list_cubit.dart';
import 'package:movies_app/domain/state/movie_list_state.dart';
import 'package:movies_app/presentation/add_movie_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddMovieScreen.routeName).then(
            (value) => context.read<MovieListCubit>().observeAllMovies(),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: BlocBuilder<MovieListCubit, MovieListState>(
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
            final movies = state.movies;
            if (movies.isEmpty) {
              return Center(child: Text('There no data...'));
            } else {
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(movies[index].title),
                    subtitle: Text(movies[index].creationTime.toString()),
                  );
                },
              );
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
