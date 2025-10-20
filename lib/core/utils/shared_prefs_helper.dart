import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _onboardingKey = 'onboarding_complete';

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, value);
  }
}

