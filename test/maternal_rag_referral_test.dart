import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prenava_mobile/features/maternal_rag/data/datasources/maternal_rag_remote_datasource.dart';
import 'package:prenava_mobile/features/maternal_rag/data/models/maternal_rag_model.dart';
import 'package:prenava_mobile/features/maternal_rag/presentation/pages/maternal_voice_consultation_page.dart';
import 'package:prenava_mobile/features/maternal_rag/presentation/providers/maternal_rag_providers.dart';

class _FakeMaternalRagDatasource extends MaternalRagRemoteDatasource {
  _FakeMaternalRagDatasource() : super(Dio());

  @override
  Future<List<MaternalConsultationItem>> getHistory() async {
    return [
      MaternalConsultationItem(
        id: 101,
        query: 'Keluar bercak atau darah segar dari jalan lahir',
        aiAnswer:
            '**Perhatian Klinis: Indikasi Perdarahan Jalan Lahir (Antepartum)**',
        referenceSource:
            'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
        providerUsed: 'circuit_breaker',
        isEmergency: true,
        dangerLevel: 'EMERGENCY',
        dangerKeywords: const ['darah segar', 'keluar darah'],
        recommendedAction:
            'Segera kunjungi Praktik Mandiri Bidan terdekat atau IGD Rumah Sakit PONEK untuk pemeriksaan kondisi plasenta dan detak jantung janin.',
        clinicalRisk:
            'Perdarahan pada masa kehamilan dapat menandakan gangguan plasenta yang berisiko mengurangi suplai oksigen ke janin.',
        kiaPageRef:
            'Buku KIA Kemenkes RI, Lembar Tanda Bahaya Kehamilan (Hal. 22)',
        firstAidSteps: const [
          'Berbaring miring ke sisi kiri tubuh untuk menjaga kelancaran aliran darah dan oksigen ke janin.',
          'Gunakan pembalut bersih untuk memantau volume darah dan jangan memasukkan benda apa pun ke jalan lahir.',
          'Jangan meminum obat atau jamu tanpa instruksi dokter, serta siapkan Buku KIA dan kartu identitas/BPJS.',
        ],
        facilityRecommendation:
            'IGD Rumah Sakit PONEK 24 Jam atau Praktik Mandiri Bidan Terdekat',
        createdAt: DateTime(2026, 11, 9, 15, 0),
      ),
    ];
  }

  @override
  Future<List<DangerCategoryItem>> getDangerCatalog() async {
    return const [
      DangerCategoryItem(
        code: 'PERDARAHAN_ANTEPARTUM',
        label: 'Perdarahan Jalan Lahir (Antepartum)',
        recommendedAction: 'Segera kunjungi Praktik Mandiri Bidan terdekat.',
      ),
    ];
  }

  @override
  Future<List<HealthcareFacilityItem>> getNearbyHealthcareFacilities({
    required double userLat,
    required double userLng,
  }) async {
    return [
      const HealthcareFacilityItem(
        id: 'db_1',
        bidanId: 1,
        name: 'Bidan Rita, S.Tr.Keb (PMB Coblong)',
        facilityType: 'bidan_mitra',
        isPartnerBidan: true,
        serviceBadge: 'Bidan Mitra Prenava',
        address:
            'Jl. Ir. H. Juanda No. 112, Lebakgede, Kec. Coblong, Kota Bandung',
        phone: '081234567890',
        operatingHoursLabel:
            'Senin - Sabtu, 08.00 - 20.00 WIB (Persalinan 24 Jam)',
        latitude: -6.889850,
        longitude: 107.613120,
        distanceKm: 1.2,
      ),
      const HealthcareFacilityItem(
        id: 'osm_9001',
        bidanId: null,
        name: 'RSUP Dr. Hasan Sadikin (RSHS) Bandung',
        facilityType: 'rs_ponek',
        isPartnerBidan: false,
        serviceBadge: 'IGD PONEK 24 Jam',
        address: 'Jl. Pasteur No. 38, Pasteur, Kec. Sukajadi, Kota Bandung',
        phone: '0222034953',
        operatingHoursLabel: 'IGD Kebidanan Buka 24 Jam',
        latitude: -6.898110,
        longitude: 107.598580,
        distanceKm: 2.4,
        source: 'osm_overpass',
      ),
    ];
  }
}

