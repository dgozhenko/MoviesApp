import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/movie_list_cubit.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:movies_app/domain/enums/filtering_option.dart';
import 'package:movies_app/domain/enums/sorting_option.dart';
import 'package:movies_app/domain/enums/sorting_order.dart';
import 'package:movies_app/domain/model/sorting_filtering_model.dart';
import 'package:movies_app/presentation/widget/movie_list_screen/movie_list_slidable_item.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  final SortingAndFilteringModel sortingAndFilteringModel;
  final Function(int) onWatchedTap;
  final Function(int) onDeleteTap;
  final Function(int) onMovieTap;

  const MovieListWidget({
    required this.movies,
    required this.onDeleteTap,
    required this.onWatchedTap,
    required this.onMovieTap,
    required this.sortingAndFilteringModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void removeFilteringOption(FilteringOption option) {
      context.read<MovieListCubit>().removeFilteringOption(
            option: option,
          );
    }

    return Container(
        decoration: const BoxDecoration(color: Color(0xffefefef)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey),
                          child: const Text(
                            'Sorted by',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            FilterChip(
                              label: Text(
                                sortingAndFilteringModel.sortingOptions
                                    .sortingOption.nameForSorting,
                              ),
                              onSelected: (selected) {},
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            FilterChip(
                              label: Text(
                                sortingAndFilteringModel
                                    .sortingOptions.sortingOrder.nameForSorting,
                              ),
                              onSelected: (selected) {},
                            )
                          ],
                        )
                      ],
                    ),
                    sortingAndFilteringModel.filteringOptions.isEmpty
                        ? const Row()
                        : Row(
                            children: [
                              const SizedBox(
                                  height: 50, child: VerticalDivider()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.grey),
                                    child: const Text(
                                      'Filters',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: sortingAndFilteringModel
                                        .filteringOptions
                                        .map((filter) => Row(
                                              children: [
                                                FilterChip(
                                                  label: Text(filter.name),
                                                  onSelected: (selected) {},
                                                  onDeleted: () {
                                                    removeFilteringOption(
                                                        filter);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                )
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ImplicitlyAnimatedList<Movie>(
                items: movies,
                areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, animation, movie, index) {
                  return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: MovieListSlidableItem(
                      movie: movie,
                      onWatchedTap: () => onWatchedTap(index),
                      onDeleteTap: () => onDeleteTap(index),
                      onMovieTap: () => onMovieTap(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
