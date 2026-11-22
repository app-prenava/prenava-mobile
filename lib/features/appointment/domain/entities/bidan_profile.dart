class BidanProfile {
  final int id;
  final int? locationId;
  final String name;
  final String? bidanName;
  final String? tempatPraktik;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final double? distanceKm;
  final double? averageRating;
  final int? totalReviews;
  final String? specialization;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final Map<String, dynamic>? operatingHours;
  final String? provinceName;
  final String? regencyName;
  final String? districtName;
  final String? strNumber;
  final String? sipNumber;
  final bool isVerifiedPartner;
  final String? photoUrl;
  final String? notes;

  BidanProfile({
    required this.id,
    this.locationId,
    required this.name,
    this.bidanName,
    this.tempatPraktik,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distanceKm,
    this.averageRating,
    this.totalReviews,
    this.specialization,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.operatingHours,
    this.provinceName,
    this.regencyName,
    this.districtName,
    this.strNumber,
    this.sipNumber,
    this.isVerifiedPartner = false,
    this.photoUrl,
    this.notes,
  });

  String get displayClinicName =>
      (tempatPraktik != null && tempatPraktik!.isNotEmpty)
          ? tempatPraktik!
          : name;

  String get displayRegion {
    final parts = [districtName, regencyName, provinceName]
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .toList();
    return parts.join(', ');
  }

  String? get displayOperatingHours {
    if (operatingHours != null && operatingHours!.isNotEmpty) {
      if (operatingHours!['jadwal'] != null) {
        return operatingHours!['jadwal'].toString();
      }
      return operatingHours!.entries
          .map((e) => '${e.key}: ${e.value}')
          .take(2)
          .join(' • ');
    }
    if (workingHoursStart != null && workingHoursEnd != null) {
      return '$workingHoursStart - $workingHoursEnd';
    }
    return null;
  }

  BidanProfile copyWith({
    int? id,
    int? locationId,
    String? name,
    String? bidanName,
    String? tempatPraktik,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    double? distanceKm,
    double? averageRating,
    int? totalReviews,
    String? specialization,
    String? workingHoursStart,
    String? workingHoursEnd,
    Map<String, dynamic>? operatingHours,
    String? provinceName,
    String? regencyName,
    String? districtName,
    String? strNumber,
    String? sipNumber,
    bool? isVerifiedPartner,
    String? photoUrl,
    String? notes,
  }) {
    return BidanProfile(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      bidanName: bidanName ?? this.bidanName,
      tempatPraktik: tempatPraktik ?? this.tempatPraktik,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceKm: distanceKm ?? this.distanceKm,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      specialization: specialization ?? this.specialization,
      workingHoursStart: workingHoursStart ?? this.workingHoursStart,
      workingHoursEnd: workingHoursEnd ?? this.workingHoursEnd,
      operatingHours: operatingHours ?? this.operatingHours,
      provinceName: provinceName ?? this.provinceName,
      regencyName: regencyName ?? this.regencyName,
      districtName: districtName ?? this.districtName,
      strNumber: strNumber ?? this.strNumber,
      sipNumber: sipNumber ?? this.sipNumber,
      isVerifiedPartner: isVerifiedPartner ?? this.isVerifiedPartner,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
    );
  }
}
