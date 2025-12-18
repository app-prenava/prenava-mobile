import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onDelete;
  final bool isMine;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
  this.onDelete,
  this.isMine = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Tag
            _buildCategoryTag(),
            
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post title/description
                  Text(
                    post.deskripsi,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // User info
                  _buildUserInfo(),
                  
                  const SizedBox(height: 12),
                  
                  // Actions
                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 16),
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
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        // Profile image
        Container(
          width: 32,
          height: 32,
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
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            post.user.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        if (isMine && onDelete != null)
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: onDelete,
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFFA6978).withOpacity(0.2),
      child: const Icon(
        Icons.person,
        size: 18,
        color: Color(0xFFFA6978),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        // Like button
        GestureDetector(
          onTap: onLike,
          child: Row(
            children: [
              Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: post.isLiked ? const Color(0xFFFA6978) : Colors.grey[400],
              ),
              if (post.apresiasi > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${post.apresiasi}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Comment button
        GestureDetector(
          onTap: onComment,
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: Colors.grey[400],
              ),
              if (post.komentar > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${post.komentar}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

