import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pregnancy.dart';
import '../providers/pregnancy_providers.dart';
import '../widgets/pregnancy_animated_widgets.dart';

/// Halaman untuk Bidan mengupdate status kehamilan
class BidanUpdatePage extends ConsumerStatefulWidget {
  final Pregnancy pregnancy;

  const BidanUpdatePage({
    super.key,
    required this.pregnancy,
  });

  @override
  ConsumerState<BidanUpdatePage> createState() => _BidanUpdatePageState();
}

class _BidanUpdatePageState extends ConsumerState<BidanUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  // Status flags
  bool _isHighRisk = false;
  bool _hasDiabetes = false;
  bool _hasHypertension = false;
  bool _hasAnemia = false;
  bool _needsSpecialCare = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if available
    _isHighRisk = widget.pregnancy.status == 'overdue' ||
                  widget.pregnancy.status == 'critical';
    _notesController.text = widget.pregnancy.statusDescription;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Determine new status based on conditions
    String newStatus;
    if (_isHighRisk) {
      newStatus = 'critical';
    } else if (_needsSpecialCare) {
      newStatus = 'approaching';
    } else {
      newStatus = 'normal';
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Update'),
        content: Text(
          'Apakah Anda yakin ingin mengupdate status kehamilan menjadi "${_getStatusText(newStatus)}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ya, Update'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Call provider to update health status
    // TODO: Get actual pregnancy ID from the data
    final pregnancyId = 1; // This should come from pregnancy.id

    final success = await ref.read(pregnancyNotifierProvider.notifier).updateHealthStatus(
      id: pregnancyId,
      isHighRisk: _isHighRisk,
      hasDiabetes: _hasDiabetes,
      hasHypertension: _hasHypertension,
      hasAnemia: _hasAnemia,
      needsSpecialCare: _needsSpecialCare,
      notes: _notesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status kesehatan berhasil diupdate'),
          backgroundColor: Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(pregnancyNotifierProvider).error ?? 'Gagal mengupdate status'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      );
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'normal':
        return 'Normal';
      case 'approaching':
        return 'Membutuhkan Perhatian';
      case 'critical':
        return 'High Risk';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Update Status Kehamilan'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Info Card
              _buildPatientInfo(),

              const SizedBox(height: 24),

              // Status Flags Section
              _buildStatusFlagsSection(),

              const SizedBox(height: 24),

              // Notes Section
              _buildNotesSection(),

              const SizedBox(height: 32),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _updateStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6978),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.update, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Update Status',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pasien',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFA6978),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Nama Bayi', widget.pregnancy.babyName ?? 'Belum diisi', Icons.baby_changing_station),
          const SizedBox(height: 12),
          _buildInfoRow('HPHT', widget.pregnancy.hphtFormatted, Icons.event),
          const SizedBox(height: 12),
          _buildInfoRow('HPL', widget.pregnancy.hplFormatted, Icons.calendar_today),
          const SizedBox(height: 12),
          _buildInfoRow('Usia Kehamilan', widget.pregnancy.usiaKehamilan.teks, Icons.timer),
          const SizedBox(height: 12),
          _buildInfoRow('Status Saat Ini', widget.pregnancy.statusDescription, Icons.info),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFA6978).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFFA6978), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFlagsSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Kesehatan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFA6978),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih kondisi kesehatan yang relevan',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),

          // High Risk Toggle (Important)
          _buildToggleCard(
            title: 'High Risk',
            subtitle: 'Kehamilan berisiko tinggi',
            icon: Icons.warning_rounded,
            value: _isHighRisk,
            onChanged: (value) => setState(() => _isHighRisk = value),
            isCritical: true,
          ),

          const SizedBox(height: 12),

          // Diabetes Toggle
          _buildToggleCard(
            title: 'Diabetes Gestasional',
            subtitle: 'Diabetes selama kehamilan',
            icon: Icons.bloodtype_rounded,
            value: _hasDiabetes,
            onChanged: (value) => setState(() => _hasDiabetes = value),
          ),

          const SizedBox(height: 12),

          // Hypertension Toggle
          _buildToggleCard(
            title: 'Hipertensi',
            subtitle: 'Tekanan darah tinggi',
            icon: Icons.favorite_rounded,
            value: _hasHypertension,
            onChanged: (value) => setState(() => _hasHypertension = value),
          ),

          const SizedBox(height: 12),

          // Anemia Toggle
          _buildToggleCard(
            title: 'Anemia',
            subtitle: 'Kurang darah',
            icon: Icons.water_drop_rounded,
            value: _hasAnemia,
            onChanged: (value) => setState(() => _hasAnemia = value),
          ),

          const SizedBox(height: 12),

          // Special Care Toggle
          _buildToggleCard(
            title: 'Butuh Perawatan Khusus',
            subtitle: 'Memerlukan perhatian medis',
            icon: Icons.health_and_safety_rounded,
            value: _needsSpecialCare,
            onChanged: (value) => setState(() => _needsSpecialCare = value),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isCritical = false,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value
              ? (isCritical
                  ? const Color(0xFFF44336).withOpacity(0.1)
                  : const Color(0xFFFA6978).withOpacity(0.1))
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value
                ? (isCritical ? const Color(0xFFF44336) : const Color(0xFFFA6978))
                : Colors.grey[200]!,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: value
                    ? (isCritical
                        ? const Color(0xFFF44336).withOpacity(0.2)
                        : const Color(0xFFFA6978).withOpacity(0.2))
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: value
                    ? (isCritical ? const Color(0xFFF44336) : const Color(0xFFFA6978))
                    : Colors.grey[400],
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: value
                          ? (isCritical ? const Color(0xFFF44336) : const Color(0xFFFA6978))
                          : const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: isCritical ? const Color(0xFFF44336) : const Color(0xFFFA6978),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan Bidan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFA6978),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan catatan atau keterangan tambahan',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Masukkan catatan di sini...',
              hintStyle: TextStyle(color: Colors.grey[400]),
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
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Catatan wajib diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

/// Model untuk update status kehamilan dari bidan
class PregnancyStatusUpdate {
  final bool isHighRisk;
  final bool hasDiabetes;
  final bool hasHypertension;
  final bool hasAnemia;
  final bool needsSpecialCare;
  final String notes;
  final String updatedBy;

  PregnancyStatusUpdate({
    required this.isHighRisk,
    required this.hasDiabetes,
    required this.hasHypertension,
    required this.hasAnemia,
    required this.needsSpecialCare,
    required this.notes,
    required this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'is_high_risk': isHighRisk,
      'has_diabetes': hasDiabetes,
      'has_hypertension': hasHypertension,
      'has_anemia': hasAnemia,
      'needs_special_care': needsSpecialCare,
      'notes': notes,
      'updated_by': updatedBy,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  factory PregnancyStatusUpdate.fromJson(Map<String, dynamic> json) {
    return PregnancyStatusUpdate(
      isHighRisk: json['is_high_risk'] ?? false,
      hasDiabetes: json['has_diabetes'] ?? false,
      hasHypertension: json['has_hypertension'] ?? false,
      hasAnemia: json['has_anemia'] ?? false,
      needsSpecialCare: json['needs_special_care'] ?? false,
      notes: json['notes'] ?? '',
      updatedBy: json['updated_by'] ?? '',
    );
  }
}
