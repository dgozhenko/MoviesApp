import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/cubit/movie_list_cubit.dart';
import 'package:movies_app/domain/enums/filtering_option.dart';
import 'package:movies_app/domain/enums/sorting_option.dart';
import 'package:movies_app/domain/enums/sorting_order.dart';
import 'package:movies_app/domain/state/movie_list_state.dart';

class SortingAndFilteringBottomDialog extends StatelessWidget {
  const SortingAndFilteringBottomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    void addFilteringOption(FilteringOption option) {
      context.read<MovieListCubit>().addFilteringOption(
            option: option,
          );
    }

    void removeFilteringOption(FilteringOption option) {
      context.read<MovieListCubit>().removeFilteringOption(
            option: option,
          );
    }

    void changeSortingOption(SortingOption option) {
      context.read<MovieListCubit>().changeSortingOption(option: option);
    }

    void changeSortingOrder(SortingOrder order) {
      context.read<MovieListCubit>().changeSortingOrder(order: order);
    }

    return BlocBuilder<MovieListCubit, MovieListState>(
      builder: (context, state) {
        if (state is LoadedState) {
          final isWatched = state.sortingAndFiltering.filteringOptions
              .contains(FilteringOption.watched);
          final isNotWatched = state.sortingAndFiltering.filteringOptions
              .contains(FilteringOption.notWatched);
          final sortingOption =
              state.sortingAndFiltering.sortingOptions.sortingOption;
          final sortingOrder =
              state.sortingAndFiltering.sortingOptions.sortingOrder;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Sort and Filter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Filtering',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    FilterChip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        'Watched',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      deleteIcon: isWatched
                          ? const Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                      onDeleted: isWatched
                          ? () {
                              removeFilteringOption(FilteringOption.watched);
                            }
                          : null,
                      onSelected: (selected) {
                        if (isWatched) {
                          removeFilteringOption(FilteringOption.watched);
                        } else {
                          addFilteringOption(FilteringOption.watched);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        'Not Watched',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      deleteIcon: isNotWatched
                          ? const Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                      onDeleted: isNotWatched
                          ? () {
                              removeFilteringOption(FilteringOption.notWatched);
                            }
                          : null,
                      onSelected: (selected) {
                        if (isNotWatched) {
                          removeFilteringOption(FilteringOption.notWatched);
                        } else {
                          addFilteringOption(FilteringOption.notWatched);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Sorting',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    FilterChip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text('by Name',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                      showCheckmark: sortingOption == SortingOption.byName,
                      selected: sortingOption == SortingOption.byName,
                      onSelected: (selected) {
                        if (sortingOption != SortingOption.byName) {
                          changeSortingOption(SortingOption.byName);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text('by Date',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                      showCheckmark: sortingOption == SortingOption.byDate,
                      selected: sortingOption == SortingOption.byDate,
                      onSelected: (selected) {
                        if (sortingOption != SortingOption.byDate) {
                          changeSortingOption(SortingOption.byDate);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    FilterChip(
                      label: const Text('Ascending'),
                      showCheckmark: sortingOrder == SortingOrder.ascending,
                      selected: sortingOrder == SortingOrder.ascending,
                      onSelected: (selected) {
                        if (sortingOrder != SortingOrder.ascending) {
                          changeSortingOrder(SortingOrder.ascending);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Descending'),
                      showCheckmark: sortingOrder == SortingOrder.descending,
                      selected: sortingOrder == SortingOrder.descending,
                      onSelected: (selected) {
                        if (sortingOrder != SortingOrder.descending) {
                          changeSortingOrder(SortingOrder.descending);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
