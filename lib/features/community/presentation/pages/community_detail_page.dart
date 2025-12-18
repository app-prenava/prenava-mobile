import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/community_providers.dart';
import '../widgets/comment_card.dart';

class CommunityDetailPage extends ConsumerStatefulWidget {
  final int postId;

  const CommunityDetailPage({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<CommunityDetailPage> createState() =>
      _CommunityDetailPageState();
}

class _CommunityDetailPageState extends ConsumerState<CommunityDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isSending = false;
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      final service = ref.read(postDetailServiceProvider(widget.postId));
      await service.addComment(text);
      
      // Increment comment count in main list (optimistic)
      ref.read(communityNotifierProvider.notifier).incrementCommentCount(widget.postId);
      
      // Refresh comments list
      ref.invalidate(postCommentsProvider(widget.postId));
      
      _commentController.clear();
      FocusScope.of(context).unfocus();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Komentar berhasil dikirim'),
            backgroundColor: Color(0xFFFA6978),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim komentar: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Coba Lagi',
              textColor: Colors.white,
              onPressed: _sendComment,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _toggleLike() async {
    // Optimistic update - immediately change UI
    final wasLiked = _isLiked;
    final oldCount = _likeCount;
    
    setState(() {
      _isLiked = !_isLiked;
      _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
    });
    
    try {
      // Call API with optimistic update
      final result = await ref
          .read(communityNotifierProvider.notifier)
          .optimisticToggleLike(widget.postId);
      
      // Sync with server response
      if (mounted) {
        setState(() {
          _isLiked = result['is_liked'] as bool;
          _likeCount = result['apresiasi'] as int;
        });
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          _isLiked = wasLiked;
          _likeCount = oldCount;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyukai postingan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postDetailProvider(widget.postId));
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: postAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFA6978),
                ),
              ),
              error: (error, _) => _buildErrorState(),
              data: (post) {
                // Initialize like state from post
                if (!_isLiked && _likeCount == 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _isLiked = post.isLiked;
                        _likeCount = post.apresiasi;
                      });
                    }
                  });
                }
                
                // Hitung jumlah komentar yang ditampilkan:
                // - jika commentsAsync sudah punya data, gunakan length-nya
                // - kalau belum, fallback ke nilai dari post.komentar
                final effectiveCommentCount = commentsAsync.hasValue
                    ? (commentsAsync.value?.length ?? post.komentar)
                    : post.komentar;

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(postDetailProvider(widget.postId));
                    ref.invalidate(postCommentsProvider(widget.postId));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post content
                        _buildPostContent(post, effectiveCommentCount),

                        const Divider(height: 1),

                        // Comments section
                        _buildCommentsSection(commentsAsync),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Comment input
          if (postAsync.hasValue) _buildCommentInput(),
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Detail Postingan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat postingan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(postDetailProvider(widget.postId)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(post, int commentCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFA6978).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFA6978).withOpacity(0.3),
              ),
            ),
            child: Text(
              post.judul,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFA6978),
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                child: ClipOval(
                  child: post.user.profileImage != null &&
                          post.user.profileImage!.isNotEmpty
                      ? Image.network(
                          post.user.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                        )
                      : _buildDefaultAvatar(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (post.createdAt != null)
                      Text(
                        _formatDate(post.createdAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Post description
          Text(
            post.deskripsi,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              // Like button
              _buildActionButton(
                icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                label: '$_likeCount',
                color: _isLiked ? const Color(0xFFFA6978) : Colors.grey[600]!,
                onTap: _toggleLike,
              ),
              const SizedBox(width: 24),
              // Comment count
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                label: '$commentCount',
                color: Colors.grey[600]!,
                onTap: null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFFA6978).withOpacity(0.2),
      child: const Icon(
        Icons.person,
        size: 24,
        color: Color(0xFFFA6978),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(AsyncValue<List> commentsAsync) {
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.user?.id;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Komentar',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          commentsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Color(0xFFFA6978),
                ),
              ),
            ),
            error: (_, __) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Gagal memuat komentar',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
            data: (comments) {
              if (comments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Belum ada komentar',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final isMine =
                      currentUserId != null && comment.userId == currentUserId;
                  return CommentCard(
                    comment: comment,
                    isMine: isMine,
                    onReply: () {
                      final name = comment.user?.name;
                      if (name != null && name.isNotEmpty) {
                        _commentController.text = '@$name ';
                        _commentController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _commentController.text.length),
                        );
                        _commentFocusNode.requestFocus();
                      }
                    },
                    onDelete: isMine
                        ? () => _confirmDeleteComment(comment.id)
                        : null,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                decoration: InputDecoration(
                  hintText: 'Tulis komentar...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendComment(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFA6978),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _isSending ? null : _sendComment,
                icon: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) {
        return 'Baru saja';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} menit lalu';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} jam lalu';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} hari lalu';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _confirmDeleteComment(int commentId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Hapus Komentar'),
          content: const Text('Apakah kamu yakin ingin menghapus komentar ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Color(0xFFFA6978)),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      final service = ref.read(postDetailServiceProvider(widget.postId));
      await service.deleteComment(commentId);

      // Decrement comment count in main list
      ref.read(communityNotifierProvider.notifier).decrementCommentCount(widget.postId);

      // Refresh comments
      ref.invalidate(postCommentsProvider(widget.postId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Komentar berhasil dihapus'),
          backgroundColor: Color(0xFFFA6978),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menghapus komentar: ${e.toString().replaceAll('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
