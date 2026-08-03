class FamilyMemberOptions {
  FamilyMemberOptions._();

  static const List<String> relationships = [
    'Mother',
    'Father',
    'Spouse',
    'Child',
    'Sibling',
    'Guardian',
    'Other',
  ];

  static const List<String> genders = ['Female', 'Male', 'Other'];

  /// Descending so the most likely years (recent adults) appear first.
  static List<String> birthYears({int span = 100}) {
    final currentYear = DateTime.now().year;
    return List.generate(span, (i) => (currentYear - i).toString());
  }
}
