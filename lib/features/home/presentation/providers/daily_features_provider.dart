import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

class DailyTaskItem {
  final int id;
  final String title;
  final String? description;
  final String taskType;
  final int points;
  final bool isCompleted;
  /// True when this task is auto-completed on feature navigation.
  final bool isAuto;

  DailyTaskItem({
    required this.id,
    required this.title,
    this.description,
    required this.taskType,
    required this.points,
    required this.isCompleted,
    this.isAuto = false,
  });

  factory DailyTaskItem.fromJson(Map<String, dynamic> json) {
    return DailyTaskItem(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      taskType: json['task_type'] ?? '',
      points: json['points'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
      isAuto: json['is_auto'] ?? false,
    );
  }
}

class DailyProgress {
  final List<DailyTaskItem> tasks;
  final int streak;
  final int longestStreak;

  DailyProgress({
    required this.tasks,
    required this.streak,
    required this.longestStreak,
  });
}

final dailyProgressProvider = FutureProvider.autoDispose<DailyProgress>((ref) async {
  final dio = ref.watch(appDioProvider);
  final response = await dio.get('/user/daily-progress');
  
  final data = response.data;
  final tasks = (data['tasks'] as List)
      .map((t) => DailyTaskItem.fromJson(t))
      .toList();
      
  return DailyProgress(
    tasks: tasks,
    streak: data['streak'] ?? 0,
    longestStreak: data['longest_streak'] ?? 0,
  );
});

final completeTaskProvider = Provider((ref) {
  return (int taskId) async {
    final dio = ref.read(appDioProvider);
    await dio.post('/user/daily-task/complete', data: {
      'daily_task_id': taskId,
    });
    ref.invalidate(dailyProgressProvider);
  };
});
