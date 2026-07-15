/// Static picker options for the property form. No backend for this
/// yet, so these are hand-picked common values — swap for a real
/// building/unit lookup once one exists.
class PropertyOptions {
  PropertyOptions._();

  static const List<String> types = [
    'Apartment',
    'Condo',
    'Townhouse',
    'Studio',
    'Penthouse',
    'Other',
  ];

  static const List<String> buildings = [
    '21 - A',
    '21 - B',
    '21 - C',
    '22 - A',
    '22 - B',
  ];

  /// Plain floor numbers ("1", "2", ... "50") — matches what the field
  /// itself displays (e.g. "20"). The summary card applies [ordinal]
  /// only for its own display, so the underlying stored value stays a
  /// plain number.
  static List<String> floors({int count = 50}) {
    return List.generate(count, (i) => (i + 1).toString());
  }

  /// "20" -> "20th" — used only by the summary card's display, per the
  /// design (field shows "20", card shows "20th").
  static String ordinal(String floorNumber) {
    final n = int.tryParse(floorNumber);
    if (n == null) return floorNumber;
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }
}
