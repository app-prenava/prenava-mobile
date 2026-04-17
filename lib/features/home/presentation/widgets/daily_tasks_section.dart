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
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.amber, size: 32),
                    SizedBox(width: 8),
                    Text('Daily Tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Belum ada tugas/misi hari ini.\nKembalilah besok untuk misi baru!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          );
        }

        final completedCount = progress.tasks.where((t) => t.isCompleted).length;
        final totalCount = progress.tasks.length;
        final progressVal = totalCount > 0 ? completedCount / totalCount : 0.0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Streak: ${progress.streak} Hari',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$completedCount / $totalCount',
                      style: const TextStyle(color: Color(0xFFFA6978), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: progressVal,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tugas Hari Ini',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ...progress.tasks.map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: task.isCompleted ? Colors.green.withValues(alpha: 0.1) : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        task.isCompleted ? Icons.check : Icons.radio_button_off,
                        color: task.isCompleted ? Colors.green : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey : const Color(0xFF424242),
                      ),
                    ),
                    subtitle: task.description != null 
                        ? Text(task.description!, style: const TextStyle(fontSize: 13)) 
                        : null,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${task.points}',
                          style: const TextStyle(
                            color: Color(0xFFFA6978),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Text('pts', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    onTap: () {
                      if (!task.isCompleted) {
                        ref.read(completeTaskProvider)(task.id);
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
