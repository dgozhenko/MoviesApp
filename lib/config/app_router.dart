import 'package:flutter/material.dart';
import 'package:movies_app/presentation/screen/add_movie_screen.dart';
import 'package:movies_app/presentation/screen/movie_list_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MovieListScreen.route();
      case MovieListScreen.routeName:
        return MovieListScreen.route();
      case AddMovieScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => AddMovieScreen(
                  movieId: settings.arguments as int?,
                ),
            settings: const RouteSettings(name: AddMovieScreen.routeName));
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(
              body: Center(
                child: Text('Navigaqtion Error'),
              ),
            ),
        settings: const RouteSettings(name: '/error'));
  }
}
