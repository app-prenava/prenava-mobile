import 'package:dio/dio.dart';
import '../models/maternal_rag_model.dart';

class MaternalRagRemoteDatasource {
  final Dio _dio;

  MaternalRagRemoteDatasource(this._dio);

  /// POST /api/v1/maternal-rag/ask-text
  Future<MaternalConsultationItem> askText({
    required String query,
    int? pregnancyId,
    double? lat,
    double? lng,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/maternal-rag/ask-text',
        data: {
          'query': query,
          if (pregnancyId != null) 'pregnancy_id': pregnancyId,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 45),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final consultation =
            data['consultation'] as Map<String, dynamic>? ?? {};
        final ragResult = data['rag_result'] as Map<String, dynamic>? ?? {};

        final merged = <String, dynamic>{
          ...consultation,
          'query': query,
          'answer': ragResult['answer'] ?? consultation['ai_answer'] ?? '',
          'reference_source': ragResult['reference_source'] ??
              consultation['reference_source'] ??
              'Buku KIA Kemenkes RI (Hal. 22)',
          'is_emergency': ragResult['is_emergency'] ??
              consultation['is_emergency'] ??
              false,
          'danger_level': ragResult['danger_level'] ??
              consultation['danger_level'] ??
              'NORMAL',
          'danger_keywords': ragResult['danger_keywords'] ??
              consultation['danger_keywords'] ??
              [],
          'recommended_action': ragResult['recommended_action'] ??
              consultation['recommended_action'],
          'clinical_risk': ragResult['clinical_risk'] ??
              consultation['clinical_risk'],
          'kia_page_ref': ragResult['kia_page_ref'] ??
              consultation['kia_page_ref'],
          'first_aid_steps': ragResult['first_aid_steps'] ??
              consultation['first_aid_steps'] ??
              [],
          'facility_recommendation': ragResult['facility_recommendation'] ??
              consultation['facility_recommendation'],
          'provider_used': ragResult['provider_used'] ??
              consultation['provider_used'] ??
              'groq',
        };

        return MaternalConsultationItem.fromJson(merged);
      }
      throw Exception('Format respons server tidak valid.');
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw Exception(msg ?? 'Gagal menghubungi Bidan AI: ${e.message}');
    }
  }

  /// POST /api/v1/maternal-rag/ask-voice
  Future<MaternalConsultationItem> askVoice({
    required MultipartFile audioFile,
    int? pregnancyId,
    double? lat,
    double? lng,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': audioFile,
        if (pregnancyId != null) 'pregnancy_id': pregnancyId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      });

      final response = await _dio.post(
        '/v1/maternal-rag/ask-voice',
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final consultation =
            data['consultation'] as Map<String, dynamic>? ?? {};
        final ragResult = data['rag_result'] as Map<String, dynamic>? ?? {};

        final merged = <String, dynamic>{
          ...consultation,
          'query': ragResult['transcribed_text'] ??
              consultation['transcribed_text'] ??
              'Konsultasi Suara',
          'answer': ragResult['answer'] ?? consultation['ai_answer'] ?? '',
          'reference_source': ragResult['reference_source'] ??
              consultation['reference_source'] ??
              'Buku KIA Kemenkes RI (Hal. 22)',
          'is_emergency': ragResult['is_emergency'] ??
              consultation['is_emergency'] ??
              false,
          'danger_level': ragResult['danger_level'] ??
              consultation['danger_level'] ??
              'NORMAL',
          'danger_keywords': ragResult['danger_keywords'] ??
              consultation['danger_keywords'] ??
              [],
          'recommended_action': ragResult['recommended_action'] ??
              consultation['recommended_action'],
          'clinical_risk': ragResult['clinical_risk'] ??
              consultation['clinical_risk'],
          'kia_page_ref': ragResult['kia_page_ref'] ??
              consultation['kia_page_ref'],
          'first_aid_steps': ragResult['first_aid_steps'] ??
              consultation['first_aid_steps'] ??
              [],
          'facility_recommendation': ragResult['facility_recommendation'] ??
              consultation['facility_recommendation'],
          'provider_used': ragResult['provider_used'] ??
              consultation['provider_used'] ??
              'groq',
        };

        return MaternalConsultationItem.fromJson(merged);
      }
      throw Exception('Format respons suara tidak valid.');
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw Exception(msg ?? 'Gagal memproses rekaman suara: ${e.message}');
    }
  }

  /// GET /api/v1/maternal-rag/history
  Future<List<MaternalConsultationItem>> getHistory() async {
    try {
      final response = await _dio.get('/v1/maternal-rag/history');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final list = data['data'] ?? data['history'];
        if (list is List) {
          return list
              .map(
                (item) => MaternalConsultationItem.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// GET /api/v1/maternal-rag/danger-catalog
  Future<List<DangerCategoryItem>> getDangerCatalog() async {
    try {
      final response = await _dio.get('/v1/maternal-rag/danger-catalog');
      final data = response.data;
      if (data is Map<String, dynamic> && data['catalog'] is List) {
        final parsed = (data['catalog'] as List)
            .map(
              (item) =>
                  DangerCategoryItem.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        if (parsed.isNotEmpty) {
          return parsed;
        }
      }
    } catch (_) {}
    return _fallbackDangerCatalog;
  }

  /// Mengambil daftar Fasilitas Kesehatan Terdekat (Hybrid: Database Mitra Prenava + OpenStreetMap Overpass API + Curated Fallback)
  Future<List<HealthcareFacilityItem>> getNearbyHealthcareFacilities({
    required double userLat,
    required double userLng,
  }) async {
    final List<HealthcareFacilityItem> partnerBidans = [];
    final List<HealthcareFacilityItem> backendReferrals = [];

    // 1. Ambil Bidan Mitra Prenava & Faskes Rujukan dari Database Backend Laravel
    try {
      final response = await _dio.get(
        '/user/bidans/locations',
        queryParameters: {
          'lat': userLat,
          'lng': userLng,
          'radius_km': 25,
        },
        options: Options(receiveTimeout: const Duration(seconds: 8)),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final rawBidans = data['data'];
        if (rawBidans is List) {
          for (final item in rawBidans) {
            if (item is Map<String, dynamic>) {
              partnerBidans.add(
                HealthcareFacilityItem.fromBackendJson(item)
                    .withCalculatedDistance(userLat, userLng),
              );
            }
          }
        }
        final rawReferrals = data['referral_facilities'];
        if (rawReferrals is List) {
          for (final item in rawReferrals) {
            if (item is Map<String, dynamic>) {
              backendReferrals.add(
                HealthcareFacilityItem.fromBackendJson(item)
                    .withCalculatedDistance(userLat, userLng),
              );
            }
          }
        }
      }
    } catch (_) {}

    // Pastikan Mitra Bidan tidak pernah kosong bahkan ketika offline
    if (partnerBidans.isEmpty) {
      for (final item in _offlinePartnerBidans) {
        partnerBidans.add(item.withCalculatedDistance(userLat, userLng));
      }
    }

    // 2. Query Real-Time OpenStreetMap Overpass API untuk RS PONEK/IGD & Puskesmas di sekitar GPS pengguna
    final List<HealthcareFacilityItem> osmFacilities =
        await _fetchOpenStreetMapFacilities(
      userLat: userLat,
      userLng: userLng,
    );

    // 3. Gabungkan & Deduplikasi berdasarkan nama faskes
    final Map<String, HealthcareFacilityItem> uniqueMap = {};

    for (final b in partnerBidans) {
      uniqueMap[b.name.toLowerCase().trim()] = b;
    }

    for (final osm in osmFacilities) {
      final key = osm.name.toLowerCase().trim();
      if (!uniqueMap.containsKey(key)) {
        uniqueMap[key] = osm;
      }
    }

    // Tambahkan faskes rujukan terverifikasi dari backend jika belum ada di hasil OSM
    final fallbackRefs =
        backendReferrals.isNotEmpty ? backendReferrals : _offlineReferralHospitals;
    for (final refItem in fallbackRefs) {
      final withDist = refItem.withCalculatedDistance(userLat, userLng);
      final key = withDist.name.toLowerCase().trim();
      if (!uniqueMap.containsKey(key)) {
        uniqueMap[key] = withDist;
      }
    }

    final mergedList = uniqueMap.values.toList()
      ..sort(
        (a, b) => (a.distanceKm ?? 9999.0).compareTo(b.distanceKm ?? 9999.0),
      );

    return mergedList;
  }

  /// Query Geospasial ke OpenStreetMap Overpass API (Radius 8 KM dari GPS Pengguna)
  /// Dilengkapi filter kelayakan faskes maternal (mengecualikan klinik gigi/kecantikan/mata/hewan)
  Future<List<HealthcareFacilityItem>> _fetchOpenStreetMapFacilities({
    required double userLat,
    required double userLng,
  }) async {
    final overpassQuery = '''
[out:json][timeout:8];
(
  node["amenity"="hospital"](around:8000,$userLat,$userLng);
  way["amenity"="hospital"](around:8000,$userLat,$userLng);
  node["amenity"="clinic"](around:8000,$userLat,$userLng);
  way["amenity"="clinic"](around:8000,$userLat,$userLng);
  node["healthcare"~"hospital|clinic|midwife|birthing_center"](around:8000,$userLat,$userLng);
  way["healthcare"~"hospital|clinic|midwife|birthing_center"](around:8000,$userLat,$userLng);
);
out center body 60;
''';

    final endpoints = [
      'https://overpass-api.de/api/interpreter',
      'https://overpass.kumi.systems/api/interpreter',
    ];

    final externalDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 6),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

    for (final url in endpoints) {
      try {
        final response = await externalDio.post(
          url,
          data: {'data': overpassQuery},
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        );

        final data = response.data;
        if (data is Map<String, dynamic> && data['elements'] is List) {
          final elements = data['elements'] as List;
          final List<HealthcareFacilityItem> parsed = [];

          for (final raw in elements) {
            if (raw is! Map<String, dynamic>) continue;
            final tags = raw['tags'] as Map<String, dynamic>? ?? {};
            final name = (tags['name'] ?? tags['official_name'] ?? '')
                .toString()
                .trim();
            if (name.isEmpty) continue;
            if (!_isRelevantMaternalFacility(name, tags)) continue;

            double? lat = (raw['lat'] as num?)?.toDouble();
            double? lon = (raw['lon'] as num?)?.toDouble();
            if ((lat == null || lon == null) && raw['center'] is Map) {
              final center = raw['center'] as Map;
              lat = (center['lat'] as num?)?.toDouble();
              lon = (center['lon'] as num?)?.toDouble();
            }
            if (lat == null || lon == null) continue;

            final amenity = (tags['amenity'] ?? '').toString().toLowerCase();
            final healthcare =
                (tags['healthcare'] ?? '').toString().toLowerCase();
            final nameLower = name.toLowerCase();
            final isHospital = amenity == 'hospital' ||
                healthcare == 'hospital' ||
                nameLower.contains('rumah sakit') ||
                nameLower.startsWith('rs ') ||
                nameLower.startsWith('rsia ') ||
                nameLower.startsWith('rsud ') ||
                nameLower.startsWith('rsup ') ||
                nameLower.startsWith('rsu ') ||
                nameLower.startsWith('rskia ');

            final facilityType = isHospital ? 'rs_ponek' : 'puskesmas';
            final hasEmergency =
                (tags['emergency'] ?? '').toString().toLowerCase() == 'yes';
            final badge = isHospital
                ? (hasEmergency ? 'IGD RS 24 Jam' : 'Rumah Sakit')
                : (nameLower.contains('puskesmas')
                    ? 'Puskesmas'
                    : (nameLower.contains('bidan') ||
                            nameLower.contains('bersalin') ||
                            healthcare == 'midwife' ||
                            healthcare == 'birthing_center'
                        ? 'Klinik Bersalin / Bidan'
                        : 'Klinik Kesehatan'));

            final street = tags['addr:street']?.toString() ?? '';
            final houseNumber = tags['addr:housenumber']?.toString() ?? '';
            final fullAddr = tags['addr:full']?.toString() ?? '';
            final suburb = (tags['addr:suburb'] ??
                    tags['addr:district'] ??
                    tags['addr:village'] ??
                    '')
                .toString();
            final city = tags['addr:city']?.toString() ?? '';

            String addressLabel = fullAddr;
            if (addressLabel.isEmpty && street.isNotEmpty) {
              addressLabel = [
                '$street ${houseNumber.isNotEmpty ? "No. $houseNumber" : ""}'
                    .trim(),
                if (suburb.isNotEmpty) suburb,
                if (city.isNotEmpty) city,
              ].join(', ');
            } else if (addressLabel.isEmpty &&
                (suburb.isNotEmpty || city.isNotEmpty)) {
              addressLabel = [
                if (suburb.isNotEmpty) 'Kawasan $suburb',
                if (city.isNotEmpty) city,
              ].join(', ');
            }
            if (addressLabel.isEmpty) {
              addressLabel = 'Lihat titik lokasi dan rute di Google Maps';
            }

            final phone = (tags['phone'] ??
                    tags['contact:phone'] ??
                    tags['emergency:phone'])
                ?.toString();
            final openingHours = tags['opening_hours']?.toString();
            final hoursLabel = openingHours == '24/7' || isHospital
                ? 'Layanan IGD & Persalinan 24 Jam'
                : (openingHours != null && openingHours.isNotEmpty
                    ? 'Jam buka: $openingHours'
                    : 'Sesuai jam layanan fasilitas kesehatan');

            final dist = HealthcareFacilityItem.calculateHaversineKm(
              userLat,
              userLng,
              lat,
              lon,
            );

            parsed.add(
              HealthcareFacilityItem(
                id: 'osm_${raw['id']}',
                bidanId: null,
                name: name,
                facilityType: facilityType,
                isPartnerBidan: false,
                serviceBadge: badge,
                address: addressLabel,
                phone: phone,
                operatingHoursLabel: hoursLabel,
                notes: isHospital
                    ? 'Menerima pemeriksaan darurat kebidanan dan rujukan rumah sakit'
                    : 'Pemeriksaan kesehatan ibu hamil dan layanan dasar',
                latitude: lat,
                longitude: lon,
                distanceKm: dist,
                source: 'osm_overpass',
              ),
            );
          }

          if (parsed.isNotEmpty) {
            parsed.sort(
              (a, b) =>
                  (a.distanceKm ?? 9999.0).compareTo(b.distanceKm ?? 9999.0),
            );
            return parsed.take(15).toList();
          }
        }
      } catch (_) {
        // Lanjut ke mirror endpoint berikutnya atau fallback
      }
    }

    return const [];
  }

  /// Menyaring faskes OpenStreetMap agar hanya menampilkan Rumah Sakit, Puskesmas,
  /// Bidan, Klinik Bersalin, atau Klinik Umum (bukan klinik gigi/kecantikan/hewan/mata).
  bool _isRelevantMaternalFacility(String name, Map<String, dynamic> tags) {
    final lower = name.toLowerCase();
    final speciality =
        (tags['healthcare:speciality'] ?? '').toString().toLowerCase();

    const excludedKeywords = [
      'gigi',
      'dental',
      'dentist',
      'ortodont',
      'kecantikan',
      'estetika',
      'aesthetic',
      'skin',
      'beauty',
      'derma',
      'glow',
      'natasha',
      'erha',
      'zap',
      'mata',
      'eye',
      'optik',
      'lasik',
      'hewan',
      'vet',
      'pet ',
      'animal',
      'sunat',
      'khitan',
      'hemodialisa',
      'ginjal',
      'fisioterapi',
      'rehab',
      'tht',
      'kulit',
      'apotek',
      'farmasi',
    ];

    for (final kw in excludedKeywords) {
      if (lower.contains(kw) || speciality.contains(kw)) {
        return false;
      }
    }

    return true;
  }

  static const List<HealthcareFacilityItem> _offlinePartnerBidans = [
    HealthcareFacilityItem(
      id: 'db_partner_1',
      bidanId: 1,
      name: 'Bidan Rita, S.Tr.Keb (PMB Coblong)',
      facilityType: 'bidan_mitra',
      isPartnerBidan: true,
      serviceBadge: 'Bidan Mitra Prenava',
      address: 'Jl. Ir. H. Juanda No. 112, Lebakgede, Kec. Coblong, Kota Bandung',
      phone: '081234567890',
      operatingHoursLabel: 'Senin - Sabtu, 08.00 - 20.00 WIB (Persalinan 24 Jam)',
      notes: 'Pemeriksaan kehamilan (ANC), cek Hb, dan detak jantung janin',
      latitude: -6.889850,
      longitude: 107.613120,
      source: 'prenava_db',
    ),
    HealthcareFacilityItem(
      id: 'db_partner_2',
      bidanId: 2,
      name: 'Bidan Hj. Tati Karwati, S.ST., Bdn.',
      facilityType: 'bidan_mitra',
      isPartnerBidan: true,
      serviceBadge: 'Bidan Mitra Prenava',
      address: 'Jl. Buah Batu No. 184, Cijagra, Kec. Lengkong, Kota Bandung',
      phone: '081321987654',
      operatingHoursLabel: 'Setiap Hari, 07.30 - 21.00 WIB (Persalinan 24 Jam)',
      notes: 'Periksa kehamilan, konseling laktasi, dan rujukan PONED',
      latitude: -6.939420,
      longitude: 107.625610,
      source: 'prenava_db',
    ),
    HealthcareFacilityItem(
      id: 'db_partner_3',
      bidanId: 3,
      name: 'Bidan Siti Rahmawati, A.Md.Keb',
      facilityType: 'bidan_mitra',
      isPartnerBidan: true,
      serviceBadge: 'Bidan Mitra Prenava',
      address: 'Jl. Dr. Djunjunan No. 105, Pajajaran, Kec. Cicendo, Kota Bandung',
      phone: '081298761234',
      operatingHoursLabel: 'Senin - Sabtu, 08.00 - 19.00 WIB',
      notes: 'Konsultasi Buku KIA dan pemantauan Doppler detak jantung janin',
      latitude: -6.896240,
      longitude: 107.588450,
      source: 'prenava_db',
    ),
  ];

  static const List<HealthcareFacilityItem> _offlineReferralHospitals = [
    HealthcareFacilityItem(
      id: 'ref_9001',
      bidanId: null,
      name: 'RSUP Dr. Hasan Sadikin (RSHS) Bandung',
      facilityType: 'rs_ponek',
      isPartnerBidan: false,
      serviceBadge: 'IGD PONEK 24 Jam',
      address: 'Jl. Pasteur No. 38, Pasteur, Kec. Sukajadi, Kota Bandung',
      phone: '0222034953',
      operatingHoursLabel: 'IGD Kebidanan Buka 24 Jam',
      notes: 'Rumah sakit rujukan utama obstetri & neonatal (PONEK 24 Jam)',
      latitude: -6.898110,
      longitude: 107.598580,
      source: 'prenava_db',
    ),
    HealthcareFacilityItem(
      id: 'ref_9002',
      bidanId: null,
      name: 'RSIA Limijati Bandung',
      facilityType: 'rs_ponek',
      isPartnerBidan: false,
      serviceBadge: 'RS Ibu & Anak 24 Jam',
      address: 'Jl. LLRE Martadinata No. 39, Citarum, Kec. Bandung Wetan, Kota Bandung',
      phone: '0224207770',
      operatingHoursLabel: 'IGD Ibu & Anak Buka 24 Jam',
      notes: 'Layanan IGD maternal, persalinan, dan NICU 24 jam',
      latitude: -6.906556,
      longitude: 107.614333,
      source: 'prenava_db',
    ),
    HealthcareFacilityItem(
      id: 'ref_9003',
      bidanId: null,
      name: 'RSUD Bandung Kiwari',
      facilityType: 'rs_ponek',
      isPartnerBidan: false,
      serviceBadge: 'IGD RSUD 24 Jam',
      address: 'Jl. KH. Wahid Hasyim (Kopo) No. 311, Situsaeur, Kota Bandung',
      phone: '02286037777',
      operatingHoursLabel: 'IGD PONEK Buka 24 Jam',
      notes: 'RSUD rujukan ibu dan anak Kota Bandung (BPJS & Umum)',
      latitude: -6.942861,
      longitude: 107.595528,
      source: 'prenava_db',
    ),
    HealthcareFacilityItem(
      id: 'ref_9004',
      bidanId: null,
      name: 'UPTD Puskesmas Garuda',
      facilityType: 'puskesmas',
      isPartnerBidan: false,
      serviceBadge: 'Puskesmas PONED',
      address: 'Jl. Dadali No. 81, Garuda, Kec. Andir, Kota Bandung',
      phone: '0226013885',
      operatingHoursLabel: 'Persalinan PONED 24 Jam',
      notes: 'Puskesmas layanan persalinan & kegawatdaruratan dasar 24 jam',
      latitude: -6.912694,
      longitude: 107.575556,
      source: 'prenava_db',
    ),
  ];

  static const List<DangerCategoryItem> _fallbackDangerCatalog = [
    DangerCategoryItem(
      code: 'PERDARAHAN_ANTEPARTUM',
      label: 'Perdarahan Jalan Lahir (Antepartum)',
      kiaPageRef: 'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
      clinicalRisk:
          'Perdarahan pada masa kehamilan dapat menandakan gangguan plasenta yang berisiko mengurangi suplai oksigen ke janin.',
      recommendedAction:
          'Segera kunjungi Praktik Mandiri Bidan terdekat atau IGD Rumah Sakit PONEK untuk pemeriksaan kondisi plasenta dan detak jantung janin.',
      firstAidSteps: [
        'Berbaring miring ke sisi kiri tubuh untuk menjaga kelancaran aliran darah dan oksigen ke janin.',
        'Gunakan pembalut bersih untuk memantau volume darah dan jangan memasukkan benda apa pun ke jalan lahir.',
        'Jangan meminum obat atau jamu tanpa instruksi dokter, serta siapkan Buku KIA dan kartu identitas/BPJS.',
      ],
    ),
    DangerCategoryItem(
      code: 'PREEKLAMSIA_BERAT',
      label: 'Gejala Preeklamsia / Tekanan Darah Tinggi Kehamilan',
      kiaPageRef: 'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
      clinicalRisk:
          'Nyeri kepala hebat, pandangan kabur, atau bengkak mendadak merupakan tanda preeklamsia yang dapat berkembang menjadi kejang eklamsia bila tidak segera ditangani.',
      recommendedAction:
          'Segera periksakan tekanan darah dan protein urine di Puskesmas PONED, Klinik Bidan, atau IGD Rumah Sakit terdekat untuk pencegahan kejang eklamsia.',
      firstAidSteps: [
        'Istirahatkan ibu di ruangan yang tenang, redup, dan posisikan tubuh miring ke kiri.',
        'Longgarkan pakaian yang ketat dan pastikan jalur napas tetap lega.',
        'Minta pendamping keluarga segera mengantar ke fasilitas kesehatan tanpa menunda waktu.',
      ],
    ),
    DangerCategoryItem(
      code: 'KETUBAN_PECAH_DINI',
      label: 'Ketuban Pecah Dini (Cairan Merembes dari Jalan Lahir)',
      kiaPageRef: 'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
      clinicalRisk:
          'Keluarnya cairan ketuban sebelum waktunya meningkatkan risiko infeksi intrauterin pada janin serta memicu persalinan kurang bulan.',
      recommendedAction:
          'Segera menuju Praktik Mandiri Bidan atau IGD Rumah Sakit terdekat untuk pemeriksaan kertas lakmus, evaluasi air ketuban, dan pemantauan detak jantung janin.',
      firstAidSteps: [
        'Catat waktu pertama kali cairan keluar beserta warna dan baunya untuk dilaporkan kepada Bidan atau Dokter.',
        'Gunakan pembalut bersih dan jangan melakukan bilas vagina atau memasukkan apa pun ke jalan lahir.',
        'Kurangi aktivitas berjalan jauh dan berbaringlah selama perjalanan menuju fasilitas kesehatan.',
      ],
    ),
    DangerCategoryItem(
      code: 'GAWAT_JANIN',
      label: 'Penurunan Gerakan Janin (Risiko Gawat Janin)',
      kiaPageRef:
          'Buku KIA Kemenkes RI, Lembar Pemantauan Gerak Janin (Hal. 20 & 22)',
      clinicalRisk:
          'Gerakan janin yang berkurang drastis (kurang dari 10 kali dalam 12 jam) dapat mengindikasikan penurunan suplai oksigen melalui tali pusat atau plasenta.',
      recommendedAction:
          'Segera periksakan detak jantung janin menggunakan Doppler atau CTG di Praktik Mandiri Bidan atau IGD Rumah Sakit terdekat.',
      firstAidSteps: [
        'Berbaring miring ke kiri dan minum air putih atau minuman manis untuk merangsang respons gerak janin.',
        'Letakkan tangan di perut dan fokus menghitung gerakan janin sembari bersiap menuju fasilitas kesehatan.',
        'Bawa catatan penghitung gerakan janin (Kick Counter) dan Buku KIA untuk ditunjukkan kepada Bidan.',
      ],
    ),
    DangerCategoryItem(
      code: 'INFEKSI_AKUT_DEMAM',
      label: 'Demam Tinggi atau Menggigil Saat Hamil',
      kiaPageRef: 'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
      clinicalRisk:
          'Demam tinggi di atas 38 derajat Celsius pada ibu hamil meningkatkan risiko stres metabolik pada janin serta kontraksi persalinan dini.',
      recommendedAction:
          'Segera periksakan diri ke Puskesmas, Klinik Bidan, atau Rumah Sakit terdekat untuk mengetahui sumber infeksi dan mendapatkan penanganan medis yang aman bagi janin.',
      firstAidSteps: [
        'Minum air putih secara bertahap untuk mencegah dehidrasi akibat peningkatan suhu tubuh.',
        'Kompres hangat pada dahi atau lipatan ketiak dan kenakan pakaian yang tipis serta menyerap keringat.',
        'Jangan mengonsumsi antibiotik atau obat penurun panas di luar anjuran Bidan atau Dokter.',
      ],
    ),
    DangerCategoryItem(
      code: 'NYERI_PERUT_AKUT',
      label: 'Nyeri Perut Hebat atau Kontraksi Terus-Menerus',
      kiaPageRef: 'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
      clinicalRisk:
          'Nyeri perut hebat yang menetap atau perut terasa kaku terus-menerus dapat menandakan ancaman persalinan prematur atau pelepasan plasenta dini.',
      recommendedAction:
          'Segera datangi Praktik Mandiri Bidan atau IGD Rumah Sakit terdekat untuk evaluasi kontraksi rahim dan pemeriksaan kondisi plasenta.',
      firstAidSteps: [
        'Hentikan seluruh aktivitas fisik, berbaring miring ke kiri, dan atur pernapasan secara perlahan.',
        'Jangan mengurut atau menekan area perut maupun pinggang.',
        'Catat jeda waktu antar rasa kencang/mulas dan segera berangkat ke fasilitas kesehatan terdekat.',
      ],
    ),
  ];
}
