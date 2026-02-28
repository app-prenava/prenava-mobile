import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/pregnancy_providers.dart';
import '../widgets/pregnancy_widgets.dart';

class PregnancyCalculatorPage extends ConsumerStatefulWidget {
  const PregnancyCalculatorPage({super.key});

  @override
  ConsumerState<PregnancyCalculatorPage> createState() =>
      _PregnancyCalculatorPageState();
}

class _PregnancyCalculatorPageState
    extends ConsumerState<PregnancyCalculatorPage> {
  final TextEditingController _hphtController = TextEditingController();
  final TextEditingController _babyNameController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Load existing pregnancy data if any
    Future.microtask(() {
      ref.read(pregnancyNotifierProvider.notifier).loadMyPregnancy();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Populate baby name and gender fields when pregnancy data loads
    final pregnancy = ref.read(pregnancyNotifierProvider).pregnancy;
    if (pregnancy != null) {
      if (pregnancy.babyName != null && _babyNameController.text.isEmpty) {
        _babyNameController.text = pregnancy.babyName!;
      }
      if (pregnancy.babyGender != null && _selectedGender == null) {
        _selectedGender = pregnancy.babyGender;
      }
    }
  }

  @override
  void dispose() {
    _hphtController.dispose();
    _babyNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 280)),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
      helpText: 'Pilih Tanggal HPHT',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      fieldLabelText: 'Tanggal Hari Pertama Haid Terakhir',
    );

    if (picked != null) {
      _hphtController.text = DateFormat('yyyy-MM-dd').format(picked);
      // Calculate immediately when date is selected
      _calculatePregnancy(picked);
    }
  }

  Future<void> _calculatePregnancy(DateTime hpht) async {
    final hphtString = DateFormat('yyyy-MM-dd').format(hpht);
    await ref
        .read(pregnancyNotifierProvider.notifier)
        .calculatePregnancy(hpht: hphtString);
  }

  Future<void> _savePregnancy() async {
    if (_hphtController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal HPHT terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await ref
        .read(pregnancyNotifierProvider.notifier)
        .savePregnancy(
          hpht: _hphtController.text,
          babyName: _babyNameController.text.isNotEmpty ? _babyNameController.text : null,
          babyGender: _selectedGender,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Data kehamilan berhasil disimpan'
              : ref.read(pregnancyNotifierProvider).error ?? 'Gagal menyimpan data',
        ),
        backgroundColor: success ? const Color(0xFF4CAF50) : Colors.red,
      ),
    );
  }

  void _resetCalculator() {
    _hphtController.clear();
    _babyNameController.clear();
    _selectedGender = null;
    ref.read(pregnancyNotifierProvider.notifier).clearMessages();
  }

  Widget _buildInputForm(PregnancyState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Hitung HPL',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFA6978),
            ),
          ),
          const SizedBox(height: 24),

          // HPHT Input
          _buildHphtField(),
          const SizedBox(height: 20),

          // Baby Name Input
          _buildBabyNameField(),
          const SizedBox(height: 20),

          // Gender Selection
          _buildGenderSelection(),
          const SizedBox(height: 24),

          // Calculate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _hphtController.text.isEmpty
                  ? null
                  : () => _calculatePregnancy(DateTime.parse(_hphtController.text)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA6978),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: state.isCalculating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate),
                        SizedBox(width: 8),
                        Text(
                          'Hitung Kehamilan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHphtField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal HPHT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/calendar.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.calendar_today, size: 24);
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _hphtController.text.isNotEmpty
                        ? DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(DateTime.parse(_hphtController.text))
                        : 'Pilih tanggal HPHT',
                    style: TextStyle(
                      fontSize: 15,
                      color: _hphtController.text.isNotEmpty
                          ? Colors.black87
                          : Colors.grey[400],
                      fontWeight: _hphtController.text.isNotEmpty
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (_hphtController.text.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _resetCalculator,
                    child: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBabyNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nama Bayi (Opsional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _babyNameController,
          decoration: InputDecoration(
            hintText: 'Masukkan nama bayi',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.baby_changing_station, color: Color(0xFFFA6978)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFA6978), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin Bayi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Male Option
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedGender = 'L'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedGender == 'L'
                        ? const Color(0xFFFA6978).withValues(alpha: 0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: _selectedGender == 'L'
                          ? const Color(0xFFFA6978)
                          : Colors.grey[300]!,
                      width: _selectedGender == 'L' ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/laki.png',
                        width: 48,
                        height: 48,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.male, size: 48, color: Color(0xFF2196F3));
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Laki-laki',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _selectedGender == 'L'
                              ? const Color(0xFFFA6978)
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Female Option
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedGender = 'P'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedGender == 'P'
                        ? const Color(0xFFFA6978).withValues(alpha: 0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: _selectedGender == 'P'
                          ? const Color(0xFFFA6978)
                          : Colors.grey[300]!,
                      width: _selectedGender == 'P' ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/perempuan.png',
                        width: 48,
                        height: 48,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.female, size: 48, color: Color(0xFFE91E63));
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Perempuan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _selectedGender == 'P'
                              ? const Color(0xFFFA6978)
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pregnancyState = ref.watch(pregnancyNotifierProvider);

    ref.listen<PregnancyState>(pregnancyNotifierProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        ref.read(pregnancyNotifierProvider.notifier).clearMessages();
      }
      if (next.error != null && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final pregnancy = pregnancyState.pregnancy;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Kalkulator Kehamilan'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Form Section
            _buildInputForm(pregnancyState),

            if (pregnancy != null) ...[
              const SizedBox(height: 24),

              // HPL Card
              HPLCard(
                hplFormatted: pregnancy.hplFormatted,
                pregnancy: pregnancy,
              ),

              const SizedBox(height: 20),

              // Age Display
              PregnancyAgeDisplay(age: pregnancy.usiaKehamilan),

              const SizedBox(height: 20),

              // Fetal Size Widget (if fetal size data is available)
              if (pregnancy.fetalSize != null)
                FetalSizeWidget(
                  fetalSize: pregnancy.fetalSize!,
                  currentWeek: pregnancy.usiaKehamilan.minggu,
                ),

              if (pregnancy.fetalSize != null) const SizedBox(height: 20),

              // Progress Bar
              PregnancyProgressBar(
                progress: pregnancy.progressPercentage,
                currentAge: pregnancy.usiaKehamilan.teks,
                trimester: pregnancy.trimesterName,
              ),

              const SizedBox(height: 20),

              // Countdown Widget
              PregnancyCountdownWidget(countdownData: pregnancy.countdown),

              const SizedBox(height: 20),

              // Status Indicator
              PregnancyStatusIndicator(
                status: pregnancy.status,
                statusDescription: pregnancy.statusDescription,
              ),

              const SizedBox(height: 24),

              // Save Button (if not saved yet)
              if (pregnancyState.pregnancy?.hpht == _hphtController.text)
                _buildUpdateButton(pregnancyState)
              else
                _buildSaveButton(pregnancyState),
            ],
            if (!pregnancyState.isLoading && !pregnancyState.isCalculating && pregnancyState.pregnancy == null) ...[
              const SizedBox(height: 32),
              _buildEmptyState(),
            ],

            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildHphtInput(PregnancyState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: Color(0xFFFA6978),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal HPHT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hari Pertama Haid Terakhir',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event,
                    color: _hphtController.text.isNotEmpty
                        ? const Color(0xFFFA6978)
                        : Colors.grey[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _hphtController.text.isNotEmpty
                          ? DateFormat('dd MMMM yyyy', 'id_ID')
                              .format(DateTime.parse(_hphtController.text))
                          : 'Pilih tanggal',
                      style: TextStyle(
                        fontSize: 15,
                        color: _hphtController.text.isNotEmpty
                            ? Colors.black87
                            : Colors.grey[400],
                        fontWeight: _hphtController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (_hphtController.text.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _resetCalculator,
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (state.error != null && !state.isLoading) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton(PregnancyState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isSaving ? null : _savePregnancy,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFA6978),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: state.isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 8),
                  Text(
                    'Simpan Data Kehamilan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildUpdateButton(PregnancyState state) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: state.isSaving ? null : _savePregnancy,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFA6978),
          side: const BorderSide(color: Color(0xFFFA6978), width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.update),
                  SizedBox(width: 8),
                  Text(
                    'Update Data Kehamilan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Data Kehamilan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih tanggal HPHT untuk menghitung hari perkiraan lahir',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
