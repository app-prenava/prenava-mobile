import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/community_providers.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _categories = const [
    'Parenting',
    'Finansial & Keuangan',
    'Nutrisi',
    'Kesehatan',
    'Lainnya',
  ];
  String? _selectedCategory;
  bool _isSubmitting = false;

  static const int _maxContentLength = 1500;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _contentController.text.trim().isNotEmpty && !_isSubmitting;

  Future<void> _submitPost() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    final title = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : (_selectedCategory ?? 'Lainnya');

    final success =
        await ref.read(communityNotifierProvider.notifier).createPost(
              judul: title,
              deskripsi: _contentController.text.trim(),
            );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Postingan berhasil dibuat!'),
          backgroundColor: Color(0xFFFA6978),
        ),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuat postingan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildCategoryBottomSheet(),
    );
  }

  Widget _buildCategoryBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
              child: Column(
        mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
              const Text(
                'Pilih Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
          const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
            runSpacing: 10,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = category);
                  Navigator.pop(context);
                },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                    vertical: 10,
                          ),
                          decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFA6978) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFA6978)
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Buat Postingan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Upload Photo Area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildUploadPhotoArea(),
                  ),

                  const SizedBox(height: 16),

                  // Title Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildTitleInput(),
                  ),

                  const SizedBox(height: 12),

                  // Content Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildContentInput(),
                  ),

                  const SizedBox(height: 8),

                  // Add Topic Option
                  _buildOptionTile(
                    icon: Icons.tag,
                    title: 'Tambah Kategori',
                    subtitle: _selectedCategory,
                    onTap: _showCategoryPicker,
                  ),

                  const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ),
            ),
          ),

          // Bottom Section
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildUploadPhotoArea() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: Colors.grey[400]!,
          strokeWidth: 1,
          gap: 5,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: Colors.grey[500],
              ),
              const SizedBox(height: 8),
              Text(
                'Upload foto',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bagikan momen spesialmu',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: 'Judul: Apa yang ingin kamu bagikan?',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _contentController,
            maxLines: null,
            minLines: 5,
            maxLength: _maxContentLength,
            decoration: InputDecoration(
              hintText:
                  '• Bagikan cerita atau pengalamanmu\n• Berikan tips untuk ibu lainnya\n• Tanyakan hal yang ingin kamu ketahui',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.6,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              counterText: '',
            ),
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
            onChanged: (_) => setState(() {}),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_contentController.text.length}/$_maxContentLength',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subtitle == null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(Opsional)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Postinganmu akan dibagikan secara publik',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey[500],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Cancel button
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Post button
              Expanded(
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submitPost : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6978),
                    disabledBackgroundColor: Colors.grey[300],
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.grey[500],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                            color: Colors.white,
                    ),
                  )
                      : const Text(
                          'Posting',
                    style: TextStyle(
                            fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1,
    this.gap = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    const radius = 12.0;

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(radius),
      ),
    );

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final length = gap;
        dashPath.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += length * 2;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
