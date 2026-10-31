import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/maternal_rag_model.dart';

class EmergencyAlertBanner extends StatelessWidget {
  final MaternalConsultationItem consultation;
  final VoidCallback onDismiss;

  const EmergencyAlertBanner({
    super.key,
    required this.consultation,
    required this.onDismiss,
  });

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:119'); // Nomor Darurat Medis Indonesia 119
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE53935),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERINGATAN DARURAT OBSTETRI!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    Text(
                      'Tanda Bahaya Kemenkes RI Terdeteksi',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFD32F2F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFFB71C1C)),
                onPressed: onDismiss,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (consultation.dangerKeywords.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: consultation.dangerKeywords.map((kw) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCDD2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '⚠️ $kw',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              consultation.recommendedAction ??
                  'SEGERA MENUJU KE KLINIK BIDAN ATAU IGD RUMAH SAKIT TERDEKAT!',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: Color(0xFFB71C1C),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _callEmergency,
                  icon: const Icon(Icons.phone_in_talk, size: 18),
                  label: const Text(
                    'Panggil Darurat 119',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Catatan: Sistem telah otomatis meneruskan peringatan ini ke Antrean Triase Bidan Prenava.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Color(0xFF757575),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
