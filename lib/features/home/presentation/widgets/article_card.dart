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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFFFE8EC),
                    child: authorAvatar != null
                        ? ClipOval(
                            child: Image.network(
                              authorAvatar!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _defaultAvatar(),
                            ),
                          )
                        : _defaultAvatar(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242),
                          ),
                        ),
                        Text(
                          authorSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              if (onReadMore != null) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onReadMore,
                  child: const Text(
                    'more',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFC7286),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return const Icon(
      Icons.person,
      size: 24,
      color: Color(0xFFFC7286),
    );
  }
}

