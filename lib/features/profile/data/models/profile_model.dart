import '../../../../core/utils/image_url_helper.dart';
import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    super.id,
    super.tanggalLahir,
    super.usia,
    super.alamat,
    super.noTelepon,
    super.pendidikanTerakhir,
    super.pekerjaan,
    super.golonganDarah,
    super.photoUrl,
    super.pendapatanKeluarga,
    super.statusKandungan,
    super.provinsi,
    super.provinceCode,
    super.kota,
    super.regencyCode,
    super.kecamatan,
    super.districtCode,
    super.latitude,
    super.longitude,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final photoUrl = ImageUrlHelper.normalizeImageUrl(json['photo']?.toString());

    return ProfileModel(
      id: _parseInt(json['id'] ?? json['user_profile_id']),
      tanggalLahir: json['tanggal_lahir']?.toString(),
      usia: _parseInt(json['usia']),
      alamat: json['alamat']?.toString(),
      noTelepon: json['no_telepon']?.toString(),
      pendidikanTerakhir: json['pendidikan_terakhir']?.toString(),
      pekerjaan: json['pekerjaan']?.toString(),
      golonganDarah: json['golongan_darah']?.toString(),
      photoUrl: photoUrl,
      pendapatanKeluarga: json['pendapatan_keluarga']?.toString(),
      statusKandungan: json['status_kandungan']?.toString(),
      provinsi: json['provinsi']?.toString(),
      provinceCode: json['province_code']?.toString(),
      kota: json['kota']?.toString(),
      regencyCode: json['regency_code']?.toString(),
      kecamatan: json['kecamatan']?.toString(),
      districtCode: json['district_code']?.toString(),
      latitude: _parseDouble(json['lat']),
      longitude: _parseDouble(json['lng']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
