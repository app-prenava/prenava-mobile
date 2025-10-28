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
    String? photoUrl = json['photo']?.toString();
    
    // Fix localhost URL to use server IP
    if (photoUrl != null && photoUrl.contains('localhost')) {
      photoUrl = photoUrl.replaceAll('http://localhost:8000', 'http://192.168.1.16:8000');
    }
    
    return ProfileModel(
      id: _parseInt(json['id']),
      tanggalLahir: json['tanggal_lahir']?.toString(),
      usia: _parseInt(json['usia']),
      alamat: json['alamat']?.toString(),
      noTelepon: json['no_telepon']?.toString(),
      pendidikanTerakhir: json['pendidikan_terakhir']?.toString(),
      pekerjaan: json['pekerjaan']?.toString(),
      golonganDarah: json['golongan_darah']?.toString(),
      photoUrl: photoUrl,
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
    if (id != null) map['id'] = id;
    if (tanggalLahir != null) map['tanggal_lahir'] = tanggalLahir;
    if (usia != null) map['usia'] = usia;
    if (alamat != null) map['alamat'] = alamat;
    if (noTelepon != null) map['no_telepon'] = noTelepon;
    if (pendidikanTerakhir != null) map['pendidikan_terakhir'] = pendidikanTerakhir;
    if (pekerjaan != null) map['pekerjaan'] = pekerjaan;
    if (golonganDarah != null) map['golongan_darah'] = golonganDarah;
    if (photoUrl != null) map['photo'] = photoUrl;
    return map;
  }
}

