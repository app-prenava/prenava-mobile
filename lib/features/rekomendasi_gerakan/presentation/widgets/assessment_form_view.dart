import 'package:flutter/material.dart';
import '../../domain/entities/sport_recommendation.dart';

class AssessmentFormView extends StatefulWidget {
  final Function(SportAssessmentPayload) onSubmit;
  final bool isSubmitting;
  final bool showUpdateBanner;
  final String? errorMessage;
  final ScrollController? scrollController;

  const AssessmentFormView({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
    this.showUpdateBanner = false,
    this.errorMessage,
    this.scrollController,
  });

  @override
  State<AssessmentFormView> createState() => _AssessmentFormViewState();
}

class _AssessmentFormViewState extends State<AssessmentFormView> {
  static const _pink = Color(0xFFFA6978);

  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();

  int _currentStep = 0;

  // Step 1 fields
  bool _hypertension = false;
  bool _isDiabetes = false;
  bool _gestationalDiabetes = false;
  bool _isFever = false;
  bool _isHighHeartRate = false;

  // Step 2 fields
  bool _previousComplications = false;
  bool _mentalHealthIssue = false;
  bool _placentaPositionRestriction = false;
  bool _lowImpactPref = false;
  bool _waterAccess = false;
  bool _backPain = false;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) return;
      setState(() => _currentStep = 1);
    }
  }

  void _goToPreviousStep() {
    if (_currentStep == 1) {
      setState(() => _currentStep = 0);
    }
  }

  void _onSubmit() {
    final age = double.tryParse(_ageController.text);
    if (age == null) return;

    final payload = SportAssessmentPayload(
      bmi: age,
      hypertension: _hypertension,
      isDiabetes: _isDiabetes,
      gestationalDiabetes: _gestationalDiabetes,
      isFever: _isFever,
      isHighHeartRate: _isHighHeartRate,
      previousComplications: _previousComplications,
      mentalHealthIssue: _mentalHealthIssue,
      lowImpactPref: _lowImpactPref,
      waterAccess: _waterAccess,
      backPain: _backPain,
      placentaPositionRestriction: _placentaPositionRestriction,
    );
    widget.onSubmit(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag handle
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 4),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Scrollable form content
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showUpdateBanner) ...[
                    _buildUpdateBanner(),
                    const SizedBox(height: 12),
                  ],
                  if (widget.errorMessage != null) ...[
                    _buildErrorBanner(),
                    const SizedBox(height: 12),
                  ],
                  const Text(
                    'Olahraga yang Tepat Dimulai dari Kamu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lengkapi informasi kondisi tubuh dan kehamilanmu agar rekomendasi olahraga lebih personal, aman, dan sesuai kebutuhanmu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_currentStep == 0) _buildStep1Fields(),
                  if (_currentStep == 1) _buildStep2Fields(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        // Bottom buttons pinned
        _buildBottomButtons(),
      ],
    );
  }

  // ───────────────────── Step 1 ─────────────────────

  Widget _buildStep1Fields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Usia'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Usia saya saat ini',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _pink, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Usia tidak boleh kosong';
            final age = double.tryParse(value);
            if (age == null || age <= 0 || age > 100) return 'Masukkan usia yang valid';
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildDropdownField(
          label: 'Riwayat Hipertensi',
          value: _hypertension,
          onChanged: (v) => setState(() => _hypertension = v),
        ),
        _buildDropdownField(
          label: 'Diabetes',
          value: _isDiabetes,
          onChanged: (v) => setState(() => _isDiabetes = v),
        ),
        _buildDropdownField(
          label: 'Diabetes saat kehamilan',
          value: _gestationalDiabetes,
          onChanged: (v) => setState(() => _gestationalDiabetes = v),
        ),
        _buildDropdownField(
          label: 'Sering demam',
          value: _isFever,
          onChanged: (v) => setState(() => _isFever = v),
        ),
        _buildDropdownField(
          label: 'Detak Jantung Tinggi',
          value: _isHighHeartRate,
          onChanged: (v) => setState(() => _isHighHeartRate = v),
        ),
      ],
    );
  }

  // ───────────────────── Step 2 ─────────────────────

  Widget _buildStep2Fields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Riwayat Komplikasi Kehamilan',
          value: _previousComplications,
          onChanged: (v) => setState(() => _previousComplications = v),
        ),
        _buildDropdownField(
          label: 'Gangguan kesehatan mental (cemas, depresi, dll)',
          value: _mentalHealthIssue,
          onChanged: (v) => setState(() => _mentalHealthIssue = v),
        ),
        _buildDropdownField(
          label: 'Pembatasan Posisi Plasenta',
          value: _placentaPositionRestriction,
          onChanged: (v) => setState(() => _placentaPositionRestriction = v),
        ),
        _buildDropdownField(
          label: 'Preferensi Olahraga Ringan',
          value: _lowImpactPref,
          onChanged: (v) => setState(() => _lowImpactPref = v),
        ),
        _buildDropdownField(
          label: 'Akses ke air untuk olahraga (misalnya berenang)',
          value: _waterAccess,
          onChanged: (v) => setState(() => _waterAccess = v),
        ),
        _buildDropdownField(
          label: 'Nyeri Punggung',
          value: _backPain,
          onChanged: (v) => setState(() => _backPain = v),
        ),
      ],
    );
  }

  // ───────────────────── Shared Widgets ─────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF555555),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 6),
          DropdownButtonFormField<bool>(
            initialValue: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _pink, width: 1.5),
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF999999)),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(
                value: false,
                child: Text('Tidak', style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
              ),
              DropdownMenuItem(
                value: true,
                child: Text('Ya', style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
              ),
            ],
            onChanged: widget.isSubmitting ? null : (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────── Bottom Buttons ─────────────────────

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: widget.isSubmitting
                  ? null
                  : () {
                      if (_currentStep == 0) {
                        Navigator.of(context).pop();
                      } else {
                        _goToPreviousStep();
                      }
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: _pink,
                side: const BorderSide(color: _pink),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Text(
                _currentStep == 0 ? 'Nanti' : 'Kembali',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: widget.isSubmitting
                    ? null
                    : () {
                        if (_currentStep == 0) {
                          _goToNextStep();
                        } else {
                          _onSubmit();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: widget.isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        _currentStep == 0 ? 'Selanjutnya' : 'Simpan data',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────── Banners ─────────────────────

  Widget _buildUpdateBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB74D)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFFF57C00), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Data Anda sudah lebih dari 30 hari. Silakan isi ulang penilaian untuk mendapatkan rekomendasi terbaru.',
              style: TextStyle(fontSize: 13, color: Color(0xFFF57C00)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF5350)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF5350), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(fontSize: 13, color: Color(0xFFEF5350)),
            ),
          ),
        ],
      ),
    );
  }
}
