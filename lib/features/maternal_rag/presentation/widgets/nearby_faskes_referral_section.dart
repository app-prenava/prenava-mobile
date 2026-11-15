import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/maternal_rag_model.dart';
import '../providers/maternal_rag_providers.dart';

class NearbyFaskesReferralSection extends ConsumerWidget {
  final bool isCompact;
  final int maxVisibleItems;
  final bool isEmergencyContext;

  const NearbyFaskesReferralSection({
    super.key,
    this.isCompact = false,
    this.maxVisibleItems = 3,
    this.isEmergencyContext = false,
  });

  Future<void> _openGoogleMapsDirections(
    BuildContext context, {
    required double userLat,
    required double userLng,
    required bool isUsingGpsLocation,
    required HealthcareFacilityItem facility,
  }) async {
    final uri = facility.buildGoogleMapsDirectionsUri(
      userLat: userLat,
      userLng: userLng,
      isUsingGpsLocation: isUsingGpsLocation,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak dapat membuka aplikasi Google Maps di perangkat ini.',
          ),
        ),
      );
    }
  }

  Future<void> _callPhoneNumber(BuildContext context, String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: cleaned);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor telepon: $cleaned')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(maternalRagNotifierProvider);
    final notifier = ref.read(maternalRagNotifierProvider.notifier);
    final filtered = state.filteredFacilities;
    final visibleList = filtered.take(maxVisibleItems).toList();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Header: Judul Seksi + Tombol Teks Lokasi GPS yang Ringkas
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.place_outlined,
                color: Color(0xFF334155),
                size: 16,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Rekomendasi Bidan & Faskes Terdekat',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: 'Perbarui lokasi GPS untuk mengurutkan fasilitas terdekat',
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: state.isLoadingFacilities
                      ? null
                      : () => notifier.refreshLocationAndFacilities(
                            requestPermissionIfNeeded: true,
                          ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.isUsingGpsLocation
                              ? Icons.my_location_rounded
                              : Icons.gps_fixed_rounded,
                          size: 13,
                          color: state.isUsingGpsLocation
                              ? const Color(0xFF065F46)
                              : const Color(0xFF475569),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.isUsingGpsLocation ? 'GPS Aktif' : 'Akurasi GPS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: state.isUsingGpsLocation
                                ? const Color(0xFF065F46)
                                : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            state.locationStatusText,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),

          // Filter Kategori Faskes (Ringkas, tanpa garis tepi tebal)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill(
                  label: 'Semua (${state.nearbyFacilities.length})',
                  isSelected: state.selectedFacilityFilter == 'all',
                  onTap: () => notifier.setFacilityFilter('all'),
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  label:
                      'Bidan Mitra Prenava (${state.nearbyFacilities.where((f) => f.isPartnerBidan).length})',
                  isSelected: state.selectedFacilityFilter == 'bidan_mitra',
                  onTap: () => notifier.setFacilityFilter('bidan_mitra'),
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  label:
                      'IGD RS & Puskesmas (${state.nearbyFacilities.where((f) => !f.isPartnerBidan).length})',
                  isSelected: state.selectedFacilityFilter == 'rs_puskesmas',
                  onTap: () => notifier.setFacilityFilter('rs_puskesmas'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 3 UI States (R-27): Loading, Error, Empty, atau Data List
          if (state.isLoadingFacilities)
            _buildLoadingState()
          else if (state.facilitiesError != null &&
              state.nearbyFacilities.isEmpty)
            _buildErrorState(
              state.facilitiesError!,
              onRetry: () => notifier.refreshLocationAndFacilities(
                requestPermissionIfNeeded: true,
              ),
            )
          else if (visibleList.isEmpty)
            _buildEmptyState(
              onResetFilter: () => notifier.setFacilityFilter('all'),
            )
          else
            Column(
              children: [
                for (int i = 0; i < visibleList.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _buildFacilityCard(
                    context,
                    facility: visibleList[i],
                    userLat: state.userLat,
                    userLng: state.userLng,
                    isUsingGpsLocation: state.isUsingGpsLocation,
                  ),
                ],
              ],
            ),

          const SizedBox(height: 8),

          // Baris Bawah: Tautan Peta Sebaran Bidan (+ Panggilan 119 hanya saat darurat)
          Row(
            children: [
              TextButton.icon(
                onPressed: () => context.push('/bidan-map'),
                icon: const Icon(Icons.map_outlined, size: 15),
                label: const Text(
                  'Buka Peta Sebaran Bidan',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF334155),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                ),
              ),
              const Spacer(),
              if (isEmergencyContext)
                TextButton.icon(
                  onPressed: () => _callPhoneNumber(context, '119'),
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 14),
                  label: const Text(
                    'Ambulans 119',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF991B1B),
                    backgroundColor: const Color(0xFFFEF2F2),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF334155) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: const [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Color(0xFF475569),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mencari Bidan Mitra dan Rumah Sakit terdekat...',
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, {required VoidCallback onRetry}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF475569),
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF334155),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Muat Ulang', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required VoidCallback onResetFilter}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Tidak ada fasilitas pada filter ini.',
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF475569),
              ),
            ),
          ),
          TextButton(
            onPressed: onResetFilter,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF334155),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text(
              'Tampilkan Semua',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu Faskes dengan hierarki informasi 3 tingkat:
  /// 1. Nama Faskes & Jarak (Utama)
  /// 2. Jenis Layanan, Alamat & Jam Buka (Sekunder)
  /// 3. Tautan Aksi Proporsional (Tersier)
  Widget _buildFacilityCard(
    BuildContext context, {
    required HealthcareFacilityItem facility,
    required double userLat,
    required double userLng,
    required bool isUsingGpsLocation,
  }) {
    final isPartner = facility.isPartnerBidan;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tingkat 1: Nama Fasilitas + Jarak (km)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  facility.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              if (facility.distanceKm != null) ...[
                const SizedBox(width: 8),
                Text(
                  '${facility.distanceKm!.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),

          // Tingkat 2: Label Kategori + Alamat + Jam Buka
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isPartner
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  facility.serviceBadge,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isPartner
                        ? const Color(0xFF065F46)
                        : const Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  facility.operatingHoursLabel,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            facility.address,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),

          // Tingkat 3: Baris Tombol Aksi Proporsional
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (isPartner)
                _buildCompactActionButton(
                  icon: Icons.calendar_today_rounded,
                  label: 'Buat Janji Bidan',
                  isPrimary: true,
                  isEmergencyRed: false,
                  onTap: () => context.push('/appointments/create'),
                ),
              _buildCompactActionButton(
                icon: Icons.directions_outlined,
                label: isPartner ? 'Rute ke Bidan' : 'Rute ke IGD / Faskes',
                isPrimary: !isPartner,
                isEmergencyRed: !isPartner && isEmergencyContext,
                onTap: () => _openGoogleMapsDirections(
                  context,
                  userLat: userLat,
                  userLng: userLng,
                  isUsingGpsLocation: isUsingGpsLocation,
                  facility: facility,
                ),
              ),
              if (facility.phone != null && facility.phone!.trim().isNotEmpty)
                _buildCompactActionButton(
                  icon: Icons.call_outlined,
                  label: 'Hubungi',
                  isPrimary: false,
                  isEmergencyRed: false,
                  onTap: () => _callPhoneNumber(context, facility.phone!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required bool isEmergencyRed,
    required VoidCallback onTap,
  }) {
    final bgColor = isEmergencyRed
        ? const Color(0xFFB91C1C)
        : (isPrimary ? const Color(0xFF334155) : const Color(0xFFF1F5F9));
    final fgColor =
        (isPrimary || isEmergencyRed) ? Colors.white : const Color(0xFF334155);

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13.5, color: fgColor),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
