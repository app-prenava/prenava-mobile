import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final String? badgeName;
  final IconData? badgeIcon;
  final int? points;
  final VoidCallback? onBadgeTap;
  final VoidCallback? onPointsTap;

  const UserHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.badgeName,
    this.badgeIcon,
    this.points,
    this.onBadgeTap,
    this.onPointsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/gradien.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: avatarUrl != null
                    ? Image.network(
                        avatarUrl!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _defaultAvatar(),
                      )
                    : _defaultAvatar(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Badge Gamifikasi (Tier / Lencana)
                      if (badgeName != null && badgeName!.isNotEmpty)
                        InkWell(
                          onTap: onBadgeTap,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  badgeIcon ?? Icons.shield_outlined,
                                  size: 13,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  badgeName!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Poin yang dimiliki
                      InkWell(
                        onTap: onPointsTap,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                size: 13,
                                color: Color(0xFFFFD54F),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${points ?? 0} Poin',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: Colors.white,
      child: const Icon(
        Icons.person,
        size: 32,
        color: Color(0xFFFA6978),
      ),
    );
  }
}
