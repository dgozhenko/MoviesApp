import 'package:movies_app/domain/enums/filtering_option.dart';
import 'package:movies_app/domain/model/sorting_model.dart';

class SortingAndFilteringModel {
  final List<FilteringOption> filteringOptions;
  final SortingModel sortingOptions;

  SortingAndFilteringModel({
    required this.filteringOptions,
    required this.sortingOptions,
  });

  SortingAndFilteringModel copyWith({
    List<FilteringOption>? filtering,
    SortingModel? sorting,
  }) {
    return SortingAndFilteringModel(
      filteringOptions: filtering ?? filteringOptions,
      sortingOptions: sorting ?? sortingOptions,
    );
  }
}
