import 'package:flutter/foundation.dart';

@immutable
class BannerEntity {
  final int? id;
  final String? name;
  final String? photo;
  final String? url;
  final bool? isActive;
  final String? createdAt;

  const BannerEntity({
    this.id,
    this.name,
    this.photo,
    this.url,
    this.isActive,
    this.createdAt,
  });

  BannerEntity copyWith({
    int? id,
    String? name,
    String? photo,
    String? url,
    bool? isActive,
    String? createdAt,
  }) {
    return BannerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      url: url ?? this.url,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}




