import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/appointment_providers.dart';

class ConsentPage extends ConsumerStatefulWidget {
  const ConsentPage({super.key});

  @override
  ConsumerState<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends ConsumerState<ConsentPage> {
  final Map<String, bool> _sharedFields = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentNotifierProvider.notifier).loadConsentInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentNotifierProvider);
    final consentInfo = state.consentInfo;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Izin Data',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
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
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIllustration(),
                            const SizedBox(height: 32),
                            _buildConsentText(consentInfo),
                            const SizedBox(height: 24),
                            _buildSharedFieldsSection(consentInfo),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomAction(),
                  ],
                ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFA6978), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFA6978).withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.health_and_safety_outlined,
          size: 72,
          color: Color(0xFFFA6978),
        ),
      ),
    );
  }

  Widget _buildConsentText(consentInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.privacy_tip, color: Color(0xFFFA6978)),
            const SizedBox(width: 8),
            const Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          consentInfo.consentText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF616161),
            height: 1.5,
          ),
        ),
      ],
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data yang akan dibagikan:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          ...consentInfo.availableFields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    fieldLabels[field] ?? field,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF616161)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    bool allChecked = _sharedFields.length == ref.read(appointmentNotifierProvider).consentInfo?.availableFields.length &&
                      _sharedFields.values.every((v) => v);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: allChecked,
                    onChanged: (value) {
                      setState(() {
                        final fields = ref.read(appointmentNotifierProvider).consentInfo?.availableFields ?? [];
                        for (var field in fields) {
                          _sharedFields[field] = value ?? false;
                        }
                      });
                    },
                    activeColor: const Color(0xFFFA6978),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Saya menyetujui kebijakan privasi dan mengizinkan data di atas dibagikan kepada bidan.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF616161),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _canProceed()
                    ? () => _showConfirmationDialog()
                    : null,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFA6978),
                  side: BorderSide(
                    color: _canProceed()
                        ? const Color(0xFFFA6978)
                        : const Color(0xFFFA6978).withValues(alpha: 0.3),
                    width: 2,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Setuju & Lanjutkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Persetujuan Berhasil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Anda telah menyetujui kebijakan privasi. Silakan lanjutkan untuk membuat jadwal janji temu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // Load consultation types and navigate to form
                  ref
                      .read(appointmentNotifierProvider.notifier)
                      .loadConsultationTypes();
                  context.push(
                    '/appointments/create/form',
                    extra: _sharedFields,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Lanjutkan Buat Jadwal',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    final state = ref.watch(appointmentNotifierProvider);
    final userFields = state.consentInfo?.availableFields ?? [];
    if (userFields.isEmpty) return false;
    
    // Require ALL fields to be checked for this master consent flow
    return state.selectedBidan != null &&
        userFields.every((field) => _sharedFields[field] == true);
  }
}
