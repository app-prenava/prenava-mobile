import 'dart:math' as math;

class MaternalConsultationItem {
  final int id;
  final String? transcribedText;
  final String query;
  final String aiAnswer;
  final String referenceSource;
  final String providerUsed;
  final bool isEmergency;
  final String dangerLevel;
  final List<String> dangerKeywords;
  final String? recommendedAction;
  final String? clinicalRisk;
  final String? kiaPageRef;
  final List<String> firstAidSteps;
  final String? facilityRecommendation;
  final DateTime createdAt;

  const MaternalConsultationItem({
    required this.id,
    this.transcribedText,
    required this.query,
    required this.aiAnswer,
    required this.referenceSource,
    required this.providerUsed,
    required this.isEmergency,
    required this.dangerLevel,
    required this.dangerKeywords,
    this.recommendedAction,
    this.clinicalRisk,
    this.kiaPageRef,
    this.firstAidSteps = const [],
    this.facilityRecommendation,
    required this.createdAt,
  });

  List<String> get effectiveFirstAidSteps {
    if (firstAidSteps.isNotEmpty) {
      return firstAidSteps;
    }
    if (!isEmergency) {
      return const [];
    }
    return const [
      'Berbaring miring ke sisi kiri tubuh untuk menjaga kelancaran aliran oksigen ke janin.',
      'Jangan meminum obat, jamu, atau ramuan apa pun tanpa instruksi Bidan atau Dokter.',
      'Siapkan Buku KIA, KTP/BPJS, dan minta pendamping keluarga segera mengantar ke fasilitas kesehatan terdekat.',
    ];
  }

  String get effectiveClinicalRisk {
    if (clinicalRisk != null && clinicalRisk!.trim().isNotEmpty) {
      return clinicalRisk!;
    }
    return 'Gejala yang disampaikan memerlukan evaluasi fisik dan pemantauan detak jantung janin segera di fasilitas kesehatan.';
  }

  String get effectiveRecommendedAction {
    final raw = recommendedAction?.trim() ?? '';
    if (raw.isEmpty) {
      return 'Segera kunjungi Praktik Mandiri Bidan terdekat atau IGD Rumah Sakit PONEK 24 Jam untuk pemeriksaan langsung.';
    }
    // Normalisasi bila masih berupa huruf kapital penuh dari riwayat lama
    if (raw == raw.toUpperCase() && raw.length > 20) {
      return 'Segera kunjungi Praktik Mandiri Bidan terdekat atau IGD Rumah Sakit PONEK untuk pemeriksaan kondisi ibu dan janin.';
    }
    return raw;
  }

