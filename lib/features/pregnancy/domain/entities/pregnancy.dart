class Pregnancy {
  final String hpht;
  final String hphtFormatted;
  final String hpl;
  final String hplFormatted;
  final PregnancyAge usiaKehamilan;
  final int trimester;
  final String trimesterName;
  final double progressPercentage;
  final PregnancyCountdown countdown;
  final String status;
  final String statusDescription;
  final String? babyName;
  final String? babyGender;
  final FetalSize? fetalSize;

  Pregnancy({
    required this.hpht,
    required this.hphtFormatted,
    required this.hpl,
    required this.hplFormatted,
    required this.usiaKehamilan,
    required this.trimester,
    required this.trimesterName,
    required this.progressPercentage,
    required this.countdown,
    required this.status,
    required this.statusDescription,
    this.babyName,
    this.babyGender,
    this.fetalSize,
  });

  Pregnancy copyWith({
    String? hpht,
    String? hphtFormatted,
    String? hpl,
    String? hplFormatted,
    PregnancyAge? usiaKehamilan,
    int? trimester,
    String? trimesterName,
    double? progressPercentage,
    PregnancyCountdown? countdown,
    String? status,
    String? statusDescription,
    String? babyName,
    String? babyGender,
    FetalSize? fetalSize,
  }) {
    return Pregnancy(
      hpht: hpht ?? this.hpht,
      hphtFormatted: hphtFormatted ?? this.hphtFormatted,
      hpl: hpl ?? this.hpl,
      hplFormatted: hplFormatted ?? this.hplFormatted,
      usiaKehamilan: usiaKehamilan ?? this.usiaKehamilan,
      trimester: trimester ?? this.trimester,
      trimesterName: trimesterName ?? this.trimesterName,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      countdown: countdown ?? this.countdown,
      status: status ?? this.status,
      statusDescription: statusDescription ?? this.statusDescription,
      babyName: babyName ?? this.babyName,
      babyGender: babyGender ?? this.babyGender,
      fetalSize: fetalSize ?? this.fetalSize,
    );
  }
}

class PregnancyAge {
  final int minggu;
  final int hari;
  final int totalHari;
  final String teks;

  PregnancyAge({
    required this.minggu,
    required this.hari,
    required this.totalHari,
    required this.teks,
  });

  factory PregnancyAge.fromJson(Map<String, dynamic> json) {
    return PregnancyAge(
      minggu: (json['minggu'] as num?)?.toInt() ?? 0,
      hari: (json['hari'] as num?)?.toInt() ?? 0,
      totalHari: (json['total_hari'] as num?)?.toInt() ?? 0,
      teks: json['teks']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minggu': minggu,
      'hari': hari,
      'total_hari': totalHari,
      'teks': teks,
    };
  }
}

class PregnancyCountdown {
  final int hariSampaiHpl;
  final int mingguSampaiHpl;
  final String teks;

  PregnancyCountdown({
    required this.hariSampaiHpl,
    required this.mingguSampaiHpl,
    required this.teks,
  });

  factory PregnancyCountdown.fromJson(Map<String, dynamic> json) {
    return PregnancyCountdown(
      hariSampaiHpl: (json['hari_sampai_hpl'] as num?)?.toInt() ?? 0,
      mingguSampaiHpl: (json['minggu_sampai_hpl'] as num?)?.toInt() ?? 0,
      teks: json['teks']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hari_sampai_hpl': hariSampaiHpl,
      'minggu_sampai_hpl': mingguSampaiHpl,
      'teks': teks,
    };
  }
}

class FetalSize {
  final String nama;
  final String namaIndo;
  final int beratGr;
  final double panjangCm;

  FetalSize({
    required this.nama,
    required this.namaIndo,
    required this.beratGr,
    required this.panjangCm,
  });

  factory FetalSize.fromJson(Map<String, dynamic> json) {
    return FetalSize(
      nama: json['nama']?.toString() ?? '',
      namaIndo: json['nama_indo']?.toString() ?? '',
      beratGr: (json['berat_gr'] as num?)?.toInt() ?? 0,
      panjangCm: (json['panjang_cm'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nama_indo': namaIndo,
      'berat_gr': beratGr,
      'panjang_cm': panjangCm,
    };
  }

  // Helper untuk format berat yang lebih mudah dibaca
  String get formattedBerat {
    if (beratGr >= 1000) {
      return '${(beratGr / 1000).toStringAsFixed(1)} kg';
    }
    return '$beratGr gram';
  }

  // Helper untuk format panjang
  String get formattedPanjang {
    return '${panjangCm.toStringAsFixed(1)} cm';
  }

  // Get fruit emoji based on fetal size name
  String get fruitEmoji {
    final fruitEmojis = {
      'Poppy seed': '🌱',
      'Sesame seed': '🌱',
      'Lentil': '🫘',
      'Blueberry': '🫐',
      'Kidney bean': '🫘',
      'Grape': '🍇',
      'Kumquat': '🍊',
      'Fig': '🍈',
      'Lemon': '🍋',
      'Pea pod': '🫛',
      'Peach': '🍑',
      'Apple': '🍎',
      'Avocado': '🥑',
      'Turnip': '🧅',
      'Bell pepper': '🫑',
      'Heirloom tomato': '🍅',
      'Banana': '🍌',
      'Carrot': '🥕',
      'Spaghetti squash': '🍠',
      'Large mango': '🥭',
      'Corn': '🌽',
      'Rutabaga': '🧅',
      'Scallion': '🧅',
      'Cauliflower': '🥦',
      'Eggplant': '🍆',
      'Butternut squash': '🎃',
      'Cabbage': '🥬',
      'Coconut': '🥥',
      'Jicama': '🍠',
      'Pineapple': '🍍',
      'Cantaloupe': '🍈',
      'Honeydew melon': '🍈',
      'Papaya': '🥔',
      'Winter melon': '🍈',
      'Pumpkin': '🎃',
      'Watermelon': '🍉',
      'Jackfruit': '🍈',
    };

    return fruitEmojis[nama] ?? '👶';
  }
}
