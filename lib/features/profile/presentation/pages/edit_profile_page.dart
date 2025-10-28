import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  final _tanggalLahirController = TextEditingController();
  final _usiaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _pendidikanController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  String? _selectedGolonganDarah;
  File? _selectedImage;
  DateTime? _selectedDate;

  final _golonganDarahOptions = ['A', 'B', 'AB', 'O'];

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
          _selectedGolonganDarah = profile.golonganDarah;

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
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Image picker doesn't work well on web
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload foto tidak tersedia di web. Gunakan aplikasi mobile.'),
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

      // Check file size (max 500KB)
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

    // Validate required field for create
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

    // Always include existing data for update, or new data for create
    if (profileState.hasProfile) {
      // For update: preserve existing data and only update changed fields
      final existingProfile = profileState.profile!;
      
      // Only include fields that have been changed or are not empty
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
      // For create: only include non-empty fields
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
                  children: [
                    const SizedBox(height: 16),
                    ProfilePhotoPicker(
                      photoUrl: profileState.profile?.photoUrl,
                      selectedImage: _selectedImage,
                      onPickImage: _pickImage,
                      onDeletePhoto: profileState.profile?.photoUrl != null
                          ? _handleDeletePhoto
                          : null,
                    ),
                    const SizedBox(height: 32),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildUsiaField(),
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

  Widget _buildDateField() {
    return TextFormField(
      controller: _tanggalLahirController,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir *',
        labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        hintText: '27 agustus 1946',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
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
      decoration: _buildInputDecoration('Usia', '14'),
    );
  }

  Widget _buildAlamatField() {
    return TextFormField(
      controller: _alamatController,
      maxLines: 2,
      decoration: _buildInputDecoration('Alamat', 'Sukabirus depan warunk nasi ibu nuri'),
    );
  }

  Widget _buildNoTeleponField() {
    return TextFormField(
      controller: _noTeleponController,
      keyboardType: TextInputType.phone,
      decoration: _buildInputDecoration('Nomor Telepon', '123-456-7890', prefixIcon: Icons.phone),
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
      decoration: _buildInputDecoration('Pendidikan Terakhir', 'SD'),
    );
  }

  Widget _buildPekerjaanField() {
    return TextFormField(
      controller: _pekerjaanController,
      decoration: _buildInputDecoration('Pekerjaan', 'SD'),
    );
  }

  Widget _buildGolonganDarahField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedGolonganDarah,
      decoration: _buildInputDecoration('Golongan Darah', 'Pilih golongan darah'),
      items: _golonganDarahOptions
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              ))
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
                'SUBMIT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, String hint, {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[50],
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600], size: 20) : null,
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

