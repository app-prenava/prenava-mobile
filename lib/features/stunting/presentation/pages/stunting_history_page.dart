import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prenava_mobile/core/theme/app_theme.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

final stuntingHistoryProvider = FutureProvider<List<StuntingHistoryItem>>((ref) {
  final repository = ref.watch(stuntingRepositoryProvider);
  return repository.getHistory();
});

class StuntingHistoryPage extends ConsumerStatefulWidget {
  const StuntingHistoryPage({super.key});

  @override
  ConsumerState<StuntingHistoryPage> createState() => _StuntingHistoryPageState();
}

class _StuntingHistoryPageState extends ConsumerState<StuntingHistoryPage> {
  bool _isLoadingDetail = false;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(stuntingHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Riwayat Skrining'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          historyAsync.when(
            data: (history) {
              if (history.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return _buildHistoryCard(context, item);
                },
              );
            },
            loading: () => _buildLoadingState(),
            error: (err, stack) => Center(child: Text('Gagal memuat riwayat: $err')),
          ),
          if (_isLoadingDetail)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
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
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                  _buildMenuOption(
                    context,
                    icon: Icons.restaurant_menu_rounded,
                    title: 'Katalog Makanan Bergizi',
                    subtitle: 'Lihat daftar makanan sehat untuk cegah stunting',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/stunting/foods');
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
        backgroundColor: AppColors.primaryPink,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryPink),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
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
          Icon(Icons.history_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat skrining',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('/stunting/screening'),
            child: const Text('Mulai Skrining Pertama'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, StuntingHistoryItem item) {
    final isHighRisk = item.riskLabel == 'high_risk';
    final date = (DateTime.tryParse(item.createdAt) ?? DateTime.now()).toLocal();
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          isHighRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          color: isHighRisk ? AppColors.warningRed : AppColors.successGreen,
          size: 32,
        ),
        title: Text(
          isHighRisk ? 'Risiko Tinggi' : 'Risiko Rendah',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Probabilitas: ${(item.probability * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 4),
            Text(formattedDate, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _handleCardTap(item.id),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat detail: $e')),
        );
      }
    }
  }
}
