import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/appointment_providers.dart';

class ConsentPage extends ConsumerStatefulWidget {
  const ConsentPage({super.key});

  @override
  ConsumerState<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends ConsumerState<ConsentPage> {
  final Map<String, bool> _sharedFields = {};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentNotifierProvider);
    final consentInfo = state.consentInfo;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Izin Data'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFA6978)),
            )
          : consentInfo == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat informasi izin',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConsentText(consentInfo!),
                  const SizedBox(height: 24),
                  _buildSharedFieldsSection(consentInfo!),
                  const SizedBox(height: 24),
                  _buildButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildConsentText(consentInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2196F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.privacy_tip, color: Color(0xFF1976D2)),
              const SizedBox(width: 8),
              const Text(
                'Kebijakan Privasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            consentInfo.consentText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF424242),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Versi: ${consentInfo.version}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharedFieldsSection(consentInfo) {
    final fieldLabels = {
      'name': 'Nama Lengkap',
      'email': 'Email',
      'phone': 'Nomor Telepon',
      'address': 'Alamat',
      'age': 'Usia',
      'pregnancy_week': 'Usia Kehamilan (Minggu)',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Data yang Dapat Diakses oleh Bidan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Anda dapat mengatur informasi mana yang ingin dibagikan dengan bidan yang dipilih',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        ...consentInfo.availableFields.map((field) {
          final isSelected = _sharedFields[field] ?? true;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  _sharedFields[field] = value ?? true;
                });
              },
              title: Text(
                fieldLabels[field] ?? field,
                style: const TextStyle(fontSize: 15, color: Color(0xFF424242)),
              ),
              subtitle: Text(
                _getFieldDescription(field),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: const Color(0xFFFA6978),
            ),
          );
        }),
      ],
    );
  }

  String _getFieldDescription(String field) {
    final descriptions = {
      'name': 'Nama lengkap Anda',
      'email': 'Alamat email terdaftar',
      'phone': 'Nomor telepon yang dapat dihubungi',
      'address': 'Alamat domisili',
      'age': 'Usia Anda saat ini',
      'pregnancy_week': 'Usia kehamilan dalam minggu',
    };
    return descriptions[field] ?? '';
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canProceed()
                ? () {
                    ref
                        .read(appointmentNotifierProvider.notifier)
                        .loadConsultationTypes();
                    Navigator.pushNamed(
                      context,
                      '/appointments/create/form',
                      arguments: _sharedFields,
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: const Text(
              'Lanjut ke Form Janji Temu',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: const Text('Kembali'),
          ),
        ),
      ],
    );
  }

  bool _canProceed() {
    final state = ref.watch(appointmentNotifierProvider);
    return state.selectedBidan != null &&
        _sharedFields.values.any((value) => value);
  }
}
