import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_photo_picker.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _tanggalLahirController = TextEditingController();
  final _usiaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _pendidikanController = TextEditingController();
  final _pekerjaanController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _kotaController = TextEditingController();
  final _kecamatanController = TextEditingController();

  // Dropdown Selections
  String? _selectedGolonganDarah;
  String? _selectedStatusKandungan;
  String? _selectedPendapatanKeluarga;

  // Image Selection
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _selectedImagePath;
  DateTime? _selectedDate;

  final _golonganDarahOptions = ['A', 'B', 'AB', 'O', 'Belum Tahu'];
  final _statusKandunganOptions = ['Hamil', 'Menyusui', 'Program Hamil'];
  final _pendapatanOptions = [
    '< Rp 2.000.000',
    'Rp 2.000.000 - Rp 5.000.000',
    'Rp 5.000.000 - Rp 10.000.000',
    '> Rp 10.000.000'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    Future.microtask(() {
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
          _provinsiController.text = profile.provinsi ?? '';
          _kotaController.text = profile.kota ?? '';
          _kecamatanController.text = profile.kecamatan ?? '';

          _selectedGolonganDarah = _golonganDarahOptions.contains(profile.golonganDarah)
              ? profile.golonganDarah
              : null;
          _selectedStatusKandungan = _statusKandunganOptions.contains(profile.statusKandungan)
              ? profile.statusKandungan
              : null;
          _selectedPendapatanKeluarga = _pendapatanOptions.contains(profile.pendapatanKeluarga)
              ? profile.pendapatanKeluarga
              : null;

          if (profile.tanggalLahir != null && profile.tanggalLahir!.isNotEmpty) {
            try {
              _selectedDate = DateFormat('yyyy-MM-dd').parse(profile.tanggalLahir!);
            } catch (_) {}
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tanggalLahirController.dispose();
    _usiaController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    _pendidikanController.dispose();
    _pekerjaanController.dispose();
    _provinsiController.dispose();
    _kotaController.dispose();
    _kecamatanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        // Check file size (max 500KB)
        if (bytes.lengthInBytes > 500 * 1024) {
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
          _selectedImageBytes = bytes;
          _selectedImagePath = pickedFile.path;
          if (!kIsWeb) {
            _selectedImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1998, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFA6978),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      int calculatedAge = now.year - picked.year;
      if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
        calculatedAge--;
      }
      if (calculatedAge < 0) calculatedAge = 0;

      setState(() {
        _selectedDate = picked;
        _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
        _usiaController.text = calculatedAge.toString();
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final profileState = ref.read(profileNotifierProvider);

    // Validate required field
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
    if (_selectedStatusKandungan != null) {
      data['status_kandungan'] = _selectedStatusKandungan;
    }
    if (_selectedPendapatanKeluarga != null) {
      data['pendapatan_keluarga'] = _selectedPendapatanKeluarga;
    }
    if (_provinsiController.text.isNotEmpty) {
      data['provinsi'] = _provinsiController.text;
    }
    if (_kotaController.text.isNotEmpty) {
      data['kota'] = _kotaController.text;
    }
    if (_kecamatanController.text.isNotEmpty) {
      data['kecamatan'] = _kecamatanController.text;
    }

    final success = await ref.read(profileNotifierProvider.notifier).saveProfile(
          data,
          photoPath: _selectedImagePath,
        );

    if (mounted) {
      final newState = ref.read(profileNotifierProvider);
      if (success && newState.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newState.successMessage!),
            backgroundColor: const Color(0xFF059669),
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Edit Data Pribadi',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: profileState.isLoading && profileState.profile == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFA6978)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ProfilePhotoPicker(
                        photoUrl: profileState.profile?.photoUrl,
                        selectedImage: _selectedImage,
                        selectedImageBytes: _selectedImageBytes,
                        onPickImage: _pickImage,
                        onDeletePhoto: profileState.profile?.photoUrl != null
                            ? _handleDeletePhoto
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionCard(
                      title: 'Data Medis & Kehamilan',
                      icon: Icons.health_and_safety_outlined,
                      children: [
                        _buildDateField(),
                        const SizedBox(height: 14),
                        _buildUsiaField(),
                        const SizedBox(height: 14),
                        _buildStatusKandunganField(),
                        const SizedBox(height: 14),
                        _buildGolonganDarahField(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'Domisili & Kontak',
                      icon: Icons.location_on_outlined,
                      children: [
                        _buildAlamatField(),
                        const SizedBox(height: 14),
                        _buildProvinsiField(),
                        const SizedBox(height: 14),
                        _buildKotaField(),
                        const SizedBox(height: 14),
                        _buildKecamatanField(),
                        const SizedBox(height: 14),
                        _buildNoTeleponField(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'Informasi Sosial & Ekonomi',
                      icon: Icons.work_outline,
                      children: [
                        _buildPendidikanField(),
                        const SizedBox(height: 14),
                        _buildPekerjaanField(),
                        const SizedBox(height: 14),
                        _buildPendapatanField(),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildSubmitButton(profileState.isLoading),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFA6978), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _tanggalLahirController,
      readOnly: true,
      onTap: _selectDate,
      decoration: _buildInputDecoration(
        'Tanggal Lahir *',
        'Pilih tanggal lahir Anda',
        suffixIcon: Icons.calendar_today,
      ),
    );
  }

  Widget _buildUsiaField() {
    return TextFormField(
      controller: _usiaController,
      keyboardType: TextInputType.number,
      decoration: _buildInputDecoration(
        'Usia (Tahun)',
        'Terhitung otomatis dari tanggal lahir',
      ),
    );
  }

  Widget _buildStatusKandunganField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedStatusKandungan,
      decoration: _buildInputDecoration('Status Kandungan', 'Pilih status saat ini'),
      items: _statusKandunganOptions
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value, style: const TextStyle(color: Color(0xFF0F172A))),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedStatusKandungan = value;
        });
      },
    );
  }

  Widget _buildGolonganDarahField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedGolonganDarah,
      decoration: _buildInputDecoration('Golongan Darah', 'Pilih golongan darah'),
      items: _golonganDarahOptions
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value, style: const TextStyle(color: Color(0xFF0F172A))),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGolonganDarah = value;
        });
      },
    );
  }

  Widget _buildAlamatField() {
    return TextFormField(
      controller: _alamatController,
      maxLines: 2,
      decoration: _buildInputDecoration('Alamat Lengkap', 'Nama jalan, nomor rumah, RT/RW'),
    );
  }

  Widget _buildProvinsiField() {
    return TextFormField(
      controller: _provinsiController,
      decoration: _buildInputDecoration('Provinsi', 'Contoh: Jawa Barat'),
    );
  }

  Widget _buildKotaField() {
    return TextFormField(
      controller: _kotaController,
      decoration: _buildInputDecoration('Kota / Kabupaten', 'Contoh: Kota Bandung'),
    );
  }

  Widget _buildKecamatanField() {
    return TextFormField(
      controller: _kecamatanController,
      decoration: _buildInputDecoration('Kecamatan', 'Contoh: Buahbatu'),
    );
  }

  Widget _buildNoTeleponField() {
    return TextFormField(
      controller: _noTeleponController,
      keyboardType: TextInputType.phone,
      decoration: _buildInputDecoration('Nomor Telepon / WhatsApp', 'Contoh: 081234567890'),
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
      decoration: _buildInputDecoration('Pendidikan Terakhir', 'Contoh: SMA/SMK, Sarjana'),
    );
  }

  Widget _buildPekerjaanField() {
    return TextFormField(
      controller: _pekerjaanController,
      decoration: _buildInputDecoration('Pekerjaan', 'Contoh: Ibu Rumah Tangga, Karyawan'),
    );
  }

  Widget _buildPendapatanField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedPendapatanKeluarga,
      decoration: _buildInputDecoration('Pendapatan Keluarga per Bulan', 'Pilih rentang pendapatan'),
      items: _pendapatanOptions
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value, style: const TextStyle(color: Color(0xFF0F172A))),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedPendapatanKeluarga = value;
        });
      },
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFA6978),
          disabledBackgroundColor: const Color(0xFFFA6978).withValues(alpha: 0.6),
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
                'Simpan Perubahan Profil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, String hint, {IconData? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF64748B), size: 20) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
      ),
    );
  }
}
