import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import '../providers/daily_features_provider.dart';

class DailyTasksSection extends ConsumerWidget {
  const DailyTasksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProgress = ref.watch(dailyProgressProvider);

    return asyncProgress.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(color: Color(0xFFFA6978)))),
      error: (e, trace) => const SizedBox(), 
      data: (progress) {
        if (progress.tasks.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text('Daily Tasks & Streak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 12),
                Text('Belum ada tugas/misi hari ini.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final completedCount = progress.tasks.where((t) => t.isCompleted).length;
        final totalCount = progress.tasks.length;
        final progressVal = totalCount > 0 ? completedCount / totalCount : 0.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Streak: ${progress.streak} Hari',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Text(
                    '$completedCount / $totalCount',
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progressVal,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              ...progress.tasks.map((task) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  title: Text(task.title, style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  )),
                  subtitle: task.description != null ? Text(task.description!) : null,
                  trailing: Text('+${task.points} pts', style: const TextStyle(color: const Color(0xFFFA6978), fontWeight: FontWeight.bold)),
                  onTap: () {
                    if (!task.isCompleted) {
                      ref.read(completeTaskProvider)(task.id);
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
