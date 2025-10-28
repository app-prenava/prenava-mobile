import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context, profileState),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  _buildProfileHeader(user?.name ?? 'User', user?.email ?? ''),
                  const SizedBox(height: 32),
                  _buildDataSection(context, ref, profileState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileState profileState) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 200,
            color: const Color(0xFFFA6978),
            child: const SafeArea(
              child: Center(
                child: Text(
                  'Data Pengguna',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -60,
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: const Color(0xFFB8E6F0),
                backgroundImage: (profileState.profile?.photoUrl != null && 
                                 profileState.profile!.photoUrl!.isNotEmpty)
                    ? NetworkImage(profileState.profile!.photoUrl!)
                    : null,
                child: (profileState.profile?.photoUrl == null || 
                        profileState.profile!.photoUrl!.isEmpty)
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[700],
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context, WidgetRef ref, ProfileState profileState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Data Pribadi',
          subtitle: profileState.hasProfile ? 'Profil lengkap tersedia' : 'Belum ada profil',
          onTap: () => context.push('/profile'),
        ),
        _buildMenuItem(
          icon: Icons.people_outline,
          title: 'Data Suami',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.key_outlined,
          title: 'Reset Password',
          onTap: () => context.push('/change-password'),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () async {
              // Clear profile state before logout
              ref.read(profileNotifierProvider.notifier).clearProfile();
              
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Row(
              children: [
                const Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 16),
                const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF424242),
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF424242),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}

// Custom Clipper for Wave Effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    // Create smooth wave with quadratic bezier curves
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 60,
      size.width / 2,
      size.height - 40,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - 20,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

