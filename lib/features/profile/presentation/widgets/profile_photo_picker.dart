import 'dart:io';
import 'package:flutter/material.dart';

class ProfilePhotoPicker extends StatelessWidget {
  final String? photoUrl;
  final File? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback? onDeletePhoto;

  const ProfilePhotoPicker({
    super.key,
    this.photoUrl,
    this.selectedImage,
    required this.onPickImage,
    this.onDeletePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFB8E6F0),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _buildPhoto(),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFA6978),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (photoUrl != null && selectedImage == null) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onDeletePhoto,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Hapus Foto'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhoto() {
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Image.network(
        photoUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else {
      return _placeholder();
    }
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}

