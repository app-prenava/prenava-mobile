class MaternalConsultationItem {
  final int id;
  final String? transcribedText;
  final String query;
  final String aiAnswer;
  final String referenceSource;
  final String providerUsed;
  final bool isEmergency;
  final String dangerLevel;
  final List<String> dangerKeywords;
  final String? recommendedAction;
  final DateTime createdAt;

  const MaternalConsultationItem({
    required this.id,
    this.transcribedText,
    required this.query,
    required this.aiAnswer,
    required this.referenceSource,
    required this.providerUsed,
    required this.isEmergency,
    required this.dangerLevel,
    required this.dangerKeywords,
    this.recommendedAction,
    required this.createdAt,
  });

  factory MaternalConsultationItem.fromJson(Map<String, dynamic> json) {
    return MaternalConsultationItem(
      id: json['id'] as int? ?? 0,
      transcribedText: json['transcribed_text'] as String?,
      query: json['query'] as String? ?? json['transcribed_text'] as String? ?? '',
      aiAnswer: json['ai_answer'] as String? ?? json['answer'] as String? ?? '',
      referenceSource: json['reference_source'] as String? ?? 'Buku KIA Kemenkes RI',
      providerUsed: json['provider_used'] as String? ?? 'groq',
      isEmergency: json['is_emergency'] as bool? ?? false,
      dangerLevel: json['danger_level'] as String? ?? 'NORMAL',
      dangerKeywords: (json['danger_keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      recommendedAction: json['recommended_action'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class DangerCategoryItem {
  final String code;
  final String label;
  final String recommendedAction;

  const DangerCategoryItem({
    required this.code,
    required this.label,
    required this.recommendedAction,
  });

  factory DangerCategoryItem.fromJson(Map<String, dynamic> json) {
    return DangerCategoryItem(
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      recommendedAction: json['recommended_action'] as String? ?? '',
    );
  }
}
