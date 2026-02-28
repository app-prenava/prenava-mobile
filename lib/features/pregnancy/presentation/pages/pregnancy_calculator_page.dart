import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/pregnancy.dart';
import '../providers/pregnancy_providers.dart';
import '../widgets/pregnancy_animated_widgets.dart';

class PregnancyCalculatorPage extends ConsumerStatefulWidget {
  const PregnancyCalculatorPage({super.key});

  @override
  ConsumerState<PregnancyCalculatorPage> createState() =>
      _PregnancyCalculatorPageState();
}

class _PregnancyCalculatorPageState extends ConsumerState<PregnancyCalculatorPage>
    with TickerProviderStateMixin {
  final TextEditingController _hphtController = TextEditingController();
  final TextEditingController _babyNameController = TextEditingController();
  String? _selectedGender;

  late AnimationController _staggeredController;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();
    _initAnimations();

    // Load existing pregnancy data if any
    Future.microtask(() {
      ref.read(pregnancyNotifierProvider.notifier).loadMyPregnancy();
    });
  }

  void _initAnimations() {
    _staggeredController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _staggeredAnimations = List.generate(6, (index) {
      final start = index * 0.15;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggeredController,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOutCubic),
        ),
      );
    });
  }

  void _triggerAnimations() {
    _staggeredController.reset();
    _staggeredController.forward();
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
      _triggerAnimations();
    }
  }

  @override
  void dispose() {
    _hphtController.dispose();
    _babyNameController.dispose();
    _staggeredController.dispose();
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFA6978),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFFFA6978),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _hphtController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      _calculatePregnancy(picked);
    }
  }

  Future<void> _calculatePregnancy(DateTime hpht) async {
    await ref
        .read(pregnancyNotifierProvider.notifier)
        .calculatePregnancy(hpht: DateFormat('yyyy-MM-dd').format(hpht));
    _triggerAnimations();
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _resetCalculator() {
    setState(() {
      _hphtController.clear();
      _babyNameController.clear();
      _selectedGender = null;
    });
    ref.read(pregnancyNotifierProvider.notifier).clearMessages();
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
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        ref.read(pregnancyNotifierProvider.notifier).clearMessages();
      }
      if (next.error != null && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });

    final pregnancy = pregnancyState.pregnancy;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Glass Effect
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFFA6978),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Kalkulator Kehamilan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFA6978),
                      const Color(0xFFFF6B9D).withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Form Card
                  _buildInputForm(pregnancyState),

                  if (pregnancy != null) ...[
                    const SizedBox(height: 24),

                    // HPL Card with Animation
                    _buildAnimatedHPLCard(pregnancy),

                    const SizedBox(height: 24),

                    // Bento Grid Layout
                    _buildBentoGrid(pregnancy),

                    const SizedBox(height: 20),

                    // Animated Progress Bar
                    AnimatedProgressBar(
                      progress: pregnancy.progressPercentage,
                      currentAge: pregnancy.usiaKehamilan.teks,
                      trimester: pregnancy.trimesterName,
                      animation: _staggeredAnimations[2],
                    ),

                    const SizedBox(height: 20),

                    // Countdown Widget with Glass Effect
                    _buildGlassCountdown(pregnancy),

                    const SizedBox(height: 20),

                    // Fetal Size Widget (if available)
                    if (pregnancy.fetalSize != null)
                      _buildAnimatedFetalSize(pregnancy),

                    if (pregnancy.fetalSize != null) const SizedBox(height: 20),

                    // Status Indicator
                    _buildGlassStatus(pregnancy),

                    const SizedBox(height: 100), // Space for sticky button
                  ],

                  // Empty State
                  if (!pregnancyState.isLoading &&
                      !pregnancyState.isCalculating &&
                      pregnancyState.pregnancy == null)
                    _buildEmptyState(),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Button at Bottom
      bottomNavigationBar: pregnancy != null
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: GlowingButton(
                text: 'Update Data Kehamilan',
                onPressed: _savePregnancy,
                isLoading: pregnancyState.isSaving,
                isOutlined: true,
              ),
            )
          : null,
    );
  }

  Widget _buildInputForm(PregnancyState state) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hitung HPL',
            style: TextStyle(
              fontSize: 22,
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
            height: 54,
            child: ElevatedButton(
              onPressed: _hphtController.text.isEmpty
                  ? null
                  : () => _calculatePregnancy(DateTime.parse(_hphtController.text)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA6978),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: state.isCalculating
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate, size: 22),
                        SizedBox(width: 10),
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
            color: Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/calendar.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.calendar_today, size: 20, color: Color(0xFFFA6978));
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _hphtController.text.isNotEmpty
                        ? DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(DateTime.parse(_hphtController.text))
                        : 'Pilih tanggal HPHT',
                    style: TextStyle(
                      fontSize: 15,
                      color: _hphtController.text.isNotEmpty
                          ? const Color(0xFF2C2C2C)
                          : Colors.grey[400],
                      fontWeight: _hphtController.text.isNotEmpty
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (_hphtController.text.isNotEmpty)
                  InkWell(
                    onTap: _resetCalculator,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.clear, color: Colors.grey[400], size: 18),
                    ),
                  ),
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
          'Nama Bayi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _babyNameController,
          decoration: InputDecoration(
            hintText: 'Masukkan nama bayi (opsional)',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.baby_changing_station,
                  color: Color(0xFFFA6978), size: 20),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFFA6978), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            color: Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedGender = 'L'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _selectedGender == 'L'
                        ? const Color(0xFF2196F3).withValues(alpha: 0.1)
                        : Colors.grey[50],
                    border: Border.all(
                      color: _selectedGender == 'L'
                          ? const Color(0xFF2196F3)
                          : Colors.grey[200]!,
                      width: _selectedGender == 'L' ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      if (_selectedGender == 'L')
                        const FloatingGenderIcon(gender: 'L', size: 50)
                      else
                        Icon(Icons.male,
                            size: 40,
                            color: _selectedGender == 'L'
                                ? const Color(0xFF2196F3)
                                : Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        'Laki-laki',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _selectedGender == 'L'
                              ? const Color(0xFF2196F3)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedGender = 'P'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _selectedGender == 'P'
                        ? const Color(0xFFE91E63).withValues(alpha: 0.1)
                        : Colors.grey[50],
                    border: Border.all(
                      color: _selectedGender == 'P'
                          ? const Color(0xFFE91E63)
                          : Colors.grey[200]!,
                      width: _selectedGender == 'P' ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      if (_selectedGender == 'P')
                        const FloatingGenderIcon(gender: 'P', size: 50)
                      else
                        Icon(Icons.female,
                            size: 40,
                            color: _selectedGender == 'P'
                                ? const Color(0xFFE91E63)
                                : Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        'Perempuan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _selectedGender == 'P'
                              ? const Color(0xFFE91E63)
                              : Colors.grey[600],
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

  Widget _buildAnimatedHPLCard(Pregnancy pregnancy) {
    return FadeTransition(
      opacity: _staggeredAnimations[0],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _staggeredAnimations[0],
          curve: Curves.easeOutCubic,
        )),
        child: GlassCard(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFA6978),
                  const Color(0xFFFF6B9D),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.child_care,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hari Perkiraan Lahir',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pregnancy.hplFormatted,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'HPHT',
                          pregnancy.hphtFormatted,
                          Icons.event,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem(
                          'Usia',
                          pregnancy.usiaKehamilan.teks,
                          Icons.timer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid(Pregnancy pregnancy) {
    return Column(
      children: [
        // Row 1: HPHT and Age
        Row(
          children: [
            Expanded(
              child: BentoGridItem(
                label: 'HPHT',
                value: pregnancy.hphtFormatted,
                icon: Icons.event_rounded,
                animation: _staggeredAnimations[1],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BentoGridItem(
                label: 'Usia Kehamilan',
                value: pregnancy.usiaKehamilan.teks,
                icon: Icons.timeline_rounded,
                animation: _staggeredAnimations[1],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Countdown and Trimester
        Row(
          children: [
            Expanded(
              child: BentoGridItem(
                label: 'Menuju HPL',
                value: pregnancy.countdown.teks,
                icon: Icons.hourglass_bottom_rounded,
                animation: _staggeredAnimations[2],
                accentColor: const Color(0xFFFF9800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BentoGridItem(
                label: 'Trimester',
                value: pregnancy.trimesterName,
                icon: Icons.pregnant_woman_rounded,
                animation: _staggeredAnimations[2],
                accentColor: const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGlassCountdown(Pregnancy pregnancy) {
    return FadeTransition(
      opacity: _staggeredAnimations[3],
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFA6978).withValues(alpha: 0.2),
                    const Color(0xFFFF6B9D).withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Color(0xFFFA6978),
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menuju Hari Perkiraan Lahir',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pregnancy.countdown.teks,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFA6978),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(
                    '${pregnancy.countdown.mingguSampaiHpl}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFA6978),
                    ),
                  ),
                  Text(
                    'Minggu',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFetalSize(Pregnancy pregnancy) {
    return FadeTransition(
      opacity: _staggeredAnimations[4],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _staggeredAnimations[4],
          curve: Curves.easeOutCubic,
        )),
        child: GlassCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFA6978).withValues(alpha: 0.15),
                          const Color(0xFFFF6B9D).withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      pregnancy.fetalSize!.fruitEmoji,
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ukuran Janin',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pregnancy.fetalSize!.namaIndo,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFA6978),
                          ),
                        ),
                        Text(
                          'Minggu ke-${pregnancy.usiaKehamilan.minggu}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSizeItem(
                    'Berat',
                    pregnancy.fetalSize!.formattedBerat,
                    Icons.line_weight_rounded,
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Colors.grey[200],
                  ),
                  _buildSizeItem(
                    'Panjang',
                    pregnancy.fetalSize!.formattedPanjang,
                    Icons.straighten_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFA6978), size: 26),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFA6978),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassStatus(Pregnancy pregnancy) {
    Color statusColor;
    IconData statusIcon;

    switch (pregnancy.status) {
      case 'normal':
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'approaching':
        statusColor = const Color(0xFFFF9800);
        statusIcon = Icons.info_rounded;
        break;
      case 'overdue':
        statusColor = const Color(0xFFF44336);
        statusIcon = Icons.warning_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info_rounded;
    }

    return FadeTransition(
      opacity: _staggeredAnimations[5],
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pregnancy.statusDescription,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getStatusText(pregnancy.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'normal':
        return 'Kondisi kehamilan baik';
      case 'approaching':
        return 'Persiapkan persalinan';
      case 'overdue':
        return 'Segera hubungi dokter';
      default:
        return '';
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFA6978).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              size: 56,
              color: Color(0xFFFA6978),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum Ada Data Kehamilan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 10),
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
