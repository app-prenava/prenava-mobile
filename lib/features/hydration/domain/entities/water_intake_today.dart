class WaterIntakeToday {
  final String tanggal;
  final String tanggalFormatted;
  final int jumlahMl;
  final int jumlahGelas;
  final int targetGelas;
  final bool targetTercapai;
  final int persentase;
  final String lastUpdatedFormatted;

  WaterIntakeToday({
    required this.tanggal,
    required this.tanggalFormatted,
    required this.jumlahMl,
    required this.jumlahGelas,
    required this.targetGelas,
    required this.targetTercapai,
    required this.persentase,
    required this.lastUpdatedFormatted,
  });
}

