enum SortingOrder { ascending, descending }

extension SortingOrderExtension on SortingOrder {
  String get nameForSorting {
    switch (this) {
      case SortingOrder.ascending:
        return 'Ascending';
      case SortingOrder.descending:
        return 'Descending';
      default:
        return '';
    }
  }
}
