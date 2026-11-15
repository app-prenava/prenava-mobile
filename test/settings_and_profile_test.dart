import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prenava_mobile/features/settings/presentation/pages/settings_page.dart';
import 'package:prenava_mobile/features/account/presentation/pages/account_page.dart';
import 'package:prenava_mobile/features/profile/presentation/pages/edit_profile_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'pref_reminder_hydration': true,
      'pref_reminder_anc': true,
      'pref_reminder_daily_task': true,
    });
  });

  group('SettingsPage Widget Tests', () {
    testWidgets('SettingsPage renders sections and switches cleanly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));

      // Check Header
      expect(find.text('Pengaturan & Keamanan'), findsOneWidget);
      expect(find.text('Keamanan Akun'), findsOneWidget);
      expect(find.text('Ubah Kata Sandi'), findsOneWidget);

      // Check Notification Preferences
      expect(find.text('Pengingat & Notifikasi'), findsOneWidget);
      expect(find.text('Pengingat Minum Air'), findsOneWidget);
      expect(find.text('Pengingat Kunjungan ANC & Bidan'), findsOneWidget);
      expect(find.text('Pengingat Misi Sehat Harian'), findsOneWidget);

      // Check switches
      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(3));

      // Toggle first switch
      await tester.tap(switches.first);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('pref_reminder_hydration'), false);

      // Check About & Legal section
      expect(find.text('Tentang & Bantuan'), findsOneWidget);
      expect(find.text('Syarat dan Ketentuan'), findsOneWidget);
      expect(find.text('Kebijakan Privasi Data Medis'), findsOneWidget);
      expect(find.text('Versi Aplikasi'), findsOneWidget);
      expect(find.text('v1.0.0+1'), findsOneWidget);

      // Test Dialog opening
      await tester.tap(find.text('Syarat dan Ketentuan'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Mengerti'), findsOneWidget);
      await tester.tap(find.text('Mengerti'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));
    });
  });

  group('AccountPage Tests (Anti-Slop & Dead Button Removal)', () {
    testWidgets('AccountPage renders clinical sections and no dead ecommerce buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AccountPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify page title
      expect(find.text('Profil & Akun'), findsOneWidget);

      // Verify structured clinical sections
      expect(find.text('Layanan Medis & Aktivitas'), findsOneWidget);
      expect(find.text('Data Pribadi & Profil'), findsOneWidget);
      expect(find.text('Dompet & Poin Sehat'), findsOneWidget);
      expect(find.text('Buku KIA & Catatan Ibu'), findsOneWidget);

      expect(find.text('Pengaturan & Dukungan'), findsOneWidget);
      expect(find.text('Pengaturan & Keamanan'), findsOneWidget);
      expect(find.text('Pusat Bantuan & Panduan'), findsOneWidget);
      expect(find.text('Keluar Akun'), findsOneWidget);

      // Verify ZERO dead ecommerce slop buttons
      expect(find.text('Favorit'), findsNothing);
      expect(find.text('Pesanan'), findsNothing);
      expect(find.text('Personalisasi'), findsNothing);
      expect(find.text('Share shop'), findsNothing);
      expect(find.text('Mode liburan'), findsNothing);
    });
  });

  group('EditProfilePage Tests (Full 11 Demography & Clinical Fields)', () {
    testWidgets('EditProfilePage renders all 11 fields and save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditProfilePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify Page Title
      expect(find.text('Edit Data Pribadi'), findsOneWidget);

      // Verify Section Cards
      expect(find.text('Data Medis & Kehamilan'), findsOneWidget);
      expect(find.text('Domisili & Kontak'), findsOneWidget);
      expect(find.text('Informasi Sosial & Ekonomi'), findsOneWidget);

      // Verify Fields exist
      expect(find.text('Tanggal Lahir *'), findsOneWidget);
      expect(find.text('Usia (Tahun)'), findsOneWidget);
      expect(find.text('Status Kandungan'), findsOneWidget);
      expect(find.text('Golongan Darah'), findsOneWidget);

      expect(find.text('Alamat Lengkap'), findsOneWidget);
      expect(find.text('Provinsi'), findsOneWidget);
      expect(find.text('Kota / Kabupaten'), findsOneWidget);
      expect(find.text('Kecamatan'), findsOneWidget);
      expect(find.text('Nomor Telepon / WhatsApp'), findsOneWidget);

      expect(find.text('Pendidikan Terakhir'), findsOneWidget);
      expect(find.text('Pekerjaan'), findsOneWidget);
      expect(find.text('Pendapatan Keluarga per Bulan'), findsOneWidget);

      // Verify Submit Button
      expect(find.text('Simpan Perubahan Profil'), findsOneWidget);
    });
  });
}
