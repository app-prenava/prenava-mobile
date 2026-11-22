import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/services/location_service.dart';
import '../../domain/entities/bidan_profile.dart';
import '../providers/appointment_providers.dart';

class BidanSelectionPage extends ConsumerStatefulWidget {
  const BidanSelectionPage({super.key});

  @override
  ConsumerState<BidanSelectionPage> createState() => _BidanSelectionPageState();
}

class _BidanSelectionPageState extends ConsumerState<BidanSelectionPage> {
  final TextEditingController _searchController = TextEditingController();

  double? _userLat;
  double? _userLng;
  double? _selectedRadiusKm = 10; // null = semua jarak
  bool _isCheckingGps = true;
  String? _gpsError;
  bool _isServiceDisabled = false;
  bool _isPermanentlyDenied = false;

  static const _radiusOptions = <Map<String, dynamic>>[
    {'label': '5 km', 'value': 5.0},
    {'label': '10 km', 'value': 10.0},
    {'label': '25 km', 'value': 25.0},
    {'label': 'Semua', 'value': null},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGpsAndLoadBidans();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initGpsAndLoadBidans() async {
    setState(() {
      _isCheckingGps = true;
      _gpsError = null;
      _isServiceDisabled = false;
      _isPermanentlyDenied = false;
    });

    final result = await LocationService.requestAndGetCurrentLocation();
    if (!mounted) return;

    if (!result.isSuccess) {
      setState(() {
        _isCheckingGps = false;
        _gpsError = result.errorMessage;
        _isServiceDisabled = result.isServiceDisabled;
        _isPermanentlyDenied = result.isPermanentlyDenied;
      });
      return;
    }

    setState(() {
      _isCheckingGps = false;
      _userLat = result.latitude;
      _userLng = result.longitude;
    });

    await _fetchNearbyBidans();
  }

  Future<void> _fetchNearbyBidans() async {
    if (_userLat == null || _userLng == null) return;
    await ref.read(appointmentNotifierProvider.notifier).loadBidanList(
          lat: _userLat,
          lng: _userLng,
          radiusKm: _selectedRadiusKm,
          search: _searchController.text.trim(),
        );
  }

  Future<void> _launchPhone(String phone) async {
    if (phone.trim().isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchDirections(BidanProfile bidan) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${bidan.latitude},${bidan.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Bidan Mitra Terdekat'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        actions: [
          if (_userLat != null)
            IconButton(
              icon: const Icon(Icons.my_location),
              tooltip: 'Perbarui GPS',
              onPressed: _initGpsAndLoadBidans,
            ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _isCheckingGps
          ? _buildGpsLoadingView()
          : _gpsError != null
              ? _buildGpsRequiredView()
              : Column(
                  children: [
                    _buildSearchAndRadiusBar(),
                    Expanded(
                      child: RefreshIndicator(
                        color: const Color(0xFFFA6978),
                        onRefresh: _fetchNearbyBidans,
                        child: state.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFA6978),
                                ),
                              )
                            : state.bidans.isEmpty
                                ? _buildEmptyBidansView()
                                : ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      8,
                                      16,
                                      24,
                                    ),
                                    itemCount: state.bidans.length,
                                    itemBuilder: (context, index) =>
                                        _buildBidanCard(state.bidans[index]),
                                  ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildGpsLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFA6978)),
          SizedBox(height: 16),
          Text(
            'Mendeteksi lokasi GPS Anda...',
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildGpsRequiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFA6978).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off_rounded,
                size: 56,
                color: Color(0xFFFA6978),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Izin GPS Wajib Aktif',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _gpsError ??
                  'Aktifkan GPS untuk melihat daftar klinik bidan mitra terverifikasi terdekat di sekitar Anda.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _initGpsAndLoadBidans,
                icon: const Icon(Icons.my_location),
                label: const Text('Aktifkan GPS & Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_isServiceDisabled || _isPermanentlyDenied) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  if (_isServiceDisabled) {
                    LocationService.openLocationSettings();
                  } else {
                    LocationService.openAppSettings();
                  }
                },
                child: Text(
                  _isServiceDisabled
                      ? 'Buka Pengaturan GPS Perangkat'
                      : 'Buka Pengaturan Izin Aplikasi',
                  style: const TextStyle(color: Color(0xFFFA6978)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndRadiusBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _fetchNearbyBidans(),
            decoration: InputDecoration(
              hintText: 'Cari nama klinik, bidan, atau kecamatan...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                        _fetchNearbyBidans();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Icon(
                  Icons.radar,
                  size: 16,
                  color: Color(0xFFFA6978),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Radius:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                ..._radiusOptions.map((opt) {
                  final val = opt['value'] as double?;
                  final isSelected = _selectedRadiusKm == val;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(opt['label'] as String),
                      selected: isSelected,
                      selectedColor:
                          const Color(0xFFFA6978).withValues(alpha: 0.18),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFFFA6978)
                            : Colors.grey[700],
                      ),
                      onSelected: (_) {
                        setState(() => _selectedRadiusKm = val);
                        _fetchNearbyBidans();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBidansView() {
    return ListView(
      children: [
        const SizedBox(height: 80),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Icon(Icons.local_hospital_outlined,
                    size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada bidan mitra terverifikasi di radius ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Coba perluas radius pencarian ke 25 km atau pilih "Semua" untuk melihat seluruh mitra Prenava.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                if (_selectedRadiusKm != null) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _selectedRadiusKm = null);
                      _fetchNearbyBidans();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFA6978),
                      side: const BorderSide(color: Color(0xFFFA6978)),
                    ),
                    child: const Text('Tampilkan Semua Mitra Terdekat'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBidanCard(BidanProfile bidan) {
    final hoursText = bidan.displayOperatingHours;
    final regionText = bidan.displayRegion;

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      const Color(0xFFFA6978).withValues(alpha: 0.12),
                  backgroundImage:
                      bidan.photoUrl != null && bidan.photoUrl!.isNotEmpty
                          ? NetworkImage(bidan.photoUrl!)
                          : null,
                  child: bidan.photoUrl == null || bidan.photoUrl!.isEmpty
                      ? const Icon(
                          Icons.local_hospital,
                          color: Color(0xFFFA6978),
                          size: 26,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bidan.displayClinicName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      if (bidan.bidanName != null &&
                          bidan.bidanName!.isNotEmpty &&
                          bidan.bidanName != bidan.displayClinicName) ...[
                        const SizedBox(height: 2),
                        Text(
                          bidan.bidanName!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (bidan.isVerifiedPartner)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 13,
                                    color: Colors.green[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Mitra Terverifikasi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (bidan.distanceKm != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFA6978)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${bidan.distanceKm!.toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFA6978),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (bidan.specialization != null &&
                bidan.specialization!.isNotEmpty) ...[
              _infoRow(
                Icons.medical_services_outlined,
                bidan.specialization!,
                color: const Color(0xFFFA6978),
              ),
              const SizedBox(height: 6),
            ],
            _infoRow(Icons.location_on_outlined, bidan.address),
            if (regionText.isNotEmpty) ...[
              const SizedBox(height: 4),
              _infoRow(Icons.map_outlined, regionText),
            ],
            if (hoursText != null && hoursText.isNotEmpty) ...[
              const SizedBox(height: 4),
              _infoRow(Icons.access_time, hoursText),
            ],
            if (bidan.phone.isNotEmpty) ...[
              const SizedBox(height: 4),
              _infoRow(Icons.phone_outlined, bidan.phone),
            ],
            if (bidan.strNumber != null && bidan.strNumber!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _infoRow(
                Icons.badge_outlined,
                'STR: ${bidan.strNumber}${bidan.sipNumber != null && bidan.sipNumber!.isNotEmpty ? ' • SIP: ${bidan.sipNumber}' : ''}',
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                if (bidan.phone.isNotEmpty)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _launchPhone(bidan.phone),
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('Telepon'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                if (bidan.phone.isNotEmpty) const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchDirections(bidan),
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Rute'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[800],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(appointmentNotifierProvider.notifier)
                      .selectBidan(bidan);
                  context.push('/appointments/create/form');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Pilih & Buat Janji Temu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color ?? Colors.grey[700],
              fontWeight: color != null ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
