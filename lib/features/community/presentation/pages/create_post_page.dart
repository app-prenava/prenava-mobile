import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/community_providers.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _categories = const [
    'Parenting',
    'Finansial & Keuangan',
    'Nutrisi',
    'Kesehatan',
    'Lainnya',
  ];
  String _selectedCategory = 'Parenting';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _contentController.text.trim().isNotEmpty && !_isSubmitting;

  Future<void> _submitPost() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    final success =
        await ref.read(communityNotifierProvider.notifier).createPost(
              judul: _selectedCategory,
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userName = authState.user?.name ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFA6978).withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFFFA6978),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Content input
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Bagikan cerita, tips, atau keluhanmu di sini',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 24),

                  // Category selector
                  const Text(
                    'Pilih Kategori',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFA6978)
                                : Colors.grey[100],
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
                              fontSize: 13,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 50, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFA6978),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          // Post button
          TextButton(
            onPressed: _canSubmit ? _submitPost : null,
            style: TextButton.styleFrom(
              backgroundColor: _canSubmit
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFFA6978),
                    ),
                  )
                : Text(
                    'Post',
                    style: TextStyle(
                      color: _canSubmit
                          ? const Color(0xFFFA6978)
                          : const Color(0xFFFA6978).withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}











