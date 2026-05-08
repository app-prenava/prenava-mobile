import 'package:shared_preferences/shared_preferences.dart';

class MealPlanPreferences {
  static const _daysKey = 'stunting_food_mealplan_days';
  static const _sukaDagingKey = 'stunting_food_suka_daging';
  static const _sukaSayurKey = 'stunting_food_suka_sayur';
  static const _sukaIkanKey = 'stunting_food_suka_ikan';

  final int days;
  final bool sukaDaging;
  final bool sukaSayur;
  final bool sukaIkan;

  const MealPlanPreferences({
    required this.days,
    required this.sukaDaging,
    required this.sukaSayur,
    required this.sukaIkan,
  });

  static const defaults = MealPlanPreferences(
    days: 7,
    sukaDaging: true,
    sukaSayur: true,
    sukaIkan: true,
  );

  static Future<MealPlanPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final days = prefs.getInt(_daysKey) ?? defaults.days;
    return MealPlanPreferences(
      days: days.clamp(7, 14),
      sukaDaging: prefs.getBool(_sukaDagingKey) ?? defaults.sukaDaging,
      sukaSayur: prefs.getBool(_sukaSayurKey) ?? defaults.sukaSayur,
      sukaIkan: prefs.getBool(_sukaIkanKey) ?? defaults.sukaIkan,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_daysKey, days.clamp(7, 14));
    await prefs.setBool(_sukaDagingKey, sukaDaging);
    await prefs.setBool(_sukaSayurKey, sukaSayur);
    await prefs.setBool(_sukaIkanKey, sukaIkan);
  }
}
