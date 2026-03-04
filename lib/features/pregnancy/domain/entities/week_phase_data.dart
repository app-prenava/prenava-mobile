/// Hardcoded week-to-phase mapping for pregnancy calculator.
/// Each week has a phase name, fruit comparison, and description.
class WeekPhaseData {
  final String phaseName;
  final String fruitIcon;
  final String description;

  const WeekPhaseData({
    required this.phaseName,
    required this.fruitIcon,
    required this.description,
  });

  static WeekPhaseData getForWeek(int week) {
    if (week < 1) week = 1;
    if (week > 42) week = 42;
    return _weekData[week] ?? _weekData[1]!;
  }

  static const Map<int, WeekPhaseData> _weekData = {
    1: WeekPhaseData(
      phaseName: 'Fase Persiapan',
      fruitIcon: '✨',
      description: 'Tubuh mulai siklus baru lapisan rahim luruh.\nFokus: istirahat, nutrisi, dan persiapan folat.',
    ),
    2: WeekPhaseData(
      phaseName: 'Fase Persiapan',
      fruitIcon: '✨',
      description: 'Ovulasi terjadi, sel telur siap dibuahi.\nFokus: nutrisi seimbang dan gaya hidup sehat.',
    ),
    3: WeekPhaseData(
      phaseName: 'Fase Pembuahan',
      fruitIcon: '🌱',
      description: 'Sel telur dibuahi dan mulai membelah.\nUkuran: seperti biji bunga poppy.',
    ),
    4: WeekPhaseData(
      phaseName: 'Fase Implantasi',
      fruitIcon: '🌱',
      description: 'Embrio menempel di dinding rahim.\nUkuran: seperti biji wijen.',
    ),
    5: WeekPhaseData(
      phaseName: 'Fase Pembentukan Awal',
      fruitIcon: '🫘',
      description: 'Jantung mulai berdetak, tabung saraf terbentuk.\nUkuran: seperti biji lentil.',
    ),
    6: WeekPhaseData(
      phaseName: 'Fase Pembentukan Awal',
      fruitIcon: '🫐',
      description: 'Wajah mulai terbentuk, tunas tangan & kaki muncul.\nUkuran: seperti blueberry.',
    ),
    7: WeekPhaseData(
      phaseName: 'Fase Pembentukan Organ',
      fruitIcon: '🫘',
      description: 'Otak berkembang pesat, jari-jari mulai terbentuk.\nUkuran: seperti kacang merah.',
    ),
    8: WeekPhaseData(
      phaseName: 'Fase Pembentukan Organ',
      fruitIcon: '🍇',
      description: 'Semua organ utama mulai berkembang.\nUkuran: seperti buah anggur.',
    ),
    9: WeekPhaseData(
      phaseName: 'Fase Pembentukan Organ',
      fruitIcon: '🍊',
      description: 'Embrio menjadi janin, ekor menghilang.\nUkuran: seperti buah kumquat.',
    ),
    10: WeekPhaseData(
      phaseName: 'Fase Pembentukan Organ',
      fruitIcon: '🍈',
      description: 'Organ vital hampir selesai terbentuk.\nUkuran: seperti buah tin.',
    ),
    11: WeekPhaseData(
      phaseName: 'Fase Pertumbuhan',
      fruitIcon: '🍋',
      description: 'Tulang mulai mengeras, kuku mulai tumbuh.\nUkuran: seperti buah lemon.',
    ),
    12: WeekPhaseData(
      phaseName: 'Fase Pertumbuhan',
      fruitIcon: '🫛',
      description: 'Refleks mulai berkembang, janin bisa mengepalkan tangan.\nUkuran: seperti polong kacang.',
    ),
    13: WeekPhaseData(
      phaseName: 'Trimester 2 Dimulai',
      fruitIcon: '🍑',
      description: 'Risiko keguguran menurun, energi meningkat.\nUkuran: seperti buah persik.',
    ),
    14: WeekPhaseData(
      phaseName: 'Fase Perkembangan',
      fruitIcon: '🍎',
      description: 'Janin mulai membuat ekspresi wajah.\nUkuran: seperti buah apel.',
    ),
    15: WeekPhaseData(
      phaseName: 'Fase Perkembangan',
      fruitIcon: '🥑',
      description: 'Tulang semakin kuat, janin mulai mendengar.\nUkuran: seperti buah alpukat.',
    ),
    16: WeekPhaseData(
      phaseName: 'Fase Perkembangan',
      fruitIcon: '🧅',
      description: 'Mata mulai sensitif terhadap cahaya.\nUkuran: seperti lobak.',
    ),
    17: WeekPhaseData(
      phaseName: 'Fase Perkembangan',
      fruitIcon: '🫑',
      description: 'Lemak mulai terbentuk di bawah kulit.\nUkuran: seperti paprika.',
    ),
    18: WeekPhaseData(
      phaseName: 'Fase Gerakan',
      fruitIcon: '🍅',
      description: 'Ibu mulai merasakan gerakan janin pertama.\nUkuran: seperti tomat besar.',
    ),
    19: WeekPhaseData(
      phaseName: 'Fase Gerakan',
      fruitIcon: '🍌',
      description: 'Vernix caseosa melindungi kulit janin.\nUkuran: seperti pisang.',
    ),
    20: WeekPhaseData(
      phaseName: 'Setengah Perjalanan',
      fruitIcon: '🥕',
      description: 'Setengah perjalanan kehamilan! USG anatomi.\nUkuran: seperti wortel.',
    ),
    21: WeekPhaseData(
      phaseName: 'Fase Pertumbuhan Aktif',
      fruitIcon: '🍠',
      description: 'Sistem pencernaan mulai berfungsi.\nUkuran: seperti ubi jalar.',
    ),
    22: WeekPhaseData(
      phaseName: 'Fase Pertumbuhan Aktif',
      fruitIcon: '🥭',
      description: 'Alis dan bulu mata mulai tumbuh.\nUkuran: seperti mangga besar.',
    ),
    23: WeekPhaseData(
      phaseName: 'Fase Pertumbuhan Aktif',
      fruitIcon: '🌽',
      description: 'Pendengaran semakin tajam, bisa mendengar suara ibu.\nUkuran: seperti jagung.',
    ),
    24: WeekPhaseData(
      phaseName: 'Fase Viabilitas',
      fruitIcon: '🧅',
      description: 'Janin memiliki peluang bertahan di luar rahim.\nUkuran: seperti rutabaga.',
    ),
    25: WeekPhaseData(
      phaseName: 'Fase Viabilitas',
      fruitIcon: '🥦',
      description: 'Paru-paru mulai memproduksi surfaktan.\nUkuran: seperti kembang kol.',
    ),
    26: WeekPhaseData(
      phaseName: 'Fase Viabilitas',
      fruitIcon: '🍆',
      description: 'Mata mulai terbuka, refleks mengisap berkembang.\nUkuran: seperti terong.',
    ),
    27: WeekPhaseData(
      phaseName: 'Trimester 3 Dimulai',
      fruitIcon: '🎃',
      description: 'Otak berkembang sangat cepat.\nUkuran: seperti labu butternut.',
    ),
    28: WeekPhaseData(
      phaseName: 'Fase Pematangan',
      fruitIcon: '🥬',
      description: 'Janin bisa bermimpi (REM sleep dimulai).\nUkuran: seperti kol.',
    ),
    29: WeekPhaseData(
      phaseName: 'Fase Pematangan',
      fruitIcon: '🥥',
      description: 'Tulang semakin kuat, otot berkembang.\nUkuran: seperti kelapa.',
    ),
    30: WeekPhaseData(
      phaseName: 'Fase Pematangan',
      fruitIcon: '🍠',
      description: 'Sumsum tulang memproduksi sel darah merah.\nUkuran: seperti bengkoang.',
    ),
    31: WeekPhaseData(
      phaseName: 'Fase Pematangan',
      fruitIcon: '🍍',
      description: 'Janin mulai berputar posisi kepala ke bawah.\nUkuran: seperti nanas.',
    ),
    32: WeekPhaseData(
      phaseName: 'Fase Persiapan Lahir',
      fruitIcon: '🍈',
      description: 'Kuku kaki sudah tumbuh, kulit semakin halus.\nUkuran: seperti melon cantaloupe.',
    ),
    33: WeekPhaseData(
      phaseName: 'Fase Persiapan Lahir',
      fruitIcon: '🍈',
      description: 'Imunitas mulai berkembang dari antibodi ibu.\nUkuran: seperti melon honeydew.',
    ),
    34: WeekPhaseData(
      phaseName: 'Fase Persiapan Lahir',
      fruitIcon: '🥔',
      description: 'Vernix semakin tebal, paru-paru hampir matang.\nUkuran: seperti pepaya.',
    ),
    35: WeekPhaseData(
      phaseName: 'Fase Persiapan Lahir',
      fruitIcon: '🍈',
      description: 'Ginjal dan hati sudah berfungsi penuh.\nUkuran: seperti melon musim dingin.',
    ),
    36: WeekPhaseData(
      phaseName: 'Fase Siap Lahir',
      fruitIcon: '🎃',
      description: 'Janin terus menambah berat badan.\nUkuran: seperti labu.',
    ),
    37: WeekPhaseData(
      phaseName: 'Fase Siap Lahir',
      fruitIcon: '🍉',
      description: 'Kehamilan dianggap cukup bulan (early term).\nUkuran: seperti semangka.',
    ),
    38: WeekPhaseData(
      phaseName: 'Fase Siap Lahir',
      fruitIcon: '🍉',
      description: 'Organ sudah matang sempurna.\nUkuran: seperti semangka.',
    ),
    39: WeekPhaseData(
      phaseName: 'Fase Siap Lahir',
      fruitIcon: '🍉',
      description: 'Full term! Janin siap lahir kapan saja.\nUkuran: seperti semangka besar.',
    ),
    40: WeekPhaseData(
      phaseName: 'Hari Perkiraan Lahir',
      fruitIcon: '🍈',
      description: 'HPL tercapai. Tetap tenang dan hubungi dokter.\nUkuran: seperti nangka.',
    ),
    41: WeekPhaseData(
      phaseName: 'Pasca HPL',
      fruitIcon: '🍈',
      description: 'Dokter akan memantau lebih ketat.\nKonsultasi segera jika belum ada tanda persalinan.',
    ),
    42: WeekPhaseData(
      phaseName: 'Pasca HPL',
      fruitIcon: '🍈',
      description: 'Biasanya induksi direkomendasikan.\nHubungi dokter segera.',
    ),
  };
}
