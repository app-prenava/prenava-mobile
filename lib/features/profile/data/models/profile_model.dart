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
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: _parseInt(json['id']),
      tanggalLahir: json['tanggal_lahir']?.toString(),
      usia: _parseInt(json['usia']),
      alamat: json['alamat']?.toString(),
      noTelepon: json['no_telepon']?.toString(),
      pendidikanTerakhir: json['pendidikan_terakhir']?.toString(),
      pekerjaan: json['pekerjaan']?.toString(),
      golonganDarah: json['golongan_darah']?.toString(),
      photoUrl: json['photo']?.toString(),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tanggalLahir != null) map['tanggal_lahir'] = tanggalLahir;
    if (usia != null) map['usia'] = usia;
    if (alamat != null) map['alamat'] = alamat;
    if (noTelepon != null) map['no_telepon'] = noTelepon;
    if (pendidikanTerakhir != null) map['pendidikan_terakhir'] = pendidikanTerakhir;
    if (pekerjaan != null) map['pekerjaan'] = pekerjaan;
    if (golonganDarah != null) map['golongan_darah'] = golonganDarah;
    return map;
  }
}

