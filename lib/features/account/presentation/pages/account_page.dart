import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFFFE8EC),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profil',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Bantuan',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'Tentang',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Keluar',
                iconColor: Colors.red,
                titleColor: Colors.red,
                onTap: () async {
                  await ref.read(authNotifierProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? const Color(0xFFFC7286),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor ?? const Color(0xFF424242),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}

