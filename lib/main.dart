import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/config/app_router.dart';
import 'package:movies_app/config/locator.dart';
import 'package:movies_app/data/cubit/movie_list_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<MovieListCubit>(create: (context) {
                  return MovieListCubit();
                })
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: AppRouter.onGenerateRoute,
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
