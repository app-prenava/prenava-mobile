class BidanLocation {
  final int id;
  final String bidanName;
  final String addressLabel;
  final String phone;
  final double latitude;
  final double longitude;

  const BidanLocation({
    required this.id,
    required this.bidanName,
    required this.addressLabel,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  BidanLocation copyWith({
    int? id,
    String? bidanName,
    String? addressLabel,
    String? phone,
    double? latitude,
    double? longitude,
  }) {
    return BidanLocation(
      id: id ?? this.id,
      bidanName: bidanName ?? this.bidanName,
      addressLabel: addressLabel ?? this.addressLabel,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BidanLocation &&
        other.id == id &&
        other.bidanName == bidanName &&
        other.addressLabel == addressLabel &&
        other.phone == phone &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bidanName.hashCode ^
        addressLabel.hashCode ^
        phone.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }

  @override
  String toString() {
    return 'BidanLocation(id: $id, bidanName: $bidanName, addressLabel: $addressLabel, phone: $phone, latitude: $latitude, longitude: $longitude)';
  }
}
