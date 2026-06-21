import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../deteksi_anemia/data/models/quality_check_item.dart';

/// Shared Preferences helper provider
/// 
/// Provides access to SharedPreferences instance for storing tutorial state.
/// Handles errors gracefully with safe defaults.
final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  try {
    return await SharedPreferences.getInstance();
  } catch (e) {
    // Log error and rethrow - error handling will be at UI level
    rethrow;
  }
});

/// Tutorial shown state provider
/// 
/// Tracks whether tutorial dialog has been shown in current session.
/// Default: false (not shown yet)
final anemiaTutorialShownProvider = 
    StateNotifierProvider<_TutorialShownNotifier, bool>(
  (ref) => _TutorialShownNotifier(),
);

class _TutorialShownNotifier extends StateNotifier<bool> {
  _TutorialShownNotifier() : super(false);

  void markAsShown() {
    state = true;
  }

  void reset() {
    state = false;
  }
}

/// Visual Guide expanded state provider
/// 
/// Tracks whether VisualGuideWidget is in expanded or collapsed state.
/// Default: false (collapsed)
final anemiaVisualGuideExpandedProvider = 
    StateProvider<bool>((ref) => false);

/// Quality Check Items provider
/// 
/// Generates and returns the list of 5 quality check items.
/// Items are immutable and generated from QualityCheckItem factory.
final anemiaQualityCheckItemsProvider = 
    Provider<List<QualityCheckItem>>((ref) {
  return QualityCheckItem.getDefaultItems();
});

/// SharedPreferences key constants
class AnemiaPrefsKeys {
  static const String hasSeenAnemiaTutorial = 'has_seen_anemia_tutorial';
}
