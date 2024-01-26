import 'package:flutter/material.dart';
import 'package:movies_app/presentation/movie_list_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MovieListScreen.route();
      case MovieListScreen.routeName:
        return MovieListScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(),
        settings: const RouteSettings(name: '/error'));
  }
}
