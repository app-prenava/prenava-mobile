import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/daily_features_provider.dart';
import 'badges_showcase_modal.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. MATERNAL TIER & STREAK CARD ──────────────────────
              _buildTierHeaderCard(context, progress),
              const SizedBox(height: 16),

              // ── 2. PROGRESSIVE HYDRATION TRACKER ────────────────────
              _buildHydrationTrackerCard(context, progress.hydration),
              const SizedBox(height: 20),

              // ── 3. DAILY TASKS CHECKLIST HEADER ────────────────────
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
              const SizedBox(height: 14),

              // ── 4. UNIFIED TASKS LIST ──────────────────────────────
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
                ...tasks.map((task) => _buildTaskItemCard(context, task)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTierHeaderCard(BuildContext context, DailyProgress progress) {
    final tier = progress.tierInfo;
    final userPoints = progress.userPoints;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Tier Icon Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tier.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(tier.iconData, color: tier.color, size: 24),
              ),
              const SizedBox(width: 12),

              // Tier Name & Points
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: tier.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${userPoints.lifetimePoints} Poin Sehat Terkumpul',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),

              // Streak Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFEDD5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFEA580C),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.streak} Hari',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEDF2F7)),
          const SizedBox(height: 12),

          // Next Tier Progress or Max Tier
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: tier.nextTier != null
                    ? Text(
                        'Menuju ${tier.nextTier}: butuh ${tier.pointsNeeded} Pts & ${tier.streakNeeded} hari streak',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const Text(
                        'Tingkat Paripurna Generasi Emas',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF38A169),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              InkWell(
                onTap: () => BadgesShowcaseModal.show(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.military_tech_outlined,
                        size: 16,
                        color: Color(0xFFFA6978),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lencana (${progress.unlockedBadgesCount})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFA6978),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationTrackerCard(BuildContext context, HydrationStatus hydration) {
    final current = hydration.currentGlasses;
    final isDone = hydration.isCompletedToday;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: Color(0xFF0284C7),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Target Hidrasi Harian',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                      Text(
                        '$current dari 8 Gelas (${hydration.currentMl} / 2.000 ml)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0C4A6E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isDone)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 14, color: Color(0xFF15803D)),
                      SizedBox(width: 4),
                      Text(
                        'Tercapai (+10 Pts)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // 8 Glasses Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(8, (index) {
              final isFilled = index < current;
              return Container(
                width: 32,
                height: 36,
                decoration: BoxDecoration(
                  color: isFilled ? const Color(0xFF0284C7) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isFilled ? const Color(0xFF0284C7) : const Color(0xFFBAE6FD),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.local_drink,
                  size: 18,
                  color: isFilled ? Colors.white : const Color(0xFFBAE6FD),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isDrinkingWater ? null : _handleDrinkWater,
              icon: _isDrinkingWater
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.add, size: 18),
              label: Text(
                isDone ? 'Tambah Gelas Ekstra (+250 ml)' : 'Catat 1 Gelas Air (+250 ml)',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItemCard(BuildContext context, DailyTaskItem task) {
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
