import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/kunjungan_providers.dart';
import '../widgets/question_checkbox.dart';

// GoRouter extension methods are available via import

class VisitFormPage extends ConsumerStatefulWidget {
  final int? visitId; // If provided, update existing visit

  const VisitFormPage({
    super.key,
    this.visitId,
  });

  @override
  ConsumerState<VisitFormPage> createState() => _VisitFormPageState();
}

class _VisitFormPageState extends ConsumerState<VisitFormPage> {
  final Map<String, bool?> _answers = {};
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.visitId != null) {
      // Load existing visit for editing
      _loadVisitForEdit();
    }
  }

  Future<void> _loadVisitForEdit() async {
    await ref.read(kunjunganNotifierProvider.notifier).loadVisitDetail(widget.visitId!);
    final visit = ref.read(kunjunganNotifierProvider).selectedVisit;
    if (visit != null) {
      setState(() {
        _selectedDate = visit.tanggalKunjungan;
        // Extract answers
        visit.pertanyaan.forEach((key, answer) {
          _answers[key] = answer.jawaban;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.read(kunjunganNotifierProvider.notifier).getQuestionsForForm();

    for (var question in questions.keys) {
      _answers.putIfAbsent(question, () => null);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.visitId == null ? 'Kunjungan Baru' : 'Edit Kunjungan'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            _buildDatePicker(),
            const SizedBox(height: 24),

            // Questions section
            const Text(
              'Pertanyaan Kesehatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jawab dengan jujur sesuai kondisi Anda',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Question checkboxes
            ...questions.entries.map((entry) {
              return QuestionCheckbox(
                key: ValueKey(entry.key),
                questionKey: entry.key,
                label: entry.value,
                value: _answers[entry.key] ?? false,
                onChanged: (value) {
                  setState(() {
                    _answers[entry.key] = value;
                  });
                },
              );
            }),

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: (_isSubmitting || _answers.isEmpty) ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.visitId == null ? 'Simpan Kunjungan' : 'Update Kunjungan',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFFFA6978)),
            const SizedBox(width: 12),
            Text(
              'Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Color(0xFFFA6978)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitForm() async {
    setState(() => _isSubmitting = true);

    bool success;
    if (widget.visitId == null) {
      success = await ref.read(kunjunganNotifierProvider.notifier).createVisit(
            tanggalKunjungan: _selectedDate,
            pertanyaan: _answers,
          );
    } else {
      success = await ref.read(kunjunganNotifierProvider.notifier).updateVisit(
            id: widget.visitId!,
            tanggalKunjungan: _selectedDate,
            pertanyaan: _answers,
          );
    }

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (success) {
      final message = widget.visitId == null
          ? 'Kunjungan berhasil ditambahkan'
          : 'Kunjungan berhasil diupdate';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );

      if (mounted) {
        context.go('/kunjungan');
      }
    } else {
      final error = ref.read(kunjunganNotifierProvider).error ?? 'Terjadi kesalahan';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    }
  }
}
