import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/visit.dart';
import '../providers/kunjungan_providers.dart';
import '../widgets/status_indicator.dart';

class VisitDetailPage extends ConsumerStatefulWidget {
  final int visitId;

  const VisitDetailPage({
    super.key,
    required this.visitId,
  });

  @override
  ConsumerState<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends ConsumerState<VisitDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load visit detail
    Future.microtask(() {
      ref.read(kunjunganNotifierProvider.notifier).loadVisitDetail(widget.visitId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kunjunganNotifierProvider);
    final visit = state.selectedVisit;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Kunjungan'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (visit != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/kunjungan/edit/${visit.id}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context, visit.id!),
            ),
          ],
        ],
      ),
      body: _buildBody(state, visit),
    );
  }

  Widget _buildBody(KunjunganState state, Visit? visit) {
    if (state.isLoading && visit == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFA6978)),
      );
    }

    if (visit == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              state.error ?? 'Kunjungan tidak ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and status card
          _buildDateStatusCard(visit),
          const SizedBox(height: 24),

          // Questions section
          _buildQuestionsSection(visit),
          const SizedBox(height: 24),

          // Midwife notes section
          if (visit.catatanBidan != null && visit.catatanBidan!.isNotEmpty)
            _buildMidwifeNotesSection(visit.catatanBidan!),
        ],
      ),
    );
  }

  Widget _buildDateStatusCard(Visit visit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFA6978), Color(0xFFF78C9B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFA6978).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                'Tanggal Kunjungan',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMMM yyyy', 'id_ID').format(visit.tanggalKunjungan),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                '${visit.answeredCount} dari ${visit.totalQuestions} pertanyaan dijawab',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          if (visit.status != null) ...[
            const SizedBox(height: 12),
            StatusIndicator(status: visit.status),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionsSection(Visit visit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jawaban Pertanyaan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 16),
        ...visit.pertanyaan.entries.map((entry) {
          return _buildQuestionItem(
            entry.value.label ?? entry.key,
            entry.value.jawaban,
          );
        }),
      ],
    );
  }

  Widget _buildQuestionItem(String label, bool? answer) {
    Color backgroundColor;
    Color borderColor;
    IconData icon;

    if (answer == null) {
      backgroundColor = Colors.grey[100]!;
      borderColor = Colors.grey[300]!;
      icon = Icons.help_outline;
    } else if (answer == true) {
      backgroundColor = const Color(0xFFFA6978).withValues(alpha: 0.1);
      borderColor = const Color(0xFFFA6978);
      icon = Icons.check_circle;
    } else {
      backgroundColor = const Color(0xFF4CAF50).withValues(alpha: 0.1);
      borderColor = const Color(0xFF4CAF50);
      icon = Icons.cancel;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: borderColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: answer == true ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (answer != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                answer == true ? 'Ya' : 'Tidak',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Tidak dijawab',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMidwifeNotesSection(String notes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB74D), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Catatan Bidan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notes,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int visitId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kunjungan'),
        content: const Text('Apakah Anda yakin ingin menghapus kunjungan ini?'),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              dialogContext.pop();
              final success = await ref
                  .read(kunjunganNotifierProvider.notifier)
                  .deleteVisit(visitId);

              if (!mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kunjungan berhasil dihapus'),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.pop();
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
