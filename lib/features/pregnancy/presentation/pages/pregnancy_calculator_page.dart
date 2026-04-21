import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/pregnancy.dart';
import '../../domain/entities/week_phase_data.dart';
import '../providers/pregnancy_providers.dart';

class PregnancyCalculatorPage extends ConsumerStatefulWidget {
  const PregnancyCalculatorPage({super.key});

  @override
  ConsumerState<PregnancyCalculatorPage> createState() =>
      _PregnancyCalculatorPageState();
}

class _PregnancyCalculatorPageState
    extends ConsumerState<PregnancyCalculatorPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _hphtController = TextEditingController();
  String _selectedGender = 'L';

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    Future.microtask(() {
      ref.read(pregnancyNotifierProvider.notifier).loadMyPregnancy();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pregnancy = ref.read(pregnancyNotifierProvider).pregnancy;
    if (pregnancy != null && pregnancy.babyGender != null) {
      _selectedGender = pregnancy.babyGender!;
    }
  }

  @override
  void dispose() {
    _hphtController.dispose();
    _floatController.dispose();
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFA6978),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF333333),
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
      await ref
          .read(pregnancyNotifierProvider.notifier)
          .calculatePregnancy(hpht: DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pregnancyNotifierProvider);
    final pregnancy = state.pregnancy;

    ref.listen<PregnancyState>(pregnancyNotifierProvider, (previous, next) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Top form section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGenderToggle(),
                const SizedBox(height: 20),
                _buildHphtHplRow(pregnancy),
              ],
            ),
          ),
          // Bottom pink curve section
          Expanded(
            child: _buildWeekPhaseSection(pregnancy, state),
          ),
        ],
      ),
    );
  }

  // ───────────────────── AppBar ─────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFA6978),
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kalkulator HPL',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Hitung Hari Perkiraan Lahir',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(
            'assets/images/kalkulator hpl.png',
            width: 40,
            height: 40,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────── Gender Toggle ─────────────────────

  Widget _buildGenderToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis Kelamin Anak',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Laki-Laki label
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedGender = 'L'),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedGender == 'L'
                        ? const Color(0xFFE3F2FD)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedGender == 'L'
                          ? const Color(0xFF42A5F5)
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Text(
                    'Laki-Laki',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedGender == 'L'
                          ? const Color(0xFF1E88E5)
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Toggle switch
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = _selectedGender == 'L' ? 'P' : 'L';
                });
              },
              child: Container(
                width: 64,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFEEEEEE),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: _selectedGender == 'L'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedGender == 'L'
                              ? const Color(0xFF42A5F5)
                              : const Color(0xFFEC407A),
                        ),
                        child: Icon(
                          _selectedGender == 'L' ? Icons.male : Icons.female,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Perempuan label
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedGender = 'P'),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedGender == 'P'
                        ? const Color(0xFFFCE4EC)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedGender == 'P'
                          ? const Color(0xFFEC407A)
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Text(
                    'Perempuan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedGender == 'P'
                          ? const Color(0xFFEC407A)
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ───────────────────── HPHT + HPL Row ─────────────────────

  Widget _buildHphtHplRow(Pregnancy? pregnancy) {
    return Row(
      children: [
        // HPHT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HPHT',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _hphtController.text.isNotEmpty
                        ? DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(DateTime.parse(_hphtController.text))
                        : pregnancy?.hphtFormatted ?? 'Pilih tanggal',
                    style: TextStyle(
                      fontSize: 13,
                      color: (_hphtController.text.isNotEmpty || pregnancy != null)
                          ? const Color(0xFF333333)
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // HPL
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HPL',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  color: Colors.grey[50],
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  pregnancy?.hplFormatted ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────── Week Phase Section (Pink Curve) ─────────────────────

  Widget _buildWeekPhaseSection(Pregnancy? pregnancy, PregnancyState state) {
    if (state.isLoading || state.isCalculating) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFA6978)),
      );
    }

    final week = pregnancy?.usiaKehamilan.minggu ?? 1;
    final phaseData = WeekPhaseData.getForWeek(week);

    return ClipPath(
      clipper: _TopCurveClipper(),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFCDD2),
              Color(0xFFFCE4EC),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Sparkles + Fruit icon with floating animation
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: Column(
                children: [
                  // Sparkle decorations
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background glow for the 3D baby
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        // 3D Baby Image
                        Image.asset(
                          pregnancy?.trimester == 1
                              ? 'assets/images/baby_trimester_1.png'
                              : pregnancy?.trimester == 2
                                  ? 'assets/images/baby_trimester_2.png'
                                  : 'assets/images/baby_trimester_3.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.child_care,
                            size: 80,
                            color: Color(0xFFFA6978),
                          ),
                        ),
                        // Small fruit icon as secondary info
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              phaseData.fruitIcon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        // Sparkles
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _buildSparkle(16),
                        ),
                        Positioned(
                          top: 20,
                          left: 0,
                          child: _buildSparkle(12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Glow/shadow circle under the baby
                  Container(
                    width: 100,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFA6978).withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Week number
            Text(
              pregnancy != null ? 'Minggu ${pregnancy.usiaKehamilan.minggu}' : 'Minggu 1',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD81B60),
              ),
            ),
            const SizedBox(height: 4),
            // Phase name
            Text(
              phaseData.phaseName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFAD1457),
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                phaseData.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkle(double size) {
    return Icon(
      Icons.auto_awesome,
      size: size,
      color: const Color(0xFFFFD54F),
    );
  }
}

// ───────────────────── Custom Clipper ─────────────────────

class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
