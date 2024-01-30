import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/add_movie_cubit.dart';
import 'package:movies_app/domain/state/add_movie_state.dart';

class AddMovieScreen extends StatefulWidget {
  static const routeName = '/add-movie-screen';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const AddMovieScreen(),
        settings: const RouteSettings(name: routeName));
  }

  const AddMovieScreen({super.key});
  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _movieTitleEditingController = TextEditingController();

  @override
  void dispose() {
    _movieTitleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddMovieCubit, AddMovieState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add a movie'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: _movieTitleEditingController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            BlocBuilder<AddMovieCubit, AddMovieState>(
              builder: (context, state) {
                return ElevatedButton(onPressed: () {
                  context
                      .read<AddMovieCubit>()
                      .addMovie(title: _movieTitleEditingController.text);
                }, child: Builder(builder: (context) {
                  if (state is AddMovieInsertLoadingState) {
                    return CircularProgressIndicator();
                  } else if (state is ErrorAddMovieState) {
                    return Text(state.errorMessage);
                  }
                  return Text('Create');
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
