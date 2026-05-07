class HumanizedMapper {
  static const Map<String, String> factorLabels = {
    'child_gender': 'Jenis Kelamin Anak',
    'mother_education_level': 'Pendidikan Ibu',
    'mother_employment_status': 'Status Pekerjaan Ibu',
    'mother_height_cm': 'Tinggi Badan Ibu',
    'improved_water': 'Akses Air Bersih',
    'improved_sanitation': 'Akses Sanitasi',
    'home_ownership': 'Kepemilikan Rumah',
    'has_electricity': 'Akses Listrik',
    'has_refrigerator': 'Kepemilikan Kulkas',
    'has_tv': 'Kepemilikan TV',
    'mother_age_at_birth': 'Usia Ibu saat Melahirkan',
    'is_teenage_mother': 'Usia Ibu Terlalu Muda',
    'is_high_risk_mother_age': 'Usia Ibu Risiko Tinggi',
    'has_delivery_insurance': 'Asuransi Persalinan',
    'anc_clinic_midwife': 'Pemeriksaan di Klinik/Bidan',
    'anc_hospital': 'Pemeriksaan di Rumah Sakit',
    'anc_traditional_other': 'Pemeriksaan Tradisional',
    'anc_unknown': 'Tempat Pemeriksaan Tidak Diketahui',
  };

  static String getLabel(String key) {
    return factorLabels[key] ?? key;
  }

  static String getRiskDescription(String label, double weight) {
    if (weight > 0) {
      return 'Faktor "$label" berkontribusi meningkatkan risiko.';
    } else {
      return 'Faktor "$label" membantu menurunkan risiko.';
    }
  }
}
