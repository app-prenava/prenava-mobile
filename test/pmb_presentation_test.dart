import 'package:flutter_test/flutter_test.dart';
import 'package:prenava_mobile/features/appointment/data/models/appointment_model.dart';
import 'package:prenava_mobile/features/appointment/data/models/bidan_profile_model.dart';
import 'package:prenava_mobile/features/appointment/domain/entities/bidan_profile.dart';

void main() {
  group('PMB Presentation & Model Tests', () {
    test('extracts PMB facility name and address detail correctly from formatted string', () {
      final bidan = BidanProfile(
        id: 1,
        locationId: 10,
        name: 'Bidan Rita Coblong, S.Tr.Keb',
        phone: '081234567890',
        address: 'PMB Bidan Rita Coblong (Jl. Ir. H. Juanda No. 112, Kec. Coblong, Kota Bandung)',
        latitude: -6.892,
        longitude: 107.615,
        operatingHoursLabel: 'Senin - Sabtu (08:00 - 20:00 WIB)',
      );

      expect(bidan.pmbFacilityName, equals('PMB Bidan Rita Coblong'));
      expect(bidan.pmbAddressDetail, equals('Jl. Ir. H. Juanda No. 112, Kec. Coblong, Kota Bandung'));
    });

    test('handles fallback when address does not have parentheses', () {
      final bidan = BidanProfile(
        id: 2,
        name: 'Bidan Tita, S.Tr.Keb',
        phone: '081234567891',
        address: 'Jl. Sukajadi No. 45, Bandung',
        latitude: -6.890,
        longitude: 107.600,
      );

      expect(bidan.pmbFacilityName, equals('PMB Bidan Tita, S.Tr.Keb'));
      expect(bidan.pmbAddressDetail, equals('Jl. Sukajadi No. 45, Bandung'));
    });

    test('parses BidanProfileModel correctly from backend JSON', () {
      final json = {
        'bidan_id': 6,
        'location_id': 1,
        'bidan_name': 'Bidan Rita',
        'address_label': 'PMB Bidan Rita (Jl. Terusan Buah Batu No. 120, Bandung)',
        'lat': -6.95,
        'lng': 107.63,
        'phone': '081234567890',
        'notes': 'Pemeriksaan kehamilan (ANC), cek Hb, dan detak jantung janin',
        'operating_hours_label': 'Senin - Sabtu (08:00 - 20:00 WIB)',
        'distance_km': 2.4,
        'service_badge': 'Mitra Resmi Prenava',
      };

      final model = BidanProfileModel.fromJson(json);

      expect(model.id, equals(6));
      expect(model.locationId, equals(1));
      expect(model.name, equals('Bidan Rita'));
      expect(model.pmbFacilityName, equals('PMB Bidan Rita'));
      expect(model.pmbAddressDetail, equals('Jl. Terusan Buah Batu No. 120, Bandung'));
      expect(model.operatingHoursLabel, equals('Senin - Sabtu (08:00 - 20:00 WIB)'));
      expect(model.distanceKm, equals(2.4));
      expect(model.serviceBadge, equals('Mitra Resmi Prenava'));
    });

    test('parses AppointmentModel safely from create appointment response without preferred_time', () {
      final json = {
        'appointment_id': 20,
        'status': 'requested',
        'bidan_name': 'Bidan Rita',
        'preferred_date': '2026-11-17',
        'consent_id': 12,
      };

      // Must not throw TypeError
      final appt = AppointmentModel.fromJson(json);

      expect(appt.id, equals(20));
      expect(appt.status, equals('requested'));
      expect(appt.preferredTime, equals('09:00'));
      expect(appt.preferredDate.year, equals(2026));
      expect(appt.preferredDate.month, equals(11));
      expect(appt.preferredDate.day, equals(17));
    });
  });
}