  factory MaternalConsultationItem.fromJson(Map<String, dynamic> json) {
    return MaternalConsultationItem(
      id: json['id'] as int? ?? 0,
      transcribedText: json['transcribed_text'] as String?,
      query: json['query'] as String? ?? json['transcribed_text'] as String? ?? '',
      aiAnswer: json['ai_answer'] as String? ?? json['answer'] as String? ?? '',
      referenceSource:
          json['reference_source'] as String? ?? 'Buku KIA Kemenkes RI (Hal. 22)',
      providerUsed: json['provider_used'] as String? ?? 'groq',
      isEmergency: json['is_emergency'] as bool? ?? false,
      dangerLevel: json['danger_level'] as String? ?? 'NORMAL',
      dangerKeywords: (json['danger_keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      recommendedAction: json['recommended_action'] as String?,
      clinicalRisk: json['clinical_risk'] as String?,
      kiaPageRef: json['kia_page_ref'] as String?,
      firstAidSteps: (json['first_aid_steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      facilityRecommendation: json['facility_recommendation'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class DangerCategoryItem {
  final String code;
  final String label;
  final String kiaPageRef;
  final String clinicalRisk;
  final String recommendedAction;
  final List<String> firstAidSteps;
  final String facilityRecommendation;

  const DangerCategoryItem({
    required this.code,
    required this.label,
    this.kiaPageRef = 'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
    this.clinicalRisk = '',
    required this.recommendedAction,
    this.firstAidSteps = const [],
    this.facilityRecommendation =
        'IGD Rumah Sakit PONEK 24 Jam atau Praktik Mandiri Bidan Terdekat',
  });

  factory DangerCategoryItem.fromJson(Map<String, dynamic> json) {
    return DangerCategoryItem(
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      kiaPageRef: json['kia_page_ref'] as String? ??
          'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
      clinicalRisk: json['clinical_risk'] as String? ?? '',
      recommendedAction: json['recommended_action'] as String? ?? '',
      firstAidSteps: (json['first_aid_steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      facilityRecommendation: json['facility_recommendation'] as String? ??
          'IGD Rumah Sakit PONEK 24 Jam atau Praktik Mandiri Bidan Terdekat',
    );
  }
}

class HealthcareFacilityItem {
  final String id;
  final int? bidanId;
  final String name;
  final String facilityType; // 'bidan_mitra', 'rs_ponek', 'puskesmas'
  final bool isPartnerBidan;
  final String serviceBadge;
  final String address;
  final String? phone;
  final String operatingHoursLabel;
  final String? notes;
  final double latitude;
  final double longitude;
  final double? distanceKm;
  final String source; // 'prenava_db' atau 'osm_overpass'

  const HealthcareFacilityItem({
    required this.id,
    this.bidanId,
    required this.name,
    required this.facilityType,
    required this.isPartnerBidan,
    required this.serviceBadge,
    required this.address,
    this.phone,
    required this.operatingHoursLabel,
    this.notes,
    required this.latitude,
    required this.longitude,
    this.distanceKm,
    this.source = 'prenava_db',
  });

  HealthcareFacilityItem withCalculatedDistance(double userLat, double userLng) {
    final dist = calculateHaversineKm(userLat, userLng, latitude, longitude);
    return HealthcareFacilityItem(
      id: id,
      bidanId: bidanId,
      name: name,
      facilityType: facilityType,
      isPartnerBidan: isPartnerBidan,
      serviceBadge: serviceBadge,
      address: address,
      phone: phone,
      operatingHoursLabel: operatingHoursLabel,
      notes: notes,
      latitude: latitude,
      longitude: longitude,
      distanceKm: dist,
      source: source,
    );
  }

  static double calculateHaversineKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double rawKm = earthRadiusKm * c;
    return (rawKm * 10).roundToDouble() / 10.0;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);

  /// Menghasilkan kueri lokasi yang presisi untuk Google Maps Directions
  /// agar pin jatuh tepat di pintu masuk faskes atau alamat jalan sebenarnya.
  String get googleMapsDestinationQuery {
    String cleanAddr = address.trim();
    if (cleanAddr.contains('(') && cleanAddr.endsWith(')')) {
      final start = cleanAddr.indexOf('(');
      cleanAddr = cleanAddr.substring(start + 1, cleanAddr.length - 1).trim();
    }

    final hasStreetAddress = cleanAddr.isNotEmpty &&
        !cleanAddr.toLowerCase().startsWith('koordinat') &&
        !cleanAddr.toLowerCase().startsWith('lihat titik') &&
        !cleanAddr.toLowerCase().startsWith('alamat tersedia');

    if (isPartnerBidan) {
      if (hasStreetAddress) {
        return cleanAddr;
      }
      return '$latitude,$longitude';
    }

    if (hasStreetAddress) {
      return '$name, $cleanAddr';
    }

    if (name.trim().isNotEmpty) {
      return '$name ($latitude,$longitude)';
    }
    return '$latitude,$longitude';
  }

  /// Membangun URL Google Maps Directions yang akurat.
  /// Hanya menyertakan origin jika GPS perangkat benar-benar aktif,
  /// sehingga Google Maps menggunakan lokasi live pengguna bila GPS aplikasi belum aktif.
  Uri buildGoogleMapsDirectionsUri({
    double? userLat,
    double? userLng,
    required bool isUsingGpsLocation,
  }) {
    final queryParams = <String, String>{
      'api': '1',
      'destination': googleMapsDestinationQuery,
      'travelmode': 'driving',
    };

    if (isUsingGpsLocation && userLat != null && userLng != null) {
      queryParams['origin'] = '$userLat,$userLng';
    }

    return Uri.https('www.google.com', '/maps/dir/', queryParams);
  }

  factory HealthcareFacilityItem.fromBackendJson(Map<String, dynamic> json) {
    final type = json['facility_type'] as String? ?? 'bidan_mitra';
    final isPartner = json['is_partner_bidan'] as bool? ?? (type == 'bidan_mitra');
    final rawHours = json['operating_hours_label'] as String?;
    String hoursLabel = rawHours ?? 'Senin - Sabtu (08:00 - 20:00 WIB)';
    if (rawHours == null && json['operating_hours'] is Map) {
      final mapHours = json['operating_hours'] as Map;
      if (mapHours['display'] != null) {
        hoursLabel = mapHours['display'].toString();
      }
    }

    return HealthcareFacilityItem(
      id: 'db_${json['location_id'] ?? json['id'] ?? json['bidan_name']}',
      bidanId: json['bidan_id'] as int?,
      name: json['bidan_name'] as String? ??
          json['name'] as String? ??
          'Fasilitas Kesehatan',
      facilityType: type,
      isPartnerBidan: isPartner,
      serviceBadge: json['service_badge'] as String? ??
          (isPartner ? 'Mitra Resmi Prenava' : 'Faskes Rujukan'),
      address: json['address_label'] as String? ??
          json['address'] as String? ??
          'Alamat tersedia di peta navigasi',
      phone: json['phone']?.toString(),
      operatingHoursLabel: hoursLabel,
      notes: json['notes'] as String?,
      latitude: (json['lat'] ?? json['latitude'] ?? -6.9175 as num).toDouble(),
      longitude: (json['lng'] ?? json['longitude'] ?? 107.6191 as num).toDouble(),
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
      source: 'prenava_db',
    );
  }
}
