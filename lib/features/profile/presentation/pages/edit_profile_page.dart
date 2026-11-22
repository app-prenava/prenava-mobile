import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../shared/services/location_service.dart';
import '../../../../shared/services/region_service.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_photo_picker.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalLahirController = TextEditingController();
  final _usiaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _pendidikanController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  String? _selectedGolonganDarah;
  File? _selectedImage;
  DateTime? _selectedDate;

  String? _provinceCode;
  String? _regencyCode;
  String? _districtCode;
  double? _lat;
  double? _lng;
  bool _isFetchingLocation = false;

  List<RegionItem> _provinces = [];
  List<RegionItem> _regencies = [];
  List<RegionItem> _districts = [];
  bool _loadingProvinces = false;
  bool _loadingRegencies = false;
  bool _loadingDistricts = false;

  final _golonganDarahOptions = ['A', 'B', 'AB', 'O'];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    Future.microtask(() async {
      final profileState = ref.read(profileNotifierProvider);
      final profile = profileState.profile;

      if (profile != null) {
        setState(() {
          _tanggalLahirController.text = profile.tanggalLahir ?? '';
          _usiaController.text = profile.usia?.toString() ?? '';
          _alamatController.text = profile.alamat ?? '';
          _noTeleponController.text = profile.noTelepon ?? '';
          _pendidikanController.text = profile.pendidikanTerakhir ?? '';
          _pekerjaanController.text = profile.pekerjaan ?? '';
          _selectedGolonganDarah = profile.golonganDarah;
          _provinceCode = profile.provinceCode;
          _regencyCode = profile.regencyCode;
          _districtCode = profile.districtCode;
          _lat = profile.latitude;
          _lng = profile.longitude;

          if (profile.tanggalLahir != null &&
              profile.tanggalLahir!.isNotEmpty) {
            try {
              _selectedDate =
                  DateFormat('yyyy-MM-dd').parse(profile.tanggalLahir!);
            } catch (_) {}
          }
        });
      }

      await _loadInitialRegions();
    });
  }

  Future<void> _loadInitialRegions() async {
    setState(() => _loadingProvinces = true);
    try {
      final service = ref.read(regionServiceProvider);
      final provinces = await service.getProvinces();
      List<RegionItem> regencies = [];
      List<RegionItem> districts = [];

      if (_provinceCode != null && _provinceCode!.isNotEmpty) {
        regencies = await service.getRegencies(_provinceCode!);
      }
      if (_regencyCode != null && _regencyCode!.isNotEmpty) {
        districts = await service.getDistricts(_regencyCode!);
      }

      if (mounted) {
        setState(() {
          _provinces = provinces;
          _regencies = regencies;
          _districts = districts;
          if (!provinces.any((p) => p.code == _provinceCode)) {
            _provinceCode = null;
          }
          if (!regencies.any((r) => r.code == _regencyCode)) {
            _regencyCode = null;
          }
          if (!districts.any((d) => d.code == _districtCode)) {
            _districtCode = null;
          }
          _loadingProvinces = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingProvinces = false);
    }
  }

  Future<void> _onProvinceChanged(String? code) async {
    setState(() {
      _provinceCode = code;
      _regencyCode = null;
      _districtCode = null;
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
    setState(() {
      _regencyCode = code;
      _districtCode = null;
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

  Future<void> _updateGps() async {
    setState(() => _isFetchingLocation = true);
    final result = await LocationService.requestAndGetCurrentLocation();
    if (!mounted) return;
    setState(() => _isFetchingLocation = false);

    if (result.isSuccess) {
      setState(() {
        _lat = result.latitude;
        _lng = result.longitude;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Koordinat GPS berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Gagal mengambil lokasi GPS'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tanggalLahirController.dispose();
    _usiaController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    _pendidikanController.dispose();
    _pekerjaanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Upload foto tidak tersedia di web. Gunakan aplikasi mobile.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 500 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran file maksimal 500KB'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedImage = file;
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1940),
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

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final profileState = ref.read(profileNotifierProvider);

    if (!profileState.hasProfile && _tanggalLahirController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal lahir wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = <String, dynamic>{};

    if (profileState.hasProfile) {
      final existingProfile = profileState.profile!;

      if (_tanggalLahirController.text.isNotEmpty) {
        data['tanggal_lahir'] = _tanggalLahirController.text;
      } else if (existingProfile.tanggalLahir != null) {
        data['tanggal_lahir'] = existingProfile.tanggalLahir;
      }

      if (_usiaController.text.isNotEmpty) {
        data['usia'] = int.tryParse(_usiaController.text) ?? 0;
      } else if (existingProfile.usia != null) {
        data['usia'] = existingProfile.usia;
      }

      if (_alamatController.text.isNotEmpty) {
        data['alamat'] = _alamatController.text;
      } else if (existingProfile.alamat != null) {
        data['alamat'] = existingProfile.alamat;
      }

      if (_noTeleponController.text.isNotEmpty) {
        data['no_telepon'] = _noTeleponController.text;
      } else if (existingProfile.noTelepon != null) {
        data['no_telepon'] = existingProfile.noTelepon;
      }

      if (_pendidikanController.text.isNotEmpty) {
        data['pendidikan_terakhir'] = _pendidikanController.text;
      } else if (existingProfile.pendidikanTerakhir != null) {
        data['pendidikan_terakhir'] = existingProfile.pendidikanTerakhir;
      }

      if (_pekerjaanController.text.isNotEmpty) {
        data['pekerjaan'] = _pekerjaanController.text;
      } else if (existingProfile.pekerjaan != null) {
        data['pekerjaan'] = existingProfile.pekerjaan;
      }

      if (_selectedGolonganDarah != null) {
        data['golongan_darah'] = _selectedGolonganDarah;
      } else if (existingProfile.golonganDarah != null) {
        data['golongan_darah'] = existingProfile.golonganDarah;
      }
    } else {
      if (_tanggalLahirController.text.isNotEmpty) {
        data['tanggal_lahir'] = _tanggalLahirController.text;
      }
      if (_usiaController.text.isNotEmpty) {
        data['usia'] = int.tryParse(_usiaController.text) ?? 0;
      }
      if (_alamatController.text.isNotEmpty) {
        data['alamat'] = _alamatController.text;
      }
      if (_noTeleponController.text.isNotEmpty) {
        data['no_telepon'] = _noTeleponController.text;
      }
      if (_pendidikanController.text.isNotEmpty) {
        data['pendidikan_terakhir'] = _pendidikanController.text;
      }
      if (_pekerjaanController.text.isNotEmpty) {
        data['pekerjaan'] = _pekerjaanController.text;
      }
      if (_selectedGolonganDarah != null) {
        data['golongan_darah'] = _selectedGolonganDarah;
      }
    }

    if (_provinceCode != null) data['province_code'] = _provinceCode;
    if (_regencyCode != null) data['regency_code'] = _regencyCode;
    if (_districtCode != null) data['district_code'] = _districtCode;
    if (_lat != null && _lng != null) {
      data['lat'] = _lat;
      data['lng'] = _lng;
    }

    final success = await ref.read(profileNotifierProvider.notifier).saveProfile(
          data,
          photoPath: _selectedImage?.path,
        );

    if (mounted) {
      final newState = ref.read(profileNotifierProvider);
      if (success && newState.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newState.successMessage!),
            backgroundColor: const Color(0xFFFA6978),
          ),
        );
        context.pop();
      } else if (newState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDeletePhoto() async {
    await ref.read(profileNotifierProvider.notifier).deletePhoto();
    if (mounted) {
      final state = ref.read(profileNotifierProvider);
      if (state.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.successMessage!),
            backgroundColor: const Color(0xFFFA6978),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Data Pribadi'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF424242),
        elevation: 0,
      ),
      body: profileState.isLoading && profileState.profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: ProfilePhotoPicker(
                        photoUrl: profileState.profile?.photoUrl,
                        selectedImage: _selectedImage,
                        onPickImage: _pickImage,
                        onDeletePhoto: profileState.profile?.photoUrl != null
                            ? _handleDeletePhoto
                            : null,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildUsiaField(),
                    const SizedBox(height: 16),
                    _buildRegionSection(),
                    const SizedBox(height: 16),
                    _buildAlamatField(),
                    const SizedBox(height: 16),
                    _buildNoTeleponField(),
                    const SizedBox(height: 16),
                    _buildPendidikanField(),
                    const SizedBox(height: 16),
                    _buildGolonganDarahField(),
                    const SizedBox(height: 16),
                    _buildPekerjaanField(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(profileState.isLoading),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRegionSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Domisili & Lokasi GPS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('edit_prov_$_provinceCode'),
            isExpanded: true,
            initialValue: _provinceCode,
            decoration: _buildInputDecoration(
              'Provinsi',
              _loadingProvinces ? 'Memuat...' : 'Pilih Provinsi',
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
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('edit_reg_${_provinceCode}_$_regencyCode'),
            isExpanded: true,
            initialValue: _regencyCode,
            decoration: _buildInputDecoration(
              'Kabupaten / Kota',
              _loadingRegencies ? 'Memuat...' : 'Pilih Kabupaten / Kota',
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
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('edit_dist_${_regencyCode}_$_districtCode'),
            isExpanded: true,
            initialValue: _districtCode,
            decoration: _buildInputDecoration(
              'Kecamatan',
              _loadingDistricts ? 'Memuat...' : 'Pilih Kecamatan',
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
                : (val) => setState(() => _districtCode = val),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  _lat != null && _lng != null
                      ? 'GPS: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}'
                      : 'GPS belum tersimpan',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
              TextButton.icon(
                onPressed: _isFetchingLocation ? null : _updateGps,
                icon: _isFetchingLocation
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.my_location,
                        size: 16,
                        color: Color(0xFFFA6978),
                      ),
                label: const Text(
                  'Perbarui GPS',
                  style: TextStyle(color: Color(0xFFFA6978)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _tanggalLahirController,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir *',
        labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        hintText: 'YYYY-MM-DD',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        suffixIcon:
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildUsiaField() {
    return TextFormField(
      controller: _usiaController,
      keyboardType: TextInputType.number,
      decoration: _buildInputDecoration('Usia', '25'),
    );
  }

  Widget _buildAlamatField() {
    return TextFormField(
      controller: _alamatController,
      maxLines: 2,
      decoration: _buildInputDecoration('Alamat Lengkap', 'Nama jalan, RT/RW'),
    );
  }

  Widget _buildNoTeleponField() {
    return TextFormField(
      controller: _noTeleponController,
      keyboardType: TextInputType.phone,
      decoration: _buildInputDecoration(
        'Nomor Telepon',
        '0812xxxxxxxx',
        prefixIcon: Icons.phone,
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (!RegExp(r'^[0-9\-\+\s]+$').hasMatch(value)) {
            return 'Nomor telepon tidak valid';
          }
        }
        return null;
      },
    );
  }

  Widget _buildPendidikanField() {
    return TextFormField(
      controller: _pendidikanController,
      decoration: _buildInputDecoration('Pendidikan Terakhir', 'SMA/SMK / S1'),
    );
  }

  Widget _buildPekerjaanField() {
    return TextFormField(
      controller: _pekerjaanController,
      decoration: _buildInputDecoration('Pekerjaan', 'Ibu Rumah Tangga'),
    );
  }

  Widget _buildGolonganDarahField() {
    return DropdownButtonFormField<String>(
      key: ValueKey('edit_darah_$_selectedGolonganDarah'),
      initialValue: _selectedGolonganDarah,
      decoration:
          _buildInputDecoration('Golongan Darah', 'Pilih golongan darah'),
      items: _golonganDarahOptions
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGolonganDarah = value;
        });
      },
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFA6978),
          disabledBackgroundColor:
              const Color(0xFFFA6978).withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'SIMPAN PERUBAHAN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String label,
    String hint, {
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey[600], size: 20)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
      ),
    );
  }
}
