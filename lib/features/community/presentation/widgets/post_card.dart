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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: post.hasBidanReply ? const Color(0xFFBBF7D0) : Colors.grey.shade200,
            width: post.hasBidanReply ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Tags Row: Category, Gestational Context, and Validation Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Category Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFCCD3)),
                    ),
                    child: Text(
                      post.kategoriLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE11D48),
                      ),
                    ),
                  ),

                  // Gestational Context Pill (if attached)
                  if (post.gestationalContextLabel != null &&
                      post.gestationalContextLabel!.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 11,
                            color: Color(0xFF16A34A),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            post.gestationalContextLabel!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Midwife Verified Badge
                  if (post.hasBidanReply)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 12,
                            color: Color(0xFF16A34A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Divalidasi Bidan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isMine)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.hourglass_top,
                            size: 11,
                            color: Color(0xFFD97706),
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Menunggu Bidan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // Title (Question headline)
              Text(
                post.judul,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Description preview
              Text(
                post.deskripsi,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Divider line
              Divider(height: 1, color: Colors.grey.shade100),

              const SizedBox(height: 10),

              // User Info & Actions Footer
              Row(
                children: [
                  _buildUserInfo(),
                  const Spacer(),
                  _buildActions(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    final isAnon = post.isAnonymous;
    final displayName = isAnon ? 'Bunda Anonim' : post.user.name;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAnon
                ? Colors.grey.shade300
                : const Color(0xFFFA6978).withValues(alpha: 0.1),
          ),
          child: ClipOval(
            child: !isAnon &&
                    post.user.profileImage != null &&
                    post.user.profileImage!.isNotEmpty
                ? Image.network(
                    post.user.profileImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(isAnon),
                  )
                : _buildDefaultAvatar(isAnon),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          displayName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isAnon ? FontWeight.w600 : FontWeight.w500,
            color: isAnon ? Colors.grey[600] : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(bool isAnon) {
    return Container(
      color: isAnon ? Colors.grey[200] : const Color(0xFFFA6978).withValues(alpha: 0.15),
      child: Icon(
        isAnon ? Icons.visibility_off : Icons.person,
        size: 14,
        color: isAnon ? Colors.grey[600] : const Color(0xFFFA6978),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like button
        GestureDetector(
          onTap: onLike,
          child: Row(
            children: [
              Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: post.isLiked ? const Color(0xFFFA6978) : Colors.grey[400],
              ),
              if (post.apresiasi > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${post.apresiasi}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 14),

        // Comments button
        GestureDetector(
          onTap: onComment,
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 17,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                '${post.komentar}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Delete button for owner
        if (isMine && onDelete != null) ...[
          const SizedBox(width: 4),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: Colors.grey[400],
            ),
            onPressed: onDelete,
          ),
        ],
      ],
    );
  }
}
