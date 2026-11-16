class BidanProfile {
  final int id;
  final int? locationId;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final double? averageRating;
  final int? totalReviews;
  final String? specialization;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final String? operatingHoursLabel;
  final double? distanceKm;
  final String? notes;
  final String? serviceBadge;

  BidanProfile({
    required this.id,
    this.locationId,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.averageRating,
    this.totalReviews,
    this.specialization,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.operatingHoursLabel,
    this.distanceKm,
    this.notes,
    this.serviceBadge,
  });

  /// Nama fasilitas Praktik Mandiri Bidan (PMB)
  String get pmbFacilityName {
    if (address.contains('(')) {
      final facility = address.split('(').first.trim();
      if (facility.isNotEmpty) return facility;
    }
    if (address.toLowerCase().startsWith('pmb')) {
      return address;
    }
    return name.toLowerCase().startsWith('pmb')
        ? name
        : 'PMB $name';
  }

  /// Alamat jalan spesifik PMB (tanpa nama fasilitas di depannya)
  String get pmbAddressDetail {
    if (address.contains('(') && address.contains(')')) {
      final startIndex = address.indexOf('(') + 1;
      final endIndex = address.lastIndexOf(')');
      if (endIndex > startIndex) {
        final extracted = address.substring(startIndex, endIndex).trim();
        if (extracted.isNotEmpty) return extracted;
      }
    }
    return address;
  }

  BidanProfile copyWith({
    int? id,
    int? locationId,
    String? name,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    double? averageRating,
    int? totalReviews,
    String? specialization,
    String? workingHoursStart,
    String? workingHoursEnd,
    String? operatingHoursLabel,
    double? distanceKm,
    String? notes,
    String? serviceBadge,
  }) {
    return BidanProfile(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      specialization: specialization ?? this.specialization,
      workingHoursStart: workingHoursStart ?? this.workingHoursStart,
      workingHoursEnd: workingHoursEnd ?? this.workingHoursEnd,
      operatingHoursLabel: operatingHoursLabel ?? this.operatingHoursLabel,
      distanceKm: distanceKm ?? this.distanceKm,
      notes: notes ?? this.notes,
      serviceBadge: serviceBadge ?? this.serviceBadge,
    );
  }
}
