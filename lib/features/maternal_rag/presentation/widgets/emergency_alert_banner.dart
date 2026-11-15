import 'package:flutter/material.dart';
import '../../data/models/maternal_rag_model.dart';
import 'nearby_faskes_referral_section.dart';

class EmergencyAlertBanner extends StatelessWidget {
  final MaternalConsultationItem consultation;
  final VoidCallback onDismiss;

  const EmergencyAlertBanner({
    super.key,
    required this.consultation,
    required this.onDismiss,
  });

  void _openNearestFacilitiesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.78,
        minChildSize: 0.5,
        maxChildSize: 0.94,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Bidan & IGD Rumah Sakit Terdekat',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Tutup daftar fasilitas kesehatan',
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                const NearbyFaskesReferralSection(
                  maxVisibleItems: 8,
                  isEmergencyContext: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symptomSummary = consultation.dangerKeywords.isNotEmpty
        ? 'Tanda bahaya terdeteksi (${consultation.dangerKeywords.join(", ")})'
        : 'Tanda bahaya kehamilan terdeteksi';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFECACA),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFF991B1B),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              symptomSummary,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7F1D1D),
              ),
            ),
          ),
          TextButton(
            onPressed: () => _openNearestFacilitiesSheet(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF991B1B),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text(
              'Lihat Faskes',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onDismiss,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: Color(0xFF7F1D1D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
