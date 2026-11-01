import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/daily_features_provider.dart';

class DailyTasksSection extends ConsumerStatefulWidget {
  const DailyTasksSection({super.key});

  @override
  ConsumerState<DailyTasksSection> createState() => _DailyTasksSectionState();
}

class _DailyTasksSectionState extends ConsumerState<DailyTasksSection> {
  bool _isDrinkingWater = false;
  int? _completingTaskId;

  Future<void> _handleDrinkWater() async {
    if (_isDrinkingWater) return;
    setState(() => _isDrinkingWater = true);

    try {
      final res = await ref.read(drinkWaterProvider)();
      if (!mounted) return;

      final message = res?['message']?.toString() ?? 'Berhasil mencatat 1 gelas air.';
      final isTargetReached = res?['is_target_reached'] == true;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isTargetReached ? const Color(0xFF2F855A) : const Color(0xFF2B6CB0),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal mencatat air minum. Coba lagi.'),
          backgroundColor: const Color(0xFFC53030),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDrinkingWater = false);
      }
    }
  }

  Future<void> _handleCompleteTask(DailyTaskItem task) async {
    if (_completingTaskId != null) return;
    setState(() => _completingTaskId = task.id);

    try {
      final res = await ref.read(completeTaskProvider)(task.id);
      if (!mounted) return;

      final message = res?['message']?.toString() ?? 'Tugas berhasil diselesaikan!';

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$message (+${task.points} Poin)'),
          backgroundColor: const Color(0xFF2F855A),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal menandai tugas. Coba lagi.'),
          backgroundColor: const Color(0xFFC53030),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _completingTaskId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncProgress = ref.watch(dailyProgressProvider);

    return asyncProgress.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: CircularProgressIndicator(color: Color(0xFFFA6978)),
        ),
      ),
      error: (e, trace) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFED7D7)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFE53E3E)),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Gagal memuat tugas harian.',
                style: TextStyle(fontSize: 13, color: Color(0xFF742A2A)),
              ),
            ),
            TextButton(
              onPressed: () => ref.invalidate(dailyProgressProvider),
              child: const Text('Coba Lagi', style: TextStyle(color: Color(0xFFE53E3E))),
            ),
          ],
        ),
      ),
      data: (progress) {
        final tasks = progress.tasks;
        final completedCount = tasks.where((t) => t.isCompleted).length;
        final totalCount = tasks.length;
        final overallProgress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── DAILY TASKS CHECKLIST HEADER ────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Misi Kepatuhan Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$completedCount / $totalCount Selesai',
                      style: const TextStyle(
                        color: Color(0xFFFA6978),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: overallProgress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFEDF2F7),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                ),
              ),
              const SizedBox(height: 16),

              // ── UNIFIED TASKS LIST ──────────────────────────────
              if (tasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Text(
                    'Semua misi hari ini telah diselesaikan.\nKembalilah besok untuk misi kepatuhan baru.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF718096), fontSize: 13, height: 1.4),
                  ),
                )
              else
                ...tasks.map((task) => _buildTaskItemCard(context, task, progress.hydration)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskItemCard(
    BuildContext context,
    DailyTaskItem task,
    HydrationStatus hydration,
  ) {
    final isDone = task.isCompleted;
    final isCompleting = _completingTaskId == task.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFF7FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? const Color(0xFFE2E8F0) : const Color(0xFFEDF2F7),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFFEDF2F7) : const Color(0xFFFA6978).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              task.iconData,
              color: isDone ? const Color(0xFFA0AEC0) : const Color(0xFFFA6978),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Task Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone ? const Color(0xFFA0AEC0) : const Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFFEDF2F7) : const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+${task.points} pts',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDone ? const Color(0xFFA0AEC0) : const Color(0xFFFA6978),
                        ),
                      ),
                    ),
                  ],
                ),
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    task.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDone ? const Color(0xFFCBD5E0) : const Color(0xFF718096),
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Action / Status
          if (isDone)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 16, color: Color(0xFF16A34A)),
            )
          else if (task.taskType == 'hydration')
            // Aksi khusus minum air
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Text(
                    '${hydration.currentGlasses}/8 Gelas',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                IconButton(
                  icon: _isDrinkingWater
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0284C7)),
                        )
                      : const Icon(
                          Icons.add_circle,
                          color: Color(0xFF0284C7),
                          size: 24,
                        ),
                  tooltip: 'Catat 1 Gelas (+250 ml)',
                  onPressed: _isDrinkingWater ? null : _handleDrinkWater,
                ),
              ],
            )
          else if (task.actionRoute != null && task.actionRoute!.isNotEmpty && task.isAuto)
            // Tombol pintas navigasi ke fitur
            OutlinedButton(
              onPressed: () {
                context.push(task.actionRoute!);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: const Size(0, 32),
                side: const BorderSide(color: Color(0xFFFA6978)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Buka',
                style: TextStyle(
                  color: Color(0xFFFA6978),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            // Tombol centang manual (Tablet Tambah Darah / Jalan Santai)
            IconButton(
              icon: isCompleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFA6978)),
                    )
                  : const Icon(
                      Icons.radio_button_unchecked,
                      color: Color(0xFFFA6978),
                      size: 24,
                    ),
              tooltip: 'Tandai Selesai',
              onPressed: isCompleting ? null : () => _handleCompleteTask(task),
            ),
        ],
      ),
    );
  }
}
