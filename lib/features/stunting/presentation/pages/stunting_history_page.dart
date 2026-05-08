import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

final stuntingHistoryProvider = FutureProvider<List<StuntingHistoryItem>>((
  ref,
) {
  final repository = ref.watch(stuntingRepositoryProvider);
  return repository.getHistory();
});

class StuntingHistoryPage extends ConsumerStatefulWidget {
  const StuntingHistoryPage({super.key});

  @override
  ConsumerState<StuntingHistoryPage> createState() =>
      _StuntingHistoryPageState();
}

class _StuntingHistoryPageState extends ConsumerState<StuntingHistoryPage> {
  bool _isLoadingDetail = false;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(stuntingHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        title: const Text(
          'Riwayat Skrining',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFF8F8FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1C1C1E), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          historyAsync.when(
            data: (history) {
              if (history.isEmpty) {
                return _buildEmptyState();
              }
              
              final total = history.length;
              final highRiskCount = history.where((item) => item.riskLabel == 'high_risk').length;
              final lowRiskCount = total - highRiskCount;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildSummaryCard(total, highRiskCount, lowRiskCount),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 12, top: 16),
                      child: Text(
                        'Riwayat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 100),
                    sliver: SliverList.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return _buildHistoryCard(context, history[index]);
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => _buildLoadingState(),
            error: (err, stack) =>
                Center(child: Text('Gagal memuat riwayat: $err', style: const TextStyle(color: Color(0xFF1C1C1E)))),
          ),
          if (_isLoadingDetail)
            Container(
              color: Colors.black.withValues(alpha: 0.15),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF5A7A)),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  _buildMenuOption(
                    context,
                    icon: Icons.calendar_month_rounded,
                    title: 'Riwayat Meal Plan',
                    subtitle:
                        'Lihat meal plan aktif dan histori progres nutrisi',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/stunting-food/meal-plan/history');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuOption(
                    context,
                    icon: Icons.menu_book_rounded,
                    title: 'Resep',
                    subtitle: 'Eksplor resep dan bahan makanan bergizi',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/stunting-food/recipes');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuOption(
                    context,
                    icon: Icons.add_chart_rounded,
                    title: 'Skrining Risiko Baru',
                    subtitle: 'Lakukan analisis potensi risiko stunting anak',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/stunting/screening');
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFFFF5A7A),
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
        label: const Text(
          'Tambah Skrining',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int total, int high, int low) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black .withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildSummaryItem('Total Skrining', total.toString(), const Color(0xFF1C1C1E))),
          Container(width: 1, height: 40, color: const Color(0xFFE5E5EA)),
          Expanded(child: _buildSummaryItem('Risiko Tinggi', high.toString(), const Color(0xFFFF375F))),
          Container(width: 1, height: 40, color: const Color(0xFFE5E5EA)),
          Expanded(child: _buildSummaryItem('Risiko Rendah', low.toString(), const Color(0xFF34C759))),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6E6E73),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E5EA)),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF5A7A), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6E6E73), 
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFC7C7CC)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black .withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.history_rounded, size: 48, color: Color(0xFFC7C7CC)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada riwayat skrining',
            style: TextStyle(
              color: Color(0xFF6E6E73), 
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('/stunting/screening'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A7A),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
            child: const Text(
              'Mulai Skrining Pertama',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: const Color(0xFFF2F2F7),
        highlightColor: Colors.white,
        child: Container(
          height: 96,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, StuntingHistoryItem item) {
    final isHighRisk = item.riskLabel == 'high_risk';
    final date = (DateTime.tryParse(item.createdAt) ?? DateTime.now()).toLocal();
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);
    
    final Color statusColor = isHighRisk ? const Color(0xFFFF375F) : const Color(0xFF34C759);

    final IconData statusIcon = isHighRisk ? Icons.warning_rounded : Icons.check_circle_rounded;
    final String statusText = isHighRisk ? 'Risiko Tinggi' : 'Risiko Rendah';

    return GestureDetector(
      onTap: () => _handleCardTap(item.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black .withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Probabilitas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6E6E73),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(item.probability * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6E6E73),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFFD1D1D6),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCardTap(int id) async {
    setState(() => _isLoadingDetail = true);
    try {
      final repository = ref.read(stuntingRepositoryProvider);
      final detail = await repository.getHistoryDetail(id);
      if (mounted) {
        setState(() => _isLoadingDetail = false);
        context.push('/stunting/result', extra: detail);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingDetail = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat detail: $e')));
      }
    }
  }
}
