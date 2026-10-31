import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:dio/dio.dart';

class StuntingScreeningPage extends ConsumerStatefulWidget {
  const StuntingScreeningPage({super.key});

  @override
  ConsumerState<StuntingScreeningPage> createState() =>
      _StuntingScreeningPageState();
}

class _StuntingScreeningPageState extends ConsumerState<StuntingScreeningPage> {
  List<StuntingQuestion> _questions = [];
  final Map<String, dynamic> _answers = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _fetchQuestions() async {
    try {
      final dataSource = ref.read(stuntingRepositoryProvider);
      final questions = await dataSource.getQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _submit() async {
    final missingRequired = _questions
        .where(
            (question) => question.isRequired && _answers[question.key] == null)
        .map((question) => question.label)
        .toList();
    if (missingRequired.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lengkapi data wajib: ${missingRequired.join(', ')}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final dataSource = ref.read(stuntingRepositoryProvider);
      final result = await dataSource.submitPrediction(_answers);
      if (mounted) {
        Navigator.pop(context); // Tutup loading
        context.push('/stunting/result', extra: {
          'result': result,
          'answers': _answers,
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        Navigator.pop(context); // Tutup loading
        String errorMsg = 'Terjadi kesalahan koneksi.';

        if (e.response?.data != null && e.response?.data is Map) {
          final data = e.response!.data as Map<String, dynamic>;
          errorMsg = data['message']?.toString() ?? errorMsg;

          if (data['detail'] is List && (data['detail'] as List).isNotEmpty) {
            final first = (data['detail'] as List).first;
            if (first is Map && first['msg'] != null) {
              errorMsg = first['msg'].toString();
            }
          }

          if (e.response?.statusCode == 422 && data['errors'] != null) {
            final errors = data['errors'] as Map<String, dynamic>;
            if (errors.isNotEmpty) {
              // Ambil pesan error validasi pertama
              errorMsg = errors.values.first[0].toString();
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Tutup loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String? _getHelperText(String key, String? unit) {
    switch (key) {
      case 'mother_height':
        return 'Contoh: 160 (dalam cm)';
      case 'child_weight_kg':
        return 'Wajib diukur saat ini, contoh: 9.5 kg';
      case 'age_in_months':
        return 'Usia anak 0-59 bulan';
      case 'mother_weight':
        return 'Contoh: 65 (dalam kg)';
      case 'maternal_hemoglobin':
        return 'Kadar Hb, contoh: 12.5 (g/dL)';
      case 'mother_age':
        return 'Usia saat ini, contoh: 25 (tahun)';
      case 'mother_education':
        return 'Pilih jenjang pendidikan terakhir ibu';
      case 'anc_visits_total':
        return 'Total pemeriksaan kehamilan (ANC)';
      case 'iron_pills':
        return 'Rutin mengonsumsi Tablet Tambah Darah (TTD)?';
      case 'pregnancy_sickness':
        return 'Apakah mengalami infeksi/sakit berat saat hamil?';
      default:
        return unit != null ? 'Dalam $unit' : null;
    }
  }

  void _showTutorialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(child: Text('Panduan Pengisian')),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Isilah data sesuai dengan buku KIA atau hasil pemeriksaan terakhir Anda.',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('• Tinggi Ibu: Tinggi badan ibu (contoh: 160 cm).'),
                Text(
                    '• Berat Badan Ibu: Berat badan saat ini (contoh: 65 kg).'),
                Text(
                    '• Hemoglobin Ibu: Kadar Hb dari tes darah (normal > 11 g/dL).'),
                Text('• Usia Ibu: Usia saat ini.'),
                Text(
                    '• Pendidikan Ibu: Lama sekolah (SD=6, SMP=9, SMA=12, S1=16 tahun).'),
                Text(
                    '• Total Kunjungan ANC: Jumlah periksa ke bidan/dokter selama hamil.'),
                Text(
                    '• Konsumsi Pil Besi: Apakah rutin minum pil penambah darah.'),
                Text(
                    '• Sakit Selama Kehamilan: Apakah mengalami penyakit seperti infeksi atau hipertensi saat hamil.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Skrining Stunting')),
        body: Center(child: Text('Error: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skrining Stunting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Panduan Pengisian',
            onPressed: () => _showTutorialDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final q = _questions[index];

          if (q.type == 'number') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: q.label,
                  suffixText: q.isRequired ? 'Wajib' : null,
                  helperText: _getHelperText(q.key, q.unit),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final trimmed = val.trim();
                  _answers[q.key] = double.tryParse(trimmed) ?? trimmed;
                },
              ),
            );
          } else if (q.type == 'select') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<dynamic>(
                decoration: InputDecoration(
                  labelText: q.label,
                  suffixText: q.isRequired ? 'Wajib' : null,
                  helperText: _getHelperText(q.key, q.unit),
                  border: const OutlineInputBorder(),
                ),
                items: q.options?.map((opt) {
                      return DropdownMenuItem(
                        value: opt.value,
                        child: Text(opt.label),
                      );
                    }).toList() ??
                    [],
                onChanged: (val) {
                  _answers[q.key] = val;
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Kirim Data'),
        ),
      ),
    );
  }
}
