import '../../domain/entities/bidan_profile.dart';

class BidanProfileModel extends BidanProfile {
  BidanProfileModel({
    required super.id,
    super.locationId,
    required super.name,
    super.bidanName,
    super.tempatPraktik,
    required super.phone,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.distanceKm,
    super.averageRating,
    super.totalReviews,
    super.specialization,
    super.workingHoursStart,
    super.workingHoursEnd,
    super.operatingHours,
    super.provinceName,
    super.regencyName,
    super.districtName,
    super.strNumber,
    super.sipNumber,
    super.isVerifiedPartner,
    super.photoUrl,
    super.notes,
  });

  factory BidanProfileModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? parsedHours;
    final rawHours = json['operating_hours'];
    if (rawHours is Map<String, dynamic>) {
      parsedHours = rawHours;
    }

    return BidanProfileModel(
      id: (json['bidan_id'] as num?)?.toInt() ??
          (json['id'] as num?)?.toInt() ??
          0,
      locationId: (json['location_id'] as num?)?.toInt(),
      name: json['name']?.toString() ??
          json['tempat_praktik']?.toString() ??
          json['bidan_name']?.toString() ??
          '',
      bidanName: json['bidan_name']?.toString(),
      tempatPraktik: json['tempat_praktik']?.toString(),
      phone: json['phone']?.toString() ?? json['no_hp']?.toString() ?? '',
      address: json['address']?.toString() ??
          json['address_label']?.toString() ??
          json['alamat_praktik']?.toString() ??
          '',
      latitude: (json['latitude'] as num?)?.toDouble() ??
          (json['lat'] as num?)?.toDouble() ??
          0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ??
          (json['lng'] as num?)?.toDouble() ??
          0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      totalReviews: (json['total_reviews'] as num?)?.toInt(),
      specialization:
          json['specialization']?.toString() ?? json['spesialisasi']?.toString(),
      workingHoursStart: json['working_hours_start']?.toString(),
      workingHoursEnd: json['working_hours_end']?.toString(),
      operatingHours: parsedHours,
      provinceName: json['province_name']?.toString(),
      regencyName: json['regency_name']?.toString(),
      districtName: json['district_name']?.toString(),
      strNumber: json['str_number']?.toString(),
      sipNumber: json['sip_number']?.toString(),
      isVerifiedPartner: json['is_verified_partner'] == true,
      photoUrl: json['photo_url']?.toString(),
      notes: json['notes']?.toString(),
    );
  }

  BidanProfile toEntity() => this;
}
