import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/services/location_service.dart';
import '../../../../shared/services/region_service.dart';
import '../providers/profile_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfileOnboardingPage extends ConsumerStatefulWidget {
  const ProfileOnboardingPage({super.key});

  @override
  ConsumerState<ProfileOnboardingPage> createState() =>
      _ProfileOnboardingPageState();
}

class _ProfileOnboardingPageState extends ConsumerState<ProfileOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;

  String? _usia;
  String? _statusKandungan;
  String? _provinceCode;
  String? _provinsi;
  String? _regencyCode;
  String? _kota;
  String? _districtCode;
  String? _kecamatan;
  double? _lat;
  double? _lng;
  bool _isFetchingLocation = false;
  String? _locationError;
  bool _locationServiceDisabled = false;
  bool _locationPermanentlyDenied = false;

  List<RegionItem> _provinces = [];
  List<RegionItem> _regencies = [];
  List<RegionItem> _districts = [];
  bool _loadingProvinces = false;
  bool _loadingRegencies = false;
  bool _loadingDistricts = false;
  String? _regionError;

  String? _tanggalLahir;
  String? _noTelepon;
  String? _pendidikanTerakhir;
  String? _pekerjaan;
  String? _golonganDarah;
  String? _pendapatanKeluarga;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadProvinces);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadProvinces() async {
    setState(() {
      _loadingProvinces = true;
      _regionError = null;
    });
    try {
      final items = await ref.read(regionServiceProvider).getProvinces();
      if (mounted) {
        setState(() {
          _provinces = items;
          _loadingProvinces = false;
          if (items.isEmpty) {
            _regionError = 'Data provinsi kosong dari server.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingProvinces = false;
          _regionError =
              'Gagal memuat daftar wilayah. Pastikan aplikasi terhubung ke server backend lokal.';
        });
      }
    }
  }

  Future<void> _onProvinceChanged(String? code) async {
    final selected = _provinces.where((p) => p.code == code).firstOrNull;
    setState(() {
      _provinceCode = code;
      _provinsi = selected?.name;
      _regencyCode = null;
      _kota = null;
      _districtCode = null;
      _kecamatan = null;
      _regencies = [];
      _districts = [];
      _loadingRegencies = code != null;
    });
    if (code == null) return;
    try {
      final items = await ref.read(regionServiceProvider).getRegencies(code);
      if (mounted) {
        setState(() {
          _regencies = items;
          _loadingRegencies = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingRegencies = false);
    }
  }

  Future<void> _onRegencyChanged(String? code) async {
    final selected = _regencies.where((r) => r.code == code).firstOrNull;
    setState(() {
      _regencyCode = code;
      _kota = selected?.name;
      _districtCode = null;
      _kecamatan = null;
      _districts = [];
      _loadingDistricts = code != null;
    });
    if (code == null) return;
    try {
      final items = await ref.read(regionServiceProvider).getDistricts(code);
      if (mounted) {
        setState(() {
          _districts = items;
          _loadingDistricts = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingDistricts = false);
    }
  }

  void _onDistrictChanged(String? code) {
    final selected = _districts.where((d) => d.code == code).firstOrNull;
    setState(() {
      _districtCode = code;
      _kecamatan = selected?.name;
    });
  }

  Future<void> _captureGpsLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
      _locationServiceDisabled = false;
      _locationPermanentlyDenied = false;
    });

    final result = await LocationService.requestAndGetCurrentLocation();
    if (!mounted) return;

    setState(() {
      _isFetchingLocation = false;
      if (result.isSuccess) {
        _lat = result.latitude;
        _lng = result.longitude;
        _locationError = null;
      } else {
        _locationError = result.errorMessage;
        _locationServiceDisabled = result.isServiceDisabled;
        _locationPermanentlyDenied = result.isPermanentlyDenied;
      }
    });
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
    final data = <String, dynamic>{
      'usia': _usia,
      'status_kandungan': _statusKandungan,
      'provinsi': _provinsi,
      'province_code': _provinceCode,
      'kota': _kota,
      'regency_code': _regencyCode,
      'kecamatan': _kecamatan,
      'district_code': _districtCode,
      'lat': _lat,
      'lng': _lng,
      'tanggal_lahir': _tanggalLahir,
      'no_telepon': _noTelepon,
      'pendidikan_terakhir': _pendidikanTerakhir,
      'pekerjaan': _pekerjaan,
      'golongan_darah': _golonganDarah,
      'pendapatan_keluarga': _pendapatanKeluarga,
    };

    final success =
        await ref.read(profileNotifierProvider.notifier).saveProfile(data);

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan profil, coba lagi nanti'),
        ),
      );
    }
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: _currentPage > 0 ? _previousPage : null,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _totalPages,
                backgroundColor: Colors.grey[200],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                minHeight: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_currentPage + 1}/$_totalPages',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
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
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (isOptional)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '(Opsional)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: const BorderSide(color: Color(0xFFFA6978)),
                    ),
                    child: const Text(
                      'Lewati',
                      style: TextStyle(fontSize: 16, color: Color(0xFFFA6978)),
                    ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? 'Selesai' : 'Lanjut',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
          color: isSelected
              ? const Color(0xFFFA6978).withValues(alpha: 0.1)
              : Colors.white,
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
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFFFA6978)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1Welcome() {
    final userName =
        ref.watch(authNotifierProvider).user?.name.split(' ')[0] ?? 'Bunda';
    return _buildStepWrapper(
      title: 'Selamat datang, $userName!',
      subtitle:
          'Mari lengkapi profilmu agar kami bisa memberikan rekomendasi terbaik.',
      canContinue: true,
      content: Center(
        child: Image.asset(
          'assets/images/prenava_logo.png',
          height: 160,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.favorite, size: 100, color: Color(0xFFFA6978)),
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
    final options = [
      'Trimester 1',
      'Trimester 2',
      'Trimester 3',
      'Pasca Melahirkan',
    ];
    return _buildStepWrapper(
      title: 'Status kandungan saat ini?',
      subtitle: 'Pilih masa kehamilan Bunda.',
      canContinue: _statusKandungan != null,
      content: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final option = options[index];
          return _buildOptionTile(
            option,
            _statusKandungan == option,
            () => setState(() => _statusKandungan = option),
          );
        },
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _buildStep4Lokasi() {
    final canContinue = _provinceCode != null &&
        _regencyCode != null &&
        _districtCode != null &&
        _lat != null &&
        _lng != null;

    return _buildStepWrapper(
      title: 'Di mana domisili Bunda?',
      subtitle:
          'Pilih wilayah domisili dan aktifkan GPS untuk menemukan bidan mitra terdekat.',
      canContinue: canContinue,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_regionError != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _regionError!,
                        style: TextStyle(fontSize: 12, color: Colors.red[800]),
                      ),
                    ),
                    TextButton(
                      onPressed: _loadProvinces,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ],
            DropdownButtonFormField<String>(
              key: ValueKey('prov_$_provinceCode'),
              isExpanded: true,
              initialValue: _provinceCode,
              decoration: _dropdownDecoration(
                'Provinsi *',
                _loadingProvinces ? 'Memuat provinsi...' : 'Pilih Provinsi',
              ),
              items: _provinces
                  .map(
                    (p) => DropdownMenuItem(
                      value: p.code,
                      child: Text(p.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: _loadingProvinces ? null : _onProvinceChanged,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              key: ValueKey('reg_${_provinceCode}_$_regencyCode'),
              isExpanded: true,
              initialValue: _regencyCode,
              decoration: _dropdownDecoration(
                'Kabupaten / Kota *',
                _loadingRegencies
                    ? 'Memuat kabupaten/kota...'
                    : (_provinceCode == null
                        ? 'Pilih Provinsi terlebih dahulu'
                        : 'Pilih Kabupaten / Kota'),
              ),
              items: _regencies
                  .map(
                    (r) => DropdownMenuItem(
                      value: r.code,
                      child: Text(r.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (_provinceCode == null || _loadingRegencies)
                  ? null
                  : _onRegencyChanged,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              key: ValueKey('dist_${_regencyCode}_$_districtCode'),
              isExpanded: true,
              initialValue: _districtCode,
              decoration: _dropdownDecoration(
                'Kecamatan *',
                _loadingDistricts
                    ? 'Memuat kecamatan...'
                    : (_regencyCode == null
                        ? 'Pilih Kabupaten/Kota terlebih dahulu'
                        : 'Pilih Kecamatan'),
              ),
              items: _districts
                  .map(
                    (d) => DropdownMenuItem(
                      value: d.code,
                      child: Text(d.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (_regencyCode == null || _loadingDistricts)
                  ? null
                  : _onDistrictChanged,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _lat != null
                    ? Colors.green.withValues(alpha: 0.08)
                    : const Color(0xFFFA6978).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _lat != null
                      ? Colors.green.shade300
                      : const Color(0xFFFA6978).withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        _lat != null ? Icons.gps_fixed : Icons.location_on,
                        color: _lat != null
                            ? Colors.green[700]
                            : const Color(0xFFFA6978),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _lat != null
                              ? 'Lokasi GPS Berhasil Diambil'
                              : 'Izin GPS Wajib Aktif',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _lat != null
                                ? Colors.green[800]
                                : const Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _lat != null
                        ? 'Koordinat: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}'
                        : 'Aktifkan GPS untuk mempermudah pencarian klinik bidan mitra terdekat di menu Janji Temu.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  if (_locationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _locationError!,
                      style: TextStyle(fontSize: 12, color: Colors.red[700]),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _isFetchingLocation ? null : _captureGpsLocation,
                    icon: _isFetchingLocation
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            _lat != null ? Icons.refresh : Icons.my_location,
                            size: 18,
                          ),
                    label: Text(
                      _isFetchingLocation
                          ? 'Mengambil Lokasi...'
                          : (_lat != null
                              ? 'Perbarui Lokasi GPS'
                              : 'Aktifkan & Ambil Lokasi GPS'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _lat != null
                          ? Colors.green[600]
                          : const Color(0xFFFA6978),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (_locationServiceDisabled || _locationPermanentlyDenied)
                    TextButton(
                      onPressed: () {
                        if (_locationServiceDisabled) {
                          LocationService.openLocationSettings();
                        } else {
                          LocationService.openAppSettings();
                        }
                      },
                      child: Text(
                        _locationServiceDisabled
                            ? 'Buka Pengaturan GPS'
                            : 'Buka Pengaturan Izin Aplikasi',
                        style: const TextStyle(color: Color(0xFFFA6978)),
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
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFFFA6978),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _tanggalLahir =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: _tanggalLahir ?? 'Pilih tanggal lahir',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFFFA6978),
                    ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
            const Text(
              'Pendidikan Terakhir',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pendidikanOptions.map((opt) {
                final isSelected = _pendidikanTerakhir == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor:
                      const Color(0xFFFA6978).withValues(alpha: 0.2),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon:
                    const Icon(Icons.work_outline, color: Color(0xFFFA6978)),
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
    final pendapatanOptions = [
      '< 2 Juta',
      '2 - 5 Juta',
      '5 - 10 Juta',
      '> 10 Juta',
    ];
    return _buildStepWrapper(
      title: 'Kesehatan & Keuangan',
      subtitle:
          'Data ini membantu kami memberikan rekomendasi nutrisi yang tepat.',
      canContinue: true,
      isOptional: true,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Golongan Darah',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
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
                          color: isSelected
                              ? const Color(0xFFFA6978)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFA6978)
                                : Colors.grey[300]!,
                          ),
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
            const Text(
              'Pendapatan Keluarga (per bulan)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            ...pendapatanOptions.map((opt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildOptionTile(
                  opt,
                  _pendapatanKeluarga == opt,
                  () => setState(() => _pendapatanKeluarga = opt),
                ),
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
