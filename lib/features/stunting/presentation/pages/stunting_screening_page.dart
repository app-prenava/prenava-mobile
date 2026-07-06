import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:dio/dio.dart';

class StuntingScreeningPage extends ConsumerStatefulWidget {
  const StuntingScreeningPage({super.key});

  @override
  ConsumerState<StuntingScreeningPage> createState() => _StuntingScreeningPageState();
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
          errorMsg = data['message'] ?? errorMsg;
          
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
      appBar: AppBar(title: const Text('Skrining Stunting')),
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
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  _answers[q.key] = double.tryParse(val);
                },
              ),
            );
          } else if (q.type == 'select') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<dynamic>(
                decoration: InputDecoration(
                  labelText: q.label,
                  border: const OutlineInputBorder(),
                ),
                items: q.options?.map((opt) {
                  return DropdownMenuItem(
                    value: opt.value,
                    child: Text(opt.label),
                  );
                }).toList() ?? [],
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
