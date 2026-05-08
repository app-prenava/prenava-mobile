import '../../domain/entities/preference.dart';

class PreferenceDto {
  final String? budgetLevel;
  final List<String> preferredCategories;
  final List<String> excludedCategories;
  final List<String> excludedKeywords;
  final List<String> allergies;
  final String? dietStyle;
  final bool? avoidSpicy;
  final String? notes;

  const PreferenceDto({
    this.budgetLevel,
    this.preferredCategories = const [],
    this.excludedCategories = const [],
    this.excludedKeywords = const [],
    this.allergies = const [],
    this.dietStyle,
    this.avoidSpicy,
    this.notes,
  });

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  factory PreferenceDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return PreferenceDto(
      budgetLevel: data['budget_level']?.toString(),
      preferredCategories: _toStringList(data['preferred_categories']),
      excludedCategories: _toStringList(data['excluded_categories']),
      excludedKeywords: _toStringList(data['excluded_keywords']),
      allergies: _toStringList(data['allergies']),
      dietStyle: data['diet_style']?.toString(),
      avoidSpicy: data['avoid_spicy'] is bool ? data['avoid_spicy'] as bool : null,
      notes: data['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (budgetLevel != null) 'budget_level': budgetLevel,
      if (preferredCategories.isNotEmpty) 'preferred_categories': preferredCategories,
      if (excludedCategories.isNotEmpty) 'excluded_categories': excludedCategories,
      if (excludedKeywords.isNotEmpty) 'excluded_keywords': excludedKeywords,
      if (allergies.isNotEmpty) 'allergies': allergies,
      if (dietStyle != null) 'diet_style': dietStyle,
      if (avoidSpicy != null) 'avoid_spicy': avoidSpicy,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }

  StuntingPreference toEntity() {
    return StuntingPreference(
      budgetLevel: budgetLevel,
      preferredCategories: preferredCategories,
      excludedCategories: excludedCategories,
      excludedKeywords: excludedKeywords,
      allergies: allergies,
      dietStyle: dietStyle,
      avoidSpicy: avoidSpicy,
      notes: notes,
    );
  }

  static PreferenceDto fromEntity(StuntingPreference e) {
    return PreferenceDto(
      budgetLevel: e.budgetLevel,
      preferredCategories: e.preferredCategories,
      excludedCategories: e.excludedCategories,
      excludedKeywords: e.excludedKeywords,
      allergies: e.allergies,
      dietStyle: e.dietStyle,
      avoidSpicy: e.avoidSpicy,
      notes: e.notes,
    );
  }
}

