import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _reminderHydration = true;
  bool _reminderAnc = true;
  bool _reminderDailyTask = true;
  bool _isLoadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reminderHydration = prefs.getBool('pref_reminder_hydration') ?? true;
      _reminderAnc = prefs.getBool('pref_reminder_anc') ?? true;
      _reminderDailyTask = prefs.getBool('pref_reminder_daily_task') ?? true;
      _isLoadingPrefs = false;
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pengaturan & Keamanan',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: _isLoadingPrefs
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFA6978)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Keamanan Akun'),
                  const SizedBox(height: 8),
                  _buildSecurityCard(context),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Pengingat & Notifikasi'),
                  const SizedBox(height: 8),
                  _buildNotificationCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Tentang & Bantuan'),
                  const SizedBox(height: 8),
                  _buildAboutCard(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF475569),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildSecurityCard(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.lock_outline, color: Color(0xFFFA6978), size: 22),
        ),
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        subtitle: const Text(
          'Perbarui kata sandi akun untuk keamanan akses data medis Anda',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
        onTap: () => context.push('/change-password'),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: _reminderHydration,
            activeColor: const Color(0xFFFA6978),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.water_drop_outlined, color: Color(0xFF0284C7), size: 22),
            ),
            title: const Text(
              'Pengingat Minum Air',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            subtitle: const Text(
              'Pengingat hidrasi harian untuk menjaga cairan tubuh ibu dan janin',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            onChanged: (val) {
              setState(() => _reminderHydration = val);
              _updatePreference('pref_reminder_hydration', val);
            },
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          SwitchListTile(
            value: _reminderAnc,
            activeColor: const Color(0xFFFA6978),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_month_outlined, color: Color(0xFF059669), size: 22),
            ),
            title: const Text(
              'Pengingat Kunjungan ANC & Bidan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            subtitle: const Text(
              'Notifikasi jadwal periksa kehamilan berkala dan janji temu bidan',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            onChanged: (val) {
              setState(() => _reminderAnc = val);
              _updatePreference('pref_reminder_anc', val);
            },
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          SwitchListTile(
            value: _reminderDailyTask,
            activeColor: const Color(0xFFFA6978),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flag_outlined, color: Color(0xFFD97706), size: 22),
            ),
            title: const Text(
              'Pengingat Misi Sehat Harian',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            subtitle: const Text(
              'Pengingat menyelesaikan target gizi harian dan mengumpulkan poin',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            onChanged: (val) {
              setState(() => _reminderDailyTask = val);
              _updatePreference('pref_reminder_daily_task', val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.description_outlined, color: Color(0xFF475569), size: 22),
            ),
            title: const Text(
              'Syarat dan Ketentuan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            subtitle: const Text(
              'Ketentuan dan panduan pemanfaatan layanan Prenava',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
            onTap: () => _showTermsDialog(context),
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF475569), size: 22),
            ),
            title: const Text(
              'Kebijakan Privasi Data Medis',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            subtitle: const Text(
              'Perlindungan dan kerahasiaan rekam medis ibu hamil',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
            onTap: () => _showPrivacyDialog(context),
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.info_outline, color: Color(0xFF475569), size: 22),
            ),
            title: const Text(
              'Versi Aplikasi',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            subtitle: const Text(
              'Prenava Maternal AI CDSS Suite',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'v1.0.0+1',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Syarat dan Ketentuan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. Prenava menyediakan pemantauan kesehatan mandiri dan asisten edukasi kehamilan berbasis Buku KIA Kemenkes RI.\n\n'
            '2. Hasil skrining kecerdasan buatan (triase maternal, deteksi anemia, dan stunting) berfungsi sebagai panduan pendukung keputusan dan tidak menggantikan diagnosis resmi tenaga medis profesional.\n\n'
            '3. Jika muncul tanda bahaya seperti perdarahan pervaginam, kejang, atau sakit kepala hebat, segera kunjungi fasilitas kesehatan atau hubungi Bidan terdekat.\n\n'
            '4. Pengguna bertanggung jawab menjaga kerahasiaan kata sandi akun masing-masing.',
            style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Mengerti',
              style: TextStyle(color: Color(0xFFFA6978), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Kebijakan Privasi Medis',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. Kerahasiaan Data: Seluruh data rekam medis ibu hamil disimpan terenkripsi dan hanya dapat diakses oleh Anda serta Bidan yang telah Anda berikan izin pemantauan.\n\n'
            '2. Pemrosesan AI: Citra dan parameter kehamilan yang dianalisis oleh modul AI diproses melalui jalur gateway internal yang aman tanpa membagikan identitas pribadi kepada pihak ketiga.\n\n'
            '3. Hak Pengguna: Anda berhak memperbarui data profil kapan saja melalui menu Edit Profil di aplikasi Prenava.',
            style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFFFA6978), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
