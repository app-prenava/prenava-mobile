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

  static const Map<String, String> _categoryOptions = {
    'keluhan_gejala': 'Keluhan & Gejala',
    'nutrisi': 'Nutrisi & Gizi',
    'persalinan': 'Persiapan Persalinan',
    'mitos_fakta': 'Mitos & Fakta',
    'parenting': 'Parenting & Pascapersalinan',
    'umum': 'Diskusi Umum',
  };

  String _selectedCategoryKey = 'keluhan_gejala';
  bool _isAnonymous = false;
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
        : _categoryOptions[_selectedCategoryKey] ?? 'Pertanyaan Ibu Hamil';

    final success =
        await ref.read(communityNotifierProvider.notifier).createPost(
              judul: title,
              deskripsi: _contentController.text.trim(),
              kategori: _selectedCategoryKey,
              isAnonymous: _isAnonymous,
            );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pertanyaan berhasil dikirim ke forum!'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuat postingan, coba beberapa saat lagi.'),
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
                'Pilih Kategori Topik',
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
            children: _categoryOptions.entries.map((entry) {
              final isSelected = _selectedCategoryKey == entry.key;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategoryKey = entry.key);
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
                    entry.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[800],
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
          'Tanya di Forum',
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
                  const SizedBox(height: 12),

                  // Auto Gestational Age Context Info Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.health_and_safety_outlined,
                            color: Color(0xFF16A34A),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Usia kehamilan Anda otomatis disematkan pada postingan agar Bidan dapat memberikan advis klinis yang tepat.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[900],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

                  // Category Picker Option Tile
                  _buildOptionTile(
                    icon: Icons.category_outlined,
                    title: 'Kategori Topik',
                    subtitle: _categoryOptions[_selectedCategoryKey],
                    onTap: _showCategoryPicker,
                  ),

                  const Divider(height: 1, indent: 16, endIndent: 16),

                  // Anonymous Mode Switch Tile
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isAnonymous,
                      activeTrackColor: const Color(0xFFFA6978),
                      title: const Text(
                        'Tanya sebagai Bunda Anonim',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Nama & foto disamarkan dari publik. Bidan tetap dapat melihat minggu kehamilan untuk kebutuhan evaluasi klinis.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => _isAnonymous = val);
                      },
                    ),
                  ),

                  const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ),
            ),
          ),

          // Bottom Submit Section
          _buildBottomSection(),
        ],
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
          hintText: 'Judul keluhan atau pertanyaan Anda...',
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
            minLines: 6,
            maxLength: _maxContentLength,
            decoration: InputDecoration(
              hintText:
                  'Jelaskan keluhan secara rinci:\n• Sejak kapan keluhan dirasakan?\n• Gejala penyerta (kram, pusing, dsb.)\n• Hal yang ingin ditanyakan ke Bidan atau Bunda lainnya',
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFA6978),
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
            color: Colors.black.withValues(alpha: 0.05),
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
              Icon(
                _isAnonymous ? Icons.visibility_off_outlined : Icons.public,
                size: 15,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                _isAnonymous
                    ? 'Identitas Bunda disamarkan di forum publik'
                    : 'Akan tampil dengan profil Bunda di forum',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
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
                          'Kirim Pertanyaan',
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
