import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../providers/daily_features_provider.dart';

/// Feature slugs — harus cocok dengan task_type 'feature_{slug}' di backend.
enum AppFeature {
  olahraga,
  hidrasi,
  tips,
  kalkulatorHpl,
  anemia,
  depresi,
  komunitas,
  kunjungan,
  appointment,
  localWisdom,
}

extension AppFeatureSlug on AppFeature {
  String get slug {
    switch (this) {
      case AppFeature.olahraga:
        return 'olahraga';
      case AppFeature.hidrasi:
        return 'hidrasi';
      case AppFeature.tips:
        return 'tips';
      case AppFeature.kalkulatorHpl:
        return 'kalkulator_hpl';
      case AppFeature.anemia:
        return 'anemia';
      case AppFeature.depresi:
        return 'depresi';
      case AppFeature.komunitas:
        return 'komunitas';
      case AppFeature.kunjungan:
        return 'kunjungan';
      case AppFeature.appointment:
        return 'appointment';
      case AppFeature.localWisdom:
        return 'local_wisdom';
    }
  }
}

/// Provider that exposes a trackFeature function.
/// Fire-and-forget: UI doesn't need to wait for this.
final featureTrackerProvider = Provider<FeatureTracker>((ref) {
  return FeatureTracker(ref);
});

class FeatureTracker {
  final Ref _ref;

  FeatureTracker(this._ref);

  /// Call this whenever user navigates to a feature.
  /// Silent — never throws, never blocks UI.
  Future<void> track(AppFeature feature) async {
    try {
      final dio = _ref.read(appDioProvider);
      await dio.post('/user/feature-track', data: {'feature': feature.slug});
      // Refresh progress so bottom sheet updates if open
      _ref.invalidate(dailyProgressProvider);
    } catch (_) {
      // Intentionally silent — tracking failure must never break UX
    }
  }
}
