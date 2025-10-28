class Profile {
  final int? id;
  final String? tanggalLahir;
  final int? usia;
  final String? alamat;
  final String? noTelepon;
  final String? pendidikanTerakhir;
  final String? pekerjaan;
  final String? golonganDarah;
  final String? photoUrl;

  const Profile({
    this.id,
    this.tanggalLahir,
    this.usia,
    this.alamat,
    this.noTelepon,
    this.pendidikanTerakhir,
    this.pekerjaan,
    this.golonganDarah,
    this.photoUrl,
  });

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

