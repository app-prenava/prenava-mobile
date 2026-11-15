import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../home/presentation/providers/wallet_provider.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final profileState = ref.watch(profileNotifierProvider);
    final walletState = ref.watch(walletProvider);

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil & Akun',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildUserProfileCard(context, user, profileState),
              const SizedBox(height: 24),
              _buildSectionHeader('Layanan Medis & Aktivitas'),
              const SizedBox(height: 8),
              _buildMedicalServicesCard(context, currencyFormat, walletState),
              const SizedBox(height: 24),
              _buildSectionHeader('Pengaturan & Dukungan'),
              const SizedBox(height: 8),
              _buildSettingsAndSupportCard(context, ref),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF475569),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context, dynamic user, ProfileState profileState) {
    final statusKandungan = profileState.profile?.statusKandungan;
    final subtext = (statusKandungan != null && statusKandungan.isNotEmpty)
        ? 'Status: $statusKandungan'
        : 'Ketuk untuk melihat dan mengedit data pribadi';

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: () => context.push('/profile'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFFFF1F2),
                backgroundImage: (profileState.profile?.photoUrl != null &&
                        profileState.profile!.photoUrl!.isNotEmpty)
                    ? NetworkImage(profileState.profile!.photoUrl!)
                    : null,
                child: (profileState.profile?.photoUrl == null ||
                        profileState.profile!.photoUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 34, color: Color(0xFFFA6978))
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Pengguna Prenava',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtext,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalServicesCard(BuildContext context, NumberFormat format, WalletState walletState) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildListItem(
            icon: Icons.person_outline,
            iconColor: const Color(0xFFFA6978),
            iconBgColor: const Color(0xFFFFF1F2),
            title: 'Data Pribadi & Profil',
            subtitle: 'Informasi demografi, domisili, dan golongan darah',
            onTap: () => context.push('/profile'),
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          _buildListItem(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFFD97706),
            iconBgColor: const Color(0xFFFEF3C7),
            title: 'Dompet & Poin Sehat',
            subtitle: 'Koin reward penyelesaian misi hidrasi dan gizi',
            trailingText: format.format(walletState.balance),
            onTap: () => context.push('/wallet'),
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          _buildListItem(
            icon: Icons.book_outlined,
            iconColor: const Color(0xFF0284C7),
            iconBgColor: const Color(0xFFE0F2FE),
            title: 'Buku KIA & Catatan Ibu',
            subtitle: 'Riwayat rekam medis kunjungan pemeriksaan kehamilan',
            onTap: () => context.push('/kunjungan'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsAndSupportCard(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildListItem(
            icon: Icons.settings_outlined,
            iconColor: const Color(0xFF475569),
            iconBgColor: const Color(0xFFF1F5F9),
            title: 'Pengaturan & Keamanan',
            subtitle: 'Ubah kata sandi dan preferensi pengingat',
            onTap: () => context.push('/settings'),
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          _buildListItem(
            icon: Icons.help_outline,
            iconColor: const Color(0xFF059669),
            iconBgColor: const Color(0xFFECFDF5),
            title: 'Pusat Bantuan & Panduan',
            subtitle: 'Informasi fitur klinis dan kontak tim support',
            onTap: () => _showHelpDeskBottomSheet(context),
          ),
          const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
          _buildListItem(
            icon: Icons.logout,
            iconColor: const Color(0xFFDC2626),
            iconBgColor: const Color(0xFFFEF2F2),
            title: 'Keluar Akun',
            subtitle: 'Akhiri sesi aktif di perangkat ini',
            titleColor: const Color(0xFFDC2626),
            hideChevron: true,
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    String? trailingText,
    Color? titleColor,
    Color? iconColor,
    Color? iconBgColor,
    bool hideChevron = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor ?? const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? const Color(0xFF475569), size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? const Color(0xFF0F172A),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            )
          : null,
      trailing: hideChevron
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (trailingText != null)
                  Text(
                    trailingText,
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                if (trailingText != null) const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
              ],
            ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun Prenava? Anda dapat masuk kembali kapan saja.',
          style: TextStyle(fontSize: 14, color: Color(0xFF334155)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              ref.read(profileNotifierProvider.notifier).clearProfile();
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDeskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pusat Bantuan Prenava',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Panduan fitur pemantauan kesehatan ibu hamil',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHelpItem(
                      icon: Icons.support_agent,
                      color: const Color(0xFFFA6978),
                      title: 'Tanya Bidan AI (Voice RAG)',
                      description: 'Konsultasi keluhan kehamilan via suara atau teks dengan panduan Buku KIA Kemenkes.',
                    ),
                    _buildHelpItem(
                      icon: Icons.camera_alt,
                      color: const Color(0xFF0284C7),
                      title: 'Food Vision Isi Piringku',
                      description: 'Foto piring makanan Anda untuk menganalisis kecukupan gizi dan zat besi.',
                    ),
                    _buildHelpItem(
                      icon: Icons.bloodtype,
                      color: const Color(0xFFDC2626),
                      title: 'Skrining Anemia Konjungtiva',
                      description: 'Observasi dini risiko anemia melalui foto kelopak mata bawah.',
                    ),
                    _buildHelpItem(
                      icon: Icons.child_care,
                      color: const Color(0xFF059669),
                      title: 'Skrining Risiko Stunting',
                      description: 'Pemeriksaan faktor risiko maternal untuk mencegah kejadian stunting sejak masa kehamilan.',
                    ),
                    _buildHelpItem(
                      icon: Icons.water_drop,
                      color: const Color(0xFF0284C7),
                      title: 'Target Hidrasi Harian',
                      description: 'Pencatatan konsumsi air minum untuk menjaga cairan tubuh optimal.',
                    ),
                    _buildHelpItem(
                      icon: Icons.local_fire_department,
                      color: const Color(0xFFD97706),
                      title: 'Misi Sehat & Poin Reward',
                      description: 'Kumpulkan poin dengan menyelesaikan target aktivitas harian.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      final Uri whatsappUri = Uri.parse(
                        'https://wa.me/6281234567890?text=Halo%20Tim%20Support%20Prenava%2C%20saya%20memerlukan%20bantuan%20terkait%20aplikasi.',
                      );
                      if (await canLaunchUrl(whatsappUri)) {
                        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tidak dapat membuka WhatsApp. Silakan hubungi 0812-3456-7890.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.support_agent, size: 20),
                    label: const Text(
                      'Hubungi WhatsApp Support',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFA6978),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
