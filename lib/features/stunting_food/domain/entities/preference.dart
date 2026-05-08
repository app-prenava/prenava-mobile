class StuntingPreference {
  final String? budgetLevel;
  final List<String> preferredCategories;
  final List<String> excludedCategories;
  final List<String> excludedKeywords;
  final List<String> allergies;
  final String? dietStyle;
  final bool? avoidSpicy;
  final String? notes;

  const StuntingPreference({
    this.budgetLevel,
    this.preferredCategories = const [],
    this.excludedCategories = const [],
    this.excludedKeywords = const [],
    this.allergies = const [],
    this.dietStyle,
    this.avoidSpicy,
    this.notes,
  });

  bool get hasAnyValue {
    return budgetLevel != null ||
        preferredCategories.isNotEmpty ||
        excludedCategories.isNotEmpty ||
        excludedKeywords.isNotEmpty ||
        allergies.isNotEmpty ||
        dietStyle != null ||
        avoidSpicy != null ||
        (notes?.trim().isNotEmpty ?? false);
  }
}

