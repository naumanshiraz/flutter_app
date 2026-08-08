enum ConciergeCategory { forYou, food, cleaningService, delivery }

extension ConciergeCategoryLabel on ConciergeCategory {
  String get label {
    switch (this) {
      case ConciergeCategory.forYou:
        return 'For you';
      case ConciergeCategory.food:
        return 'Food';
      case ConciergeCategory.cleaningService:
        return 'Cleaning service';
      case ConciergeCategory.delivery:
        return 'Delivery';
    }
  }
}
