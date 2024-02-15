import 'package:movies_app/domain/enums/sorting_option.dart';
import 'package:movies_app/domain/enums/sorting_order.dart';

class SortingModel {
  final SortingOption sortingOption;
  final SortingOrder sortingOrder;

  SortingModel({required this.sortingOption, required this.sortingOrder});

  SortingModel copyWith({SortingOption? option, SortingOrder? order}) {
    return SortingModel(
      sortingOption: option ?? sortingOption,
      sortingOrder: order ?? sortingOrder,
    );
  }
}
