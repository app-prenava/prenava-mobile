import 'package:flutter/material.dart';
import '../../domain/entities/pregnancy.dart';

/// Progress bar untuk menampilkan usia kehamilan
class PregnancyProgressBar extends StatelessWidget {
  final double progress;
  final String currentAge;
  final String trimester;

  const PregnancyProgressBar({
    super.key,
    required this.progress,
    required this.currentAge,
    required this.trimester,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Usia Kehamilan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              currentAge,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFA6978),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress / 100,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B9D), Color(0xFFFA6978)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFA6978).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                trimester,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFA6978),
                ),
              ),
            ),
            Text(
              '${progress.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Badge untuk menampilkan trimester
class TrimesterBadge extends StatelessWidget {
  final int trimester;
  final String trimesterName;

  const TrimesterBadge({
    super.key,
    required this.trimester,
    required this.trimesterName,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;

    switch (trimester) {
      case 1:
        badgeColor = const Color(0xFF4CAF50);
        badgeText = 'Trim 1';
        break;
      case 2:
        badgeColor = const Color(0xFFFF9800);
        badgeText = 'Trim 2';
        break;
      case 3:
        badgeColor = const Color(0xFFE91E63);
        badgeText = 'Trim 3';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = 'Trim ?';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Countdown timer ke HPL
class PregnancyCountdownWidget extends StatelessWidget {
  final PregnancyCountdown countdownData;

  const PregnancyCountdownWidget({
    super.key,
    required this.countdownData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFA6978).withOpacity(0.1),
            const Color(0xFFFF6B9D).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFA6978).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFA6978).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Color(0xFFFA6978),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menuju Hari Perkiraan Lahir',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  countdownData.teks,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFA6978),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${countdownData.mingguSampaiHpl}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFA6978),
                  ),
                ),
                Text(
                  'Minggu',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Status indicator dengan warna
class PregnancyStatusIndicator extends StatelessWidget {
  final String status;
  final String statusDescription;

  const PregnancyStatusIndicator({
    super.key,
    required this.status,
    required this.statusDescription,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'normal':
        return const Color(0xFF4CAF50);
      case 'approaching':
        return const Color(0xFFFF9800);
      case 'overdue':
        return const Color(0xFFF44336);
      case 'critical':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'normal':
        return Icons.check_circle;
      case 'approaching':
        return Icons.warning;
      case 'overdue':
        return Icons.error;
      case 'critical':
        return Icons.dangerous;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final icon = _getStatusIcon();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusDescription,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case 'normal':
        return 'Kondisi kehamilan baik';
      case 'approaching':
        return 'Persiapkan persalinan';
      case 'overdue':
        return 'Segera hubungi dokter';
      case 'critical':
        return 'Butuh perhatian medis';
      default:
        return '';
    }
  }
}

/// HPL Card - Card besar untuk menampilkan HPL
class HPLCard extends StatelessWidget {
  final String hplFormatted;
  final Pregnancy pregnancy;

  const HPLCard({
    super.key,
    required this.hplFormatted,
    required this.pregnancy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFA6978), Color(0xFFFF6B9D)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFA6978).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hari Perkiraan Lahir',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hplFormatted,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'HPHT',
                  pregnancy.hphtFormatted,
                  Icons.event,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Usia',
                  pregnancy.usiaKehamilan.teks,
                  Icons.timer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white.withOpacity(0.9)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Display usia kehamilan dengan styling
class PregnancyAgeDisplay extends StatelessWidget {
  final PregnancyAge age;

  const PregnancyAgeDisplay({
    super.key,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAgeItem(
            age.minggu.toString(),
            'Minggu',
            Icons.calendar_view_week,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildAgeItem(
            age.hari.toString(),
            'Hari',
            Icons.calendar_today,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildAgeItem(
            '${age.totalHari}',
            'Total Hari',
            Icons.timer_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAgeItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFA6978), size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFA6978),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// Fetal Size Widget - Menampilkan ukuran janin dengan perbandingan buah
class FetalSizeWidget extends StatelessWidget {
  final FetalSize fetalSize;
  final int currentWeek;

  const FetalSizeWidget({
    super.key,
    required this.fetalSize,
    required this.currentWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFA6978).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  fetalSize.fruitEmoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ukuran Janin',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fetalSize.namaIndo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFA6978),
                    ),
                  ),
                  Text(
                    'Minggu ke-$currentWeek',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSizeItem(
                'Berat',
                fetalSize.formattedBerat,
                Icons.line_weight,
              ),
              Container(
                height: 50,
                width: 1,
                color: Colors.grey[300],
              ),
              _buildSizeItem(
                'Panjang',
                fetalSize.formattedPanjang,
                Icons.straighten,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFA6978), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFA6978),
          ),
        ),
      ],
    );
  }
}
