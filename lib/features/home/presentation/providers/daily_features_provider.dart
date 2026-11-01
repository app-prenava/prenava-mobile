import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'badges_provider.dart';

class UserPoints {
  final int currentBalance;
  final int lifetimePoints;

  UserPoints({
    required this.currentBalance,
    required this.lifetimePoints,
  });

  factory UserPoints.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserPoints(currentBalance: 0, lifetimePoints: 0);
    }
    return UserPoints(
      currentBalance: json['current_balance'] is int
          ? json['current_balance']
          : int.tryParse(json['current_balance']?.toString() ?? '0') ?? 0,
      lifetimePoints: json['lifetime_points'] is int
          ? json['lifetime_points']
          : int.tryParse(json['lifetime_points']?.toString() ?? '0') ?? 0,
    );
  }
}

class MaternalTier {
  final String tier;
  final String name;
  final String icon;
  final String colorHex;
  final String? nextTier;
  final int pointsNeeded;
  final int streakNeeded;

  MaternalTier({
    required this.tier,
    required this.name,
    required this.icon,
    required this.colorHex,
    this.nextTier,
    required this.pointsNeeded,
    required this.streakNeeded,
  });

  factory MaternalTier.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MaternalTier(
        tier: 'bronze',
        name: 'Bunda Perunggu',
        icon: 'shield',
        colorHex: '#CD7F32',
        nextTier: 'Bunda Perak',
        pointsNeeded: 500,
        streakNeeded: 7,
      );
    }

    return MaternalTier(
      tier: (json['tier'] ?? 'bronze').toString(),
      name: (json['name'] ?? 'Bunda Perunggu').toString(),
      icon: (json['icon'] ?? 'shield').toString(),
      colorHex: (json['color'] ?? '#CD7F32').toString(),
      nextTier: json['next_tier']?.toString(),
      pointsNeeded: json['points_needed'] is int
          ? json['points_needed']
          : int.tryParse(json['points_needed']?.toString() ?? '0') ?? 0,
      streakNeeded: json['streak_needed'] is int
          ? json['streak_needed']
          : int.tryParse(json['streak_needed']?.toString() ?? '0') ?? 0,
    );
  }

  Color get color {
    try {
      final hex = colorHex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return const Color(0xFFCD7F32);
  }

  IconData get iconData {
    switch (icon) {
      case 'diamond':
        return Icons.diamond_outlined;
      case 'emoji_events':
        return Icons.emoji_events_outlined;
      case 'military_tech':
        return Icons.military_tech_outlined;
      case 'shield':
      default:
        return Icons.shield_outlined;
    }
  }
}

class HydrationStatus {
  final int currentGlasses;
  final int targetGlasses;
  final int currentMl;
  final int targetMl;
  final bool isCompletedToday;

  HydrationStatus({
    required this.currentGlasses,
    required this.targetGlasses,
    required this.currentMl,
    required this.targetMl,
    required this.isCompletedToday,
  });

  factory HydrationStatus.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HydrationStatus(
        currentGlasses: 0,
        targetGlasses: 8,
        currentMl: 0,
        targetMl: 2000,
        isCompletedToday: false,
      );
    }

    return HydrationStatus(
      currentGlasses: json['current_glasses'] is int
          ? json['current_glasses']
          : int.tryParse(json['current_glasses']?.toString() ?? '0') ?? 0,
      targetGlasses: json['target_glasses'] is int
          ? json['target_glasses']
          : int.tryParse(json['target_glasses']?.toString() ?? '8') ?? 8,
      currentMl: json['current_ml'] is int
          ? json['current_ml']
          : int.tryParse(json['current_ml']?.toString() ?? '0') ?? 0,
      targetMl: json['target_ml'] is int
          ? json['target_ml']
          : int.tryParse(json['target_ml']?.toString() ?? '2000') ?? 2000,
      isCompletedToday: json['is_completed_today'] == true,
    );
  }

  double get fraction {
    if (targetGlasses <= 0) return 0.0;
    final val = currentGlasses / targetGlasses;
    return val > 1.0 ? 1.0 : (val < 0.0 ? 0.0 : val);
  }
}

class DailyTaskItem {
  final int id;
  final String title;
  final String? description;
  final String taskType;
  final int points;
  final bool isCompleted;
  final bool isAuto;
  final String? actionRoute;

  DailyTaskItem({
    required this.id,
    required this.title,
    this.description,
    required this.taskType,
    required this.points,
    required this.isCompleted,
    this.isAuto = false,
    this.actionRoute,
  });

