import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/health_history_providers.dart';
import '../../domain/entities/health_history.dart';

class HealthHistoryPage extends ConsumerStatefulWidget {
  const HealthHistoryPage({super.key});

  @override
  ConsumerState<HealthHistoryPage> createState() => _HealthHistoryPageState();
}

class _HealthHistoryPageState extends ConsumerState<HealthHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(healthHistoryNotifierProvider.notifier).fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFA6978), size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Riwayat Kesehatan',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: state.isLoading && state.history.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFA6978)))
          : state.error != null && state.history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Gagal memuat riwayat', style: TextStyle(color: Colors.grey[600])),
                      TextButton(
                        onPressed: () => ref.read(healthHistoryNotifierProvider.notifier).fetchHistory(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : state.history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada riwayat pemindaian',
                            style: TextStyle(color: Colors.grey[500], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(healthHistoryNotifierProvider.notifier).fetchHistory(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.history.length,
                        itemBuilder: (context, index) {
                          final item = state.history[index];
                          return _HistoryCard(item: item);
                        },
                      ),
                    ),
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  final HealthHistory item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnemia = item.type == 'anemia';
    final date = DateFormat('dd MMM yyyy, HH:mm').format(item.createdAt);
    
    // Extract results safely
    String summary = '';
    Color resultColor = Colors.grey;
    
    if (isAnemia) {
      summary = item.result['prediction'] ?? 'Tidak diketahui';
      resultColor = summary.toLowerCase().contains('anemia') && !summary.toLowerCase().contains('non')
          ? const Color(0xFFE53E3E)
          : const Color(0xFF48BB78);
    } else {
      summary = item.result['prediction'] ?? 'Tidak diketahui';
      // Basic heuristic for depression results
      resultColor = summary.toLowerCase().contains('depressed') || summary.toLowerCase().contains('stres')
          ? const Color(0xFFE53E3E)
          : const Color(0xFF48BB78);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (isAnemia ? Colors.red : Colors.blue).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isAnemia ? Icons.remove_red_eye_rounded : Icons.face_rounded,
            color: isAnemia ? Colors.red : Colors.blue,
            size: 24,
          ),
        ),
        title: Text(
          isAnemia ? 'Deteksi Anemia' : 'Deteksi Depresi',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: resultColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                summary,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded, color: Colors.grey[400], size: 20),
          onPressed: () {
            _showDeleteConfirmation(context, ref);
          },
        ),
        onTap: () {
          // Future: Navigate to result detail
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Riwayat?'),
        content: const Text('Data ini akan dihapus permanen dari riwayat Anda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(healthHistoryNotifierProvider.notifier).deleteHistory(item.id);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
