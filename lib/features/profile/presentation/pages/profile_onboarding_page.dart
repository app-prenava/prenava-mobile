import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfileOnboardingPage extends ConsumerStatefulWidget {
  const ProfileOnboardingPage({super.key});

  @override
  ConsumerState<ProfileOnboardingPage> createState() => _ProfileOnboardingPageState();
}

class _ProfileOnboardingPageState extends ConsumerState<ProfileOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;

  String? _usia;
  String? _statusKandungan;
  String? _provinsi;
  String? _kota;
  String? _kecamatan;
  String? _tanggalLahir;
  String? _noTelepon;
  String? _pendidikanTerakhir;
  String? _pekerjaan;
  String? _golonganDarah;
  String? _pendapatanKeluarga;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final data = {
      'usia': _usia,
      'status_kandungan': _statusKandungan,
      'provinsi': _provinsi,
      'kota': _kota,
      'kecamatan': _kecamatan,
      'tanggal_lahir': _tanggalLahir,
      'no_telepon': _noTelepon,
      'pendidikan_terakhir': _pendidikanTerakhir,
      'pekerjaan': _pekerjaan,
      'golongan_darah': _golonganDarah,
      'pendapatan_keluarga': _pendapatanKeluarga,
    };

    final success = await ref.read(profileNotifierProvider.notifier).saveProfile(data);

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan profil, coba lagi nanti')),
      );
    }
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey, size: 20),
            onPressed: _currentPage > 0 ? _previousPage : null,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _totalPages,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                minHeight: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_currentPage + 1}/$_totalPages',
            style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStepWrapper({
    required String title,
    required String subtitle,
    required Widget content,
    required bool canContinue,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            textAlign: TextAlign.center,
          ),
          if (isOptional)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '(Opsional)',
                style: TextStyle(fontSize: 12, color: Colors.grey[400], fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 32),
          Expanded(child: content),
          const SizedBox(height: 16),
          Row(
            children: [
              if (isOptional)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _nextPage,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: const BorderSide(color: Color(0xFFFA6978)),
                    ),
                    child: const Text('Lewati', style: TextStyle(fontSize: 16, color: Color(0xFFFA6978))),
                  ),
                ),
              if (isOptional) const SizedBox(width: 12),
              Expanded(
                flex: isOptional ? 2 : 1,
                child: ElevatedButton(
                  onPressed: canContinue ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6978),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? 'Selesai' : 'Lanjut',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFA6978).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFA6978) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFFFA6978) : Colors.black87,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFA6978)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1Welcome() {
    final userName = ref.watch(authNotifierProvider).user?.name?.split(' ')[0] ?? 'Bunda';
    return _buildStepWrapper(
      title: 'Selamat datang, $userName! 👋',
      subtitle: 'Mari lengkapi profilmu agar kami bisa memberikan rekomendasi terbaik.',
      canContinue: true,
      content: Center(
        child: Image.asset(
          'assets/images/prenava_logo.png',
          height: 160,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.favorite, size: 100, color: Color(0xFFFA6978)),
        ),
      ),
    );
  }

  Widget _buildStep2Usia() {
    return _buildStepWrapper(
      title: 'Berapa usia Bunda?',
      subtitle: 'Ini membantu kami menyesuaikan informasi kesehatan.',
      canContinue: _usia != null && _usia!.isNotEmpty,
      content: Center(
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Contoh: 25',
            hintStyle: TextStyle(color: Colors.grey[300]),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _usia = value),
        ),
      ),
    );
  }

  Widget _buildStep3StatusKandungan() {
    final options = ['Trimester 1', 'Trimester 2', 'Trimester 3', 'Pasca Melahirkan'];
    return _buildStepWrapper(
      title: 'Status kandungan saat ini?',
      subtitle: 'Pilih masa kehamilan Bunda.',
      canContinue: _statusKandungan != null,
      content: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final option = options[index];
          return _buildOptionTile(option, _statusKandungan == option, () => setState(() => _statusKandungan = option));
        },
      ),
    );
  }

  Widget _buildStep4Lokasi() {
    return _buildStepWrapper(
      title: 'Dimana Bunda tinggal?',
      subtitle: 'Untuk mencari tenaga kesehatan (Bidan) di sekitar Bunda.',
      canContinue: _provinsi != null && _provinsi!.isNotEmpty && _kota != null && _kota!.isNotEmpty,
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Provinsi',
                hintText: 'Misal: Jawa Barat',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => setState(() => _provinsi = value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kabupaten/Kota',
                hintText: 'Misal: Bandung',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => setState(() => _kota = value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kecamatan',
                hintText: 'Misal: Coblong',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => setState(() => _kecamatan = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep5TanggalLahirTelepon() {
    return _buildStepWrapper(
      title: 'Data Diri Bunda',
      subtitle: 'Tanggal lahir dan nomor telepon Anda.',
      canContinue: true,
      isOptional: true,
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1995, 1, 1),
                  firstDate: DateTime(1960),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFFFA6978)),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _tanggalLahir = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: _tanggalLahir ?? 'Pilih tanggal lahir',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFFFA6978)),
                  ),
                  controller: TextEditingController(text: _tanggalLahir),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                hintText: 'Misal: 08123456789',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.phone, color: Color(0xFFFA6978)),
              ),
              onChanged: (value) => setState(() => _noTelepon = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep6PendidikanPekerjaan() {
    final pendidikanOptions = ['SD', 'SMP', 'SMA/SMK', 'D3', 'S1', 'S2', 'S3'];
    return _buildStepWrapper(
      title: 'Pendidikan & Pekerjaan',
      subtitle: 'Informasi tambahan untuk personalisasi.',
      canContinue: true,
      isOptional: true,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pendidikan Terakhir', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pendidikanOptions.map((opt) {
                final isSelected = _pendidikanTerakhir == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: const Color(0xFFFA6978).withValues(alpha: 0.2),
                  checkmarkColor: const Color(0xFFFA6978),
                  onSelected: (_) => setState(() => _pendidikanTerakhir = opt),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Pekerjaan',
                hintText: 'Misal: Ibu Rumah Tangga',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.work_outline, color: Color(0xFFFA6978)),
              ),
              onChanged: (value) => setState(() => _pekerjaan = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep7KesehatanKeuangan() {
    final darahOptions = ['A', 'B', 'AB', 'O'];
    final pendapatanOptions = ['< 2 Juta', '2 - 5 Juta', '5 - 10 Juta', '> 10 Juta'];
    return _buildStepWrapper(
      title: 'Kesehatan & Keuangan',
      subtitle: 'Data ini membantu kami memberikan rekomendasi nutrisi yang tepat.',
      canContinue: true,
      isOptional: true,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Golongan Darah', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
            const SizedBox(height: 8),
            Row(
              children: darahOptions.map((opt) {
                final isSelected = _golonganDarah == opt;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _golonganDarah = opt),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFA6978) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? const Color(0xFFFA6978) : Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Pendapatan Keluarga (per bulan)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
            const SizedBox(height: 8),
            ...pendapatanOptions.map((opt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildOptionTile(opt, _pendapatanKeluarga == opt, () => setState(() => _pendapatanKeluarga = opt)),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildStep1Welcome(),
                  _buildStep2Usia(),
                  _buildStep3StatusKandungan(),
                  _buildStep4Lokasi(),
                  _buildStep5TanggalLahirTelepon(),
                  _buildStep6PendidikanPekerjaan(),
                  _buildStep7KesehatanKeuangan(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
