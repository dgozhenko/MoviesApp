import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/config/app_router.dart';
import 'package:movies_app/data/cubit/add_movie_cubit.dart';
import 'package:movies_app/data/cubit/movie_list_cubit.dart';
import 'package:movies_app/data/repository/sqlite_movie_repository.dart';
import 'package:movies_app/domain/repository/movie_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieRepository>(create: (context) {
          return SQLiteMovieRepository();
        })
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MovieListCubit>(create: (context) {
            return MovieListCubit(
                repository: RepositoryProvider.of<MovieRepository>(context));
          }),
          BlocProvider<AddMovieCubit>(create: (context) {
            return AddMovieCubit(
                repository: RepositoryProvider.of<MovieRepository>(context));
          }),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
