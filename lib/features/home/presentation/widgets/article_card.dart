import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final String authorName;
  final String authorSubtitle;
  final String? authorAvatar;
  final String content;
  final VoidCallback? onReadMore;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.authorName,
    required this.authorSubtitle,
    this.authorAvatar,
    required this.content,
    this.onReadMore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFFFE8EC),
                      child: authorAvatar != null
                          ? ClipOval(
                              child: Image.network(
                                authorAvatar!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _defaultAvatar(),
                              ),
                            )
                          : _defaultAvatar(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authorName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424242),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            authorSubtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onReadMore != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onReadMore,
                    child: const Text(
                      'Selengkapnya',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFA6978),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return const Icon(
      Icons.person,
      size: 24,
      color: Color(0xFFFA6978),
    );
  }
}