void main() {
  test(
    'Perhitungan jarak Haversine, query Google Maps akurat, dan model rujukan tanda bahaya berfungsi',
    () {
      final dist = HealthcareFacilityItem.calculateHaversineKm(
        -6.9175,
        107.6191,
        -6.889850,
        107.613120,
      );
      expect(dist, greaterThan(2.5));
      expect(dist, lessThan(3.5));

      const hospital = HealthcareFacilityItem(
        id: 'osm_9001',
        name: 'RSUP Dr. Hasan Sadikin (RSHS) Bandung',
        facilityType: 'rs_ponek',
        isPartnerBidan: false,
        serviceBadge: 'IGD PONEK 24 Jam',
        address: 'Jl. Pasteur No. 38, Pasteur, Kec. Sukajadi, Kota Bandung',
        operatingHoursLabel: 'IGD Kebidanan Buka 24 Jam',
        latitude: -6.898110,
        longitude: 107.598580,
      );

      // Saat GPS aplikasi belum aktif, jangan kirim origin palsu agar Google Maps memakai posisi live HP
      final uriWithoutGps = hospital.buildGoogleMapsDirectionsUri(
        userLat: -6.9175,
        userLng: 107.6191,
        isUsingGpsLocation: false,
      );
      expect(uriWithoutGps.queryParameters.containsKey('origin'), isFalse);
      expect(
        uriWithoutGps.queryParameters['destination'],
        contains('RSUP Dr. Hasan Sadikin'),
      );
      expect(
        uriWithoutGps.queryParameters['destination'],
        contains('Jl. Pasteur No. 38'),
      );

      // Saat GPS perangkat aktif, sertakan origin
      final uriWithGps = hospital.buildGoogleMapsDirectionsUri(
        userLat: -6.9001,
        userLng: 107.6002,
        isUsingGpsLocation: true,
      );
      expect(uriWithGps.queryParameters['origin'], '-6.9001,107.6002');

      final item = MaternalConsultationItem.fromJson({
        'id': 1,
        'query': 'Keluar darah segar',
        'ai_answer': 'Segera ke faskes',
        'is_emergency': true,
        'danger_level': 'EMERGENCY',
        'danger_keywords': ['darah segar'],
        'clinical_risk': 'Risiko gangguan plasenta',
        'first_aid_steps': ['Berbaring miring ke kiri'],
      });
      expect(item.isEmergency, isTrue);
      expect(item.effectiveFirstAidSteps.first, contains('miring ke kiri'));
      expect(item.effectiveClinicalRisk, contains('plasenta'));
    },
  );

  testWidgets(
    'MaternalVoiceConsultationPage merender Panduan Rujukan Tanda Bahaya dan Faskes Terdekat beserta filter tab',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            maternalRagDatasourceProvider.overrideWithValue(
              _FakeMaternalRagDatasource(),
            ),
          ],
          child: const MaterialApp(
            home: MaternalVoiceConsultationPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verifikasi teks tanda bahaya & langkah awal sebelum berangkat tampil
      expect(
        find.text('Panduan Rujukan Tanda Bahaya'),
        findsOneWidget,
      );
      expect(
        find.text('Langkah Awal Sebelum Berangkat ke Faskes:'),
        findsOneWidget,
      );

      // Verifikasi daftar faskes terdekat (Bidan Mitra & IGD RS PONEK) tampil langsung di halaman
      expect(
        find.text('Bidan Rita, S.Tr.Keb (PMB Coblong)'),
        findsOneWidget,
      );
      expect(
        find.text('RSUP Dr. Hasan Sadikin (RSHS) Bandung'),
        findsOneWidget,
      );
      expect(find.text('Buat Janji Bidan'), findsOneWidget);
      expect(find.text('Rute ke IGD / Faskes'), findsOneWidget);

      // Uji interaksi klik filter tab "Bidan Mitra Prenava"
      final bidanFilter = find.textContaining('Bidan Mitra Prenava (1)');
      await tester.ensureVisible(bidanFilter);
      await tester.pumpAndSettle();
      await tester.tap(bidanFilter);
      await tester.pumpAndSettle();
      expect(
        find.text('Bidan Rita, S.Tr.Keb (PMB Coblong)'),
        findsOneWidget,
      );
      expect(
        find.text('RSUP Dr. Hasan Sadikin (RSHS) Bandung'),
        findsNothing,
      );

      // Uji interaksi klik filter tab "IGD RS & Puskesmas"
      final rsFilter = find.textContaining('IGD RS & Puskesmas (1)');
      await tester.ensureVisible(rsFilter);
      await tester.pumpAndSettle();
      await tester.tap(rsFilter);
      await tester.pumpAndSettle();
      expect(
        find.text('RSUP Dr. Hasan Sadikin (RSHS) Bandung'),
        findsOneWidget,
      );

      // Uji pembukaan modal Lembar Tanda Bahaya Buku KIA
      await tester.tap(find.text('Panduan KIA'));
      await tester.pumpAndSettle();
      expect(find.text('Lembar Tanda Bahaya Kehamilan'), findsOneWidget);
    },
  );
}
