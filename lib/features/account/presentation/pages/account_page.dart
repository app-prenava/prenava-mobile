import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
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
            children: [
              const SizedBox(height: 8),
              _buildUserProfileCard(context, user, profileState),
              const SizedBox(height: 16),
              _buildMenuCard1(context, ref, currencyFormat, walletState),
              const SizedBox(height: 16),
              _buildMenuCard2(context, ref),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context, dynamic user, ProfileState profileState) {
    return GestureDetector(
      onTap: () => context.push('/profile'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFF0F0F0),
              backgroundImage: (profileState.profile?.photoUrl != null &&
                      profileState.profile!.photoUrl!.isNotEmpty)
                  ? NetworkImage(profileState.profile!.photoUrl!)
                  : null,
              child: (profileState.profile?.photoUrl == null ||
                      profileState.profile!.photoUrl!.isEmpty)
                  ? Icon(Icons.person, size: 30, color: Colors.grey[400])
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Pengguna',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lihat profil',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }


  Widget _buildMenuCard1(BuildContext context, WidgetRef ref, NumberFormat format, WalletState walletState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildListItem(
            icon: Icons.favorite_outline,
            title: 'Favorit',
            onTap: () {},
          ),
          Divider(height: 1, indent: 48, color: Colors.grey[100]),
          _buildListItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Wallet',
            trailingText: format.format(walletState.balance),
            onTap: () => context.push('/wallet'),
          ),
          Divider(height: 1, indent: 48, color: Colors.grey[100]),
          _buildListItem(
            icon: Icons.receipt_long_outlined,
            title: 'Pesanan',
            onTap: () {},
          ),
          Divider(height: 1, indent: 48, color: Colors.grey[100]),
          _buildListItem(
            icon: Icons.help_outline,
            title: 'Help Desk',
            onTap: () => _showHelpDeskBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard2(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildListItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
          ),
          Divider(height: 1, indent: 48, color: Colors.grey[100]),
          _buildListItem(
            icon: Icons.tune,
            title: 'Personalisasi',
            onTap: () {},
          ),
          Divider(height: 1, indent: 48, color: Colors.grey[100]),
          _buildListItem(
            icon: Icons.share_outlined,
            title: 'Share shop',
            onTap: () {},
          ),
          Divider(height: 1, indent: 48, color: Colors.grey[100]),
          _buildListItem(
            icon: Icons.wb_sunny_outlined,
            title: 'Mode liburan',
            trailingWidget: Switch(
              value: false,
              onChanged: (val) {},
              activeThumbColor: const Color(0xFFFA6978),
            ),
            onTap: () {},
          ),
          Divider(height: 1, indent: 48, color: Colors.grey[100]),
          _buildListItem(
            icon: Icons.logout,
            title: 'Log Out',
            titleColor: Colors.red,
            iconColor: Colors.red,
            hideChevron: true,
            onTap: () async {
              ref.read(profileNotifierProvider.notifier).clearProfile();
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    Widget? trailingWidget,
    Color? titleColor,
    Color? iconColor,
    bool hideChevron = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[700], size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor ?? Colors.black87,
        ),
      ),
      trailing: trailingWidget ??
          (hideChevron
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (trailingText != null)
                      Text(
                        trailingText,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    if (trailingText != null) const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
                  ],
                )),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
    );
  }

  void _showHelpDeskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
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
                'Help Desk',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Panduan fitur-fitur di aplikasi Prenava',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[200]),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHelpItem(
                      icon: Icons.local_fire_department,
                      color: Colors.amber,
                      title: 'Misi Harian & Streak',
                      description: 'Selesaikan misi harian untuk menjaga streak dan mendapatkan poin.',
                    ),
                    _buildHelpItem(
                      icon: Icons.accessibility_new,
                      color: Colors.blue,
                      title: 'Rekomendasi Olahraga',
                      description: 'Gerakan senam hamil dan yoga yang aman sesuai usia kandungan.',
                    ),
                    _buildHelpItem(
                      icon: Icons.face,
                      color: Colors.purple,
                      title: 'Prediksi Depresi',
                      description: 'Skrining risiko depresi pasca melahirkan melalui analisis wajah AI.',
                    ),
                    _buildHelpItem(
                      icon: Icons.bloodtype,
                      color: Colors.red,
                      title: 'Prediksi Anemia',
                      description: 'Observasi dini gejala anemia pada ibu hamil.',
                    ),
                    _buildHelpItem(
                      icon: Icons.child_care,
                      color: Colors.green,
                      title: 'Risiko Stunting',
                      description: 'Cek potensi stunting pada anak dan dapatkan rekomendasi asupan gizinya.',
                    ),
                    _buildHelpItem(
                      icon: Icons.water_drop,
                      color: Colors.lightBlue,
                      title: 'Rekomendasi Hidrasi',
                      description: 'Pantau jumlah air minum harian agar tubuh tetap terhidrasi.',
                    ),
                    _buildHelpItem(
                      icon: Icons.calendar_month,
                      color: Colors.teal,
                      title: 'Kalkulator HPL',
                      description: 'Hitung Hari Perkiraan Lahir dan pantau perkembangan janin setiap minggu.',
                    ),
                    _buildHelpItem(
                      icon: Icons.shopping_bag,
                      color: Colors.orange,
                      title: 'Belanja & Jual',
                      description: 'Marketplace untuk kebutuhan ibu hamil, bayi, dan preloved items.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka WhatsApp Support...')),
                      );
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text(
                      'Hubungi Support',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
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

