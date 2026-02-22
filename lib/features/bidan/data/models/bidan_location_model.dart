import '../../domain/entities/bidan_location.dart';

class BidanLocationModel extends BidanLocation {
  const BidanLocationModel({
    required super.id,
    required super.bidanName,
    required super.addressLabel,
    required super.phone,
    required super.latitude,
    required super.longitude,
  });

  factory BidanLocationModel.fromJson(Map<String, dynamic> json) {
    return BidanLocationModel(
      id: json['location_id'] as int? ?? json['id'] as int? ?? 0,
      bidanName: json['bidan_name'] as String? ??
                  json['name'] as String? ??
                  '',
      addressLabel: json['address_label'] as String? ??
                    json['address'] as String? ??
                    '',
      phone: json['phone'] as String? ??
             json['no_hp'] as String? ??
             json['nomor_telepon'] as String? ??
             '',
      latitude: (json['lat'] as num?)?.toDouble() ??
                (json['latitude'] as num?)?.toDouble() ??
                0.0,
      longitude: (json['lng'] as num?)?.toDouble() ??
                 (json['longitude'] as num?)?.toDouble() ??
                 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bidan_name': bidanName,
      'address_label': addressLabel,
      'phone': phone,
      'lat': latitude,
      'lng': longitude,
    };
  }

  BidanLocation toEntity() {
    return BidanLocation(
      id: id,
      bidanName: bidanName,
      addressLabel: addressLabel,
      phone: phone,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static BidanLocationModel fromEntity(BidanLocation entity) {
    return BidanLocationModel(
      id: entity.id,
      bidanName: entity.bidanName,
      addressLabel: entity.addressLabel,
      phone: entity.phone,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
