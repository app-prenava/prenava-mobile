import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';

class StuntingResultPage extends ConsumerStatefulWidget {
  final PredictionResult result;
  final Map<String, dynamic>? answers;

  const StuntingResultPage({super.key, required this.result, this.answers});

  @override
  ConsumerState<StuntingResultPage> createState() => _StuntingResultPageState();
}

class _StuntingResultPageState extends ConsumerState<StuntingResultPage> {
  String _durasi = 'sehari';
  final _pantanganController = TextEditingController();

  void _showMealPlanDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personalisasi Menu Makanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _durasi,
                    decoration: const InputDecoration(
                      labelText: 'Durasi Menu',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sehari', child: Text('1 Hari')),
                      DropdownMenuItem(
                          value: 'seminggu', child: Text('1 Minggu')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => _durasi = val);
                        setState(() => _durasi = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pantanganController,
                    decoration: const InputDecoration(
                      labelText: 'Pantangan / Alergi (Opsional)',
                      hintText: 'Contoh: Alergi udang, tidak suka pedas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _generateMealPlan();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Buat Menu Makanan'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _generateMealPlan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repository = ref.read(stuntingRepositoryProvider);

      final height = widget.answers?['mother_height'] ?? 160.0;
      final weight = widget.answers?['mother_weight'] ?? 60.0;
      final heightM = height / 100.0;
      final bmi = weight / (heightM * heightM);

      final payload = {
        'risiko_stunting': widget.result.riskLabel,
        'bmi_ibu': bmi,
        'berat_badan': weight,
        'tinggi_badan': height,
        'hb': widget.answers?['maternal_hemoglobin'],
        'durasi': _durasi,
        'pantangan': _pantanganController.text,
        'prediction_id': widget.result.predictionId,
      };

      final response = await repository.generateMealPlan(payload);

      if (mounted) {
        Navigator.pop(context); // close loading
        context.push('/stunting/meal-plan', extra: response);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // close loading
        String errorMsg = e.toString();
        if (e is DioException && e.response?.data != null) {
          final data = e.response!.data;
          if (data is Map && data['message'] != null) {
            errorMsg = data['message'];
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat menu: $errorMsg')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTinggi = widget.result.riskLevel == 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/stunting/history');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hasil Analisis'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/stunting/history');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              Text(
                'Skor Risiko: ${(widget.result.score * 100).toStringAsFixed(1)}%',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                widget.result.riskLabel,
                style: TextStyle(
                  color: isTinggi ? Colors.red : Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.result.recommendation,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              if (widget.result.localOnly) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mode Pengujian Lokal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status model: ${widget.result.modelStatus ?? 'belum tervalidasi'}. '
                        'Hasil tidak disimpan ke riwayat dan tidak boleh digunakan sebagai diagnosis.',
                      ),
                      if (widget.result.ageBand != null &&
                          widget.result.threshold != null)
                        Text(
                          'Kelompok usia ${widget.result.ageBand} bulan · '
                          'threshold ${widget.result.threshold!.toStringAsFixed(3)}',
                        ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: widget.result.localOnly ? null : _showMealPlanDialog,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.result.localOnly
                      ? 'Meal Plan Nonaktif pada Mode Lokal'
                      : 'Lihat Rekomendasi Makanan',
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
