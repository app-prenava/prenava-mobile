import '../../domain/entities/bidan_profile.dart';

class BidanProfileModel extends BidanProfile {
  BidanProfileModel({
    required super.id,
    super.locationId,
    required super.name,
    required super.phone,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.averageRating,
    super.totalReviews,
    super.specialization,
    super.workingHoursStart,
    super.workingHoursEnd,
  });

  factory BidanProfileModel.fromJson(Map<String, dynamic> json) {
    return BidanProfileModel(
      id: json['id'] as int? ?? json['bidan_id'] as int? ?? 0,
      locationId: json['location_id'] as int?,
      name: json['name'] as String? ?? json['bidan_name'] as String? ?? '',
      phone: json['phone'] as String? ?? json['no_hp'] as String? ?? '',
      address:
          json['address'] as String? ?? json['address_label'] as String? ?? '',
      latitude:
          (json['latitude'] as num?)?.toDouble() ??
          (json['lat'] as num?)?.toDouble() ??
          0.0,
      longitude:
          (json['longitude'] as num?)?.toDouble() ??
          (json['lng'] as num?)?.toDouble() ??
          0.0,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      totalReviews: json['total_reviews'] as int?,
      specialization: json['specialization'] as String?,
      workingHoursStart: json['working_hours_start'] as String?,
      workingHoursEnd: json['working_hours_end'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location_id': locationId,
      'name': name,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'specialization': specialization,
      'working_hours_start': workingHoursStart,
      'working_hours_end': workingHoursEnd,
    };
  }

  BidanProfile toEntity() {
    return BidanProfile(
      id: id,
      locationId: locationId,
      name: name,
      phone: phone,
      address: address,
      latitude: latitude,
      longitude: longitude,
      averageRating: averageRating,
      totalReviews: totalReviews,
      specialization: specialization,
      workingHoursStart: workingHoursStart,
      workingHoursEnd: workingHoursEnd,
    );
  }

  static BidanProfileModel fromEntity(BidanProfile entity) {
    return BidanProfileModel(
      id: entity.id,
      locationId: entity.locationId,
      name: entity.name,
      phone: entity.phone,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      specialization: entity.specialization,
      workingHoursStart: entity.workingHoursStart,
      workingHoursEnd: entity.workingHoursEnd,
    );
  }
}
