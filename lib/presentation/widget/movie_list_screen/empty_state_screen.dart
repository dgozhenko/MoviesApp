import 'package:flutter/material.dart';

class EmptyScreenWidget extends StatelessWidget {
  final Function() addMoviePressed;
  const EmptyScreenWidget({required this.addMoviePressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No data in watchlist',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: addMoviePressed, child: const Text('Add a movie'))
        ],
      ),
    );
  }
}
