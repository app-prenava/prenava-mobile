import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';

class StuntingHistoryDetailPage extends ConsumerStatefulWidget {
  final int historyId;

  const StuntingHistoryDetailPage({super.key, required this.historyId});

  @override
  ConsumerState<StuntingHistoryDetailPage> createState() =>
      _StuntingHistoryDetailPageState();
}

class _StuntingHistoryDetailPageState
    extends ConsumerState<StuntingHistoryDetailPage> {
  PredictionResult? _result;
  bool _isLoading = true;
  String? _error;

  String _durasi = 'sehari';
  final _pantanganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final repository = ref.read(stuntingRepositoryProvider);
      final result = await repository.getHistoryDetail(widget.historyId);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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

      final height = _result?.inputData?['mother_height'] ?? 160.0;
      final weight = _result?.inputData?['mother_weight'] ?? 60.0;
      final hb = _result?.inputData?['maternal_hemoglobin'];

      final heightM = height / 100.0;
      final bmi = weight / (heightM * heightM);

      final payload = {
        'risiko_stunting': _result!.riskLabel,
        'bmi_ibu': bmi,
        'berat_badan': weight,
        'tinggi_badan': height,
        'hb': hb,
        'durasi': _durasi,
        'pantangan': _pantanganController.text,
        'prediction_id': _result!.predictionId,
      };

      final response = await repository.generateMealPlan(payload);

      if (mounted) {
        Navigator.pop(context); // close loading

        // Refresh detail so we get the saved aiMealPlan
        _fetchDetail();

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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Riwayat')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Riwayat')),
        body: Center(child: Text(_error ?? 'Data tidak ditemukan')),
      );
    }

    final isTinggi = _result!.riskLevel == 1;
    final hasAiPlan = _result!.aiMealPlan != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Skor Risiko: ${(_result!.score * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _result!.riskLabel,
              style: TextStyle(
                color: isTinggi ? Colors.red : Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _result!.recommendation,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            if (hasAiPlan)
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/stunting/meal-plan',
                      extra: _result!.aiMealPlan!);
                },
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Lihat Menu Tersimpan'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                ),
              )
            else
              ElevatedButton(
                onPressed: _showMealPlanDialog,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Buat Menu Makanan'),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
