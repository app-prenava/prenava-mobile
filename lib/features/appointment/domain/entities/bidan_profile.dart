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
  });

  BidanProfile copyWith({
    int? id,
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
  }) {
    return BidanProfile(
      id: id ?? this.id,
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
    );
  }
}
