enum FilteringOption { watched, notWatched }

extension FilteringOptionExtensions on FilteringOption {
  String get name {
    switch (this) {
      case FilteringOption.watched:
        return 'Watched';
      case FilteringOption.notWatched:
        return 'Not Watched';
      default:
        return '';
    }
  }
}
