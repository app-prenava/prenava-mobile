import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_providers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Data Pribadi'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF424242),
        elevation: 0,
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : !profileState.hasProfile
              ? _buildNoProfileCard(context)
              : _buildProfileContent(context, profileState.profile!),
    );
  }

  Widget _buildNoProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        color: const Color(0xFFFFF3F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_add,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF424242),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lengkapi data pribadi Anda untuk pengalaman yang lebih baik',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.push('/edit-profile');
                    // Refresh profile after returning from edit page
                    ref.read(profileNotifierProvider.notifier).loadProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6978),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Isi Profil Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildProfileContent(BuildContext context, profile) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Photo Section
            _buildPhotoSection(profile.photoUrl),
            const SizedBox(height: 32),
            
            // Profile Details
            _buildProfileDetails(profile),
            const SizedBox(height: 32),
            
            // Edit Button
            SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await context.push('/edit-profile');
                // Refresh profile after returning from edit page
                if (context.mounted) {
                  ref.read(profileNotifierProvider.notifier).loadProfile();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA6978),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Edit Profil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(String? photoUrl) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 58,
            backgroundColor: const Color(0xFFB8E6F0),
            backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                ? NetworkImage(photoUrl)
                : null,
            child: (photoUrl == null || photoUrl.isEmpty)
                ? Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[700],
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Foto Profil',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        if (photoUrl == null || photoUrl.isEmpty)
          Text(
            'Belum ada foto profil',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
      ],
    );
  }

  Widget _buildProfileDetails(profile) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Pribadi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Tanggal Lahir', profile.tanggalLahir ?? '-'),
            _buildInfoRow('Usia', profile.usia != null ? '${profile.usia} tahun' : '-'),
            _buildInfoRow('Alamat', profile.alamat ?? '-'),
            _buildInfoRow('No. Telepon', profile.noTelepon ?? '-'),
            _buildInfoRow('Pendidikan Terakhir', profile.pendidikanTerakhir ?? '-'),
            _buildInfoRow('Pekerjaan', profile.pekerjaan ?? '-'),
            _buildInfoRow('Golongan Darah', profile.golonganDarah ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
