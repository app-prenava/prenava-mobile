import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/badges_provider.dart';

class BadgesShowcaseModal extends ConsumerWidget {
  const BadgesShowcaseModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BadgesShowcaseModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBadges = ref.watch(badgesProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Koleksi Lencana Bunda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 2),
                    asyncBadges.maybeWhen(
                      data: (res) => Text(
                        '${res.totalUnlocked} dari ${res.totalBadges} lencana telah diraih',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF718096),
                        ),
                      ),
                      orElse: () => const Text(
                        'Pencapaian kepatuhan kesehatan maternal',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF718096)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: asyncBadges.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(color: Color(0xFFFA6978)),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 40, color: Color(0xFFE53E3E)),
                      const SizedBox(height: 12),
                      const Text(
                        'Gagal memuat daftar lencana.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => ref.invalidate(badgesProvider),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (response) {
                final badges = response.badges;

                if (badges.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Belum ada lencana yang tersedia.',
                        style: TextStyle(color: Color(0xFF718096)),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: badges.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    return _BadgeListItem(badge: badge);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeListItem extends StatelessWidget {
  final BadgeItem badge;

  const _BadgeListItem({required this.badge});

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'medication':
        return Icons.medication_outlined;
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'local_fire_department':
        return Icons.local_fire_department_outlined;
      case 'emoji_events':
        return Icons.emoji_events_outlined;
      case 'wb_sunny':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.military_tech_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;

    final primaryColor = isUnlocked ? const Color(0xFFFA6978) : const Color(0xFFA0AEC0);
    final bgColor = isUnlocked ? const Color(0xFFFFF5F5) : const Color(0xFFF7FAFC);
    final borderColor = isUnlocked ? const Color(0xFFFED7D7) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUnlocked ? const Color(0xFFFA6978).withValues(alpha: 0.12) : const Color(0xFFEDF2F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _resolveIcon(badge.icon),
              color: primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),

          // Description & Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        badge.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isUnlocked ? const Color(0xFF2D3748) : const Color(0xFF718096),
                        ),
                      ),
                    ),
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38A169).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Diraih',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F855A),
                          ),
                        ),
                      )
                    else
                      Text(
                        '${badge.progressCurrent}/${badge.progressTarget}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF718096),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A5568),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Progress Bar or Unlocked Date
                if (isUnlocked)
                  Text(
                    badge.unlockedAt != null
                        ? 'Diraih pada ${_formatDate(badge.unlockedAt!)}'
                        : 'Lencana aktif',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718096),
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: badge.progressFraction,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                    ),
                  ),

                if (badge.bonusPoints > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    '+${badge.bonusPoints} Poin Bonus',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53E3E),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
