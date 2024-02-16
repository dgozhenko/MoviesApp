enum SortingOption { byName, byDate }

extension SortingOptionExtensions on SortingOption {
  String get nameForSorting {
    switch (this) {
      case SortingOption.byName:
        return 'Name';
      case SortingOption.byDate:
        return 'Date';
      default:
        return '';
    }
  }
}