  factory DailyTaskItem.fromJson(Map<String, dynamic> json) {
    final taskType = (json['task_type'] ?? '').toString();
    final rawTitle = (json['title'] ?? '').toString();
    final rawDescription = json['description']?.toString();

    final isLegacyUdaraTask =
        taskType == 'feature_udara' ||
        rawTitle.toLowerCase().contains('kualitas udara');

    return DailyTaskItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: isLegacyUdaraTask ? 'Cek Risiko Stunting' : rawTitle,
      description: isLegacyUdaraTask
          ? 'Lakukan skrining risiko stunting untuk memantau kesehatan janin & anak.'
          : rawDescription,
      taskType: taskType,
      points: json['points'] is int ? json['points'] : int.tryParse(json['points']?.toString() ?? '0') ?? 0,
      isCompleted: json['is_completed'] == true,
      isAuto: json['is_auto'] == true,
      actionRoute: json['action_route']?.toString(),
    );
  }

  IconData get iconData {
    switch (taskType) {
      case 'hydration':
        return Icons.water_drop_outlined;
      case 'supplement':
        return Icons.medication_outlined;
      case 'exercise':
        return Icons.directions_walk;
      case 'food_compliance':
        return Icons.restaurant_outlined;
      case 'feature_anemia':
        return Icons.bloodtype_outlined;
      case 'feature_depresi':
        return Icons.psychology_outlined;
      case 'feature_olahraga':
        return Icons.fitness_center;
      case 'feature_komunitas':
        return Icons.forum_outlined;
      case 'feature_kalkulator_hpl':
        return Icons.calendar_today_outlined;
      case 'feature_tips':
        return Icons.menu_book_outlined;
      case 'feature_local_wisdom':
        return Icons.auto_stories_outlined;
      default:
        return Icons.task_alt;
    }
  }
}

class DailyProgress {
  final UserPoints userPoints;
  final MaternalTier tierInfo;
  final int streak;
  final int longestStreak;
  final bool isStreakActiveToday;
  final HydrationStatus hydration;
  final List<DailyTaskItem> tasks;
  final int unlockedBadgesCount;

  DailyProgress({
    required this.userPoints,
    required this.tierInfo,
    required this.streak,
    required this.longestStreak,
    required this.isStreakActiveToday,
    required this.hydration,
    required this.tasks,
    required this.unlockedBadgesCount,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> data) {
    final rawTasks = (data['tasks'] as List?) ?? [];
    final tasks = rawTasks
        .map((t) => DailyTaskItem.fromJson(t as Map<String, dynamic>))
        .toList();

    final rawStreakDetails = data['streak_details'] as Map<String, dynamic>?;

    return DailyProgress(
      userPoints: UserPoints.fromJson(data['user_points'] as Map<String, dynamic>?),
      tierInfo: MaternalTier.fromJson(data['tier_info'] as Map<String, dynamic>?),
      streak: data['streak'] is int
          ? data['streak']
          : int.tryParse(data['streak']?.toString() ?? '0') ?? 0,
      longestStreak: data['longest_streak'] is int
          ? data['longest_streak']
          : int.tryParse(data['longest_streak']?.toString() ?? '0') ?? 0,
      isStreakActiveToday: rawStreakDetails?['is_streak_active_today'] == true,
      hydration: HydrationStatus.fromJson(data['hydration'] as Map<String, dynamic>?),
      tasks: tasks,
      unlockedBadgesCount: data['unlocked_badges_count'] is int
          ? data['unlocked_badges_count']
          : int.tryParse(data['unlocked_badges_count']?.toString() ?? '0') ?? 0,
    );
  }
}

final dailyProgressProvider = FutureProvider.autoDispose<DailyProgress>((
  ref,
) async {
  final dio = ref.watch(appDioProvider);
  final response = await dio.get('/user/daily-progress');

  final data = response.data as Map<String, dynamic>;
  return DailyProgress.fromJson(data);
});

final completeTaskProvider = Provider((ref) {
  return (int taskId) async {
    final dio = ref.read(appDioProvider);
    final response = await dio.post(
      '/user/daily-task/complete',
      data: {'daily_task_id': taskId},
    );
    ref.invalidate(dailyProgressProvider);
    ref.invalidate(badgesProvider);
    return response.data as Map<String, dynamic>?;
  };
});

final drinkWaterProvider = Provider((ref) {
  return () async {
    final dio = ref.read(appDioProvider);
    final response = await dio.post('/user/hydration/drink');
    ref.invalidate(dailyProgressProvider);
    ref.invalidate(badgesProvider);
    return response.data as Map<String, dynamic>?;
  };
});
