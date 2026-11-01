import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

class BadgeItem {
  final int id;
  final String badgeCode;
  final String name;
  final String category;
  final String description;
  final String icon;
  final int bonusPoints;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int progressCurrent;
  final int progressTarget;
  final String requirementType;

  BadgeItem({
    required this.id,
    required this.badgeCode,
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.bonusPoints,
    required this.isUnlocked,
    this.unlockedAt,
    required this.progressCurrent,
    required this.progressTarget,
    required this.requirementType,
  });

  factory BadgeItem.fromJson(Map<String, dynamic> json) {
    return BadgeItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      badgeCode: (json['badge_code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? 'medis').toString(),
      description: (json['description'] ?? '').toString(),
      icon: (json['icon'] ?? 'emoji_events').toString(),
      bonusPoints: json['bonus_points'] is int
          ? json['bonus_points']
          : int.tryParse(json['bonus_points']?.toString() ?? '0') ?? 0,
      isUnlocked: json['is_unlocked'] == true,
      unlockedAt: json['unlocked_at'] != null ? DateTime.tryParse(json['unlocked_at'].toString()) : null,
      progressCurrent: json['progress_current'] is int
          ? json['progress_current']
          : int.tryParse(json['progress_current']?.toString() ?? '0') ?? 0,
      progressTarget: json['progress_target'] is int
          ? json['progress_target']
          : int.tryParse(json['progress_target']?.toString() ?? '1') ?? 1,
      requirementType: (json['requirement_type'] ?? '').toString(),
    );
  }

  double get progressFraction {
    if (isUnlocked) return 1.0;
    if (progressTarget <= 0) return 0.0;
    final frac = progressCurrent / progressTarget;
    return frac > 1.0 ? 1.0 : (frac < 0.0 ? 0.0 : frac);
  }
}

class BadgesResponse {
  final List<BadgeItem> badges;
  final int totalUnlocked;
  final int totalBadges;

  BadgesResponse({
    required this.badges,
    required this.totalUnlocked,
    required this.totalBadges,
  });

  factory BadgesResponse.fromJson(Map<String, dynamic> json) {
    final rawList = (json['badges'] as List?) ?? [];
    final badges = rawList.map((item) => BadgeItem.fromJson(item as Map<String, dynamic>)).toList();

    return BadgesResponse(
      badges: badges,
      totalUnlocked: json['total_unlocked'] is int
          ? json['total_unlocked']
          : int.tryParse(json['total_unlocked']?.toString() ?? '0') ?? 0,
      totalBadges: json['total_badges'] is int
          ? json['total_badges']
          : int.tryParse(json['total_badges']?.toString() ?? '0') ?? badges.length,
    );
  }
}

final badgesProvider = FutureProvider.autoDispose<BadgesResponse>((ref) async {
  final dio = ref.watch(appDioProvider);
  final response = await dio.get('/user/badges');

  final data = response.data as Map<String, dynamic>;
  return BadgesResponse.fromJson(data);
});
