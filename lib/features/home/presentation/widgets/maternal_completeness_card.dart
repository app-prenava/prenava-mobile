import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/maternal_completeness_provider.dart';

class MaternalCompletenessCard extends ConsumerWidget {
  const MaternalCompletenessCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completenessAsync = ref.watch(maternalCompletenessProvider);

    return completenessAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (data) => _buildCard(context, data),
    );
  }

  Widget _buildCard(BuildContext context, MaternalCompletenessData data) {
    final isAllComplete = data.count >= 4;
    final pctInt = data.percentage.round();

    Color progressColor = const Color(0xFFFA6978);
    Color tagBg = const Color(0xFFFFF0F2);
    Color tagColor = const Color(0xFFFA6978);

    if (isAllComplete) {
      progressColor = const Color(0xFF52C41A);
      tagBg = const Color(0xFFF6FFED);
      tagColor = const Color(0xFF52C41A);
    } else if (data.count >= 2) {
      progressColor = const Color(0xFF1890FF);
      tagBg = const Color(0xFFE6F7FF);
      tagColor = const Color(0xFF1890FF);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAllComplete
              ? const Color(0xFFB7EB8F)
              : const Color(0xFFFA6978).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Progress Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAllComplete
                      ? Icons.check_circle_outline
                      : Icons.favorite_border_rounded,
                  color: progressColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pemantauan Mandiri Kehamilan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Terhubung ke Sistem Triase Bidan',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: progressColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${data.count}/4 Terisi ($pctInt%)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: tagColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (data.percentage / 100.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),

          const SizedBox(height: 10),

          // Supportive, Non-Alarmist Message
          Text(
            data.supportiveMessage,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF555555),
              height: 1.35,
            ),
          ),

          // Action Shortcuts when incomplete
          if (!isAllComplete) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 10),
            Text(
              'Pintasan Pemantauan yang Perlu Dilengkapi:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_isMissing(data.missingModalities, 'Piring Nutrisi'))
                  _buildShortcutButton(
                    context,
                    label: 'Foto Piring Nutrisi',
                    icon: Icons.restaurant,
                    route: '/food-scanner',
                    color: const Color(0xFFFA6978),
                  ),
                if (_isMissing(data.missingModalities, 'Anemia Mata'))
                  _buildShortcutButton(
                    context,
                    label: 'Cek Anemia Kelopak',
                    icon: Icons.visibility,
                    route: '/deteksi-anemia',
                    color: const Color(0xFFE91E63),
                  ),
                if (_isMissing(data.missingModalities, 'Stunting'))
                  _buildShortcutButton(
                    context,
                    label: 'Skrining Stunting',
                    icon: Icons.child_care,
                    route: '/stunting',
                    color: const Color(0xFF9C27B0),
                  ),
                if (_isMissing(data.missingModalities, 'Tensi') ||
                    _isMissing(data.missingModalities, 'Komplikasi'))
                  _buildShortcutButton(
                    context,
                    label: 'Asesmen Vital & Gerak',
                    icon: Icons.directions_run,
                    route: '/rekomendasi-olahraga',
                    color: const Color(0xFFFF9800),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool _isMissing(List<String> missing, String keyword) {
    return missing.any((m) => m.toLowerCase().contains(keyword.toLowerCase()));
  }

  Widget _buildShortcutButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.chevron_right, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}
