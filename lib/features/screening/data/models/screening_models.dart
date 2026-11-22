class ScreeningOption {
  final String value;
  final String label;

  const ScreeningOption({
    required this.value,
    required this.label,
  });

  factory ScreeningOption.fromJson(Map<String, dynamic> json) {
    return ScreeningOption(
      value: (json['value'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
    );
  }
}

class ScreeningQuestionModel {
  final int id;
  final String code;
  final String dimension;
  final String dimensionLabel;
  final String questionText;
  final int orderNo;
  final List<ScreeningOption> options;

  const ScreeningQuestionModel({
    required this.id,
    required this.code,
    required this.dimension,
    required this.dimensionLabel,
    required this.questionText,
    required this.orderNo,
    required this.options,
  });

  factory ScreeningQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = (json['options'] as List? ?? []);
    return ScreeningQuestionModel(
      id: (json['id'] as num).toInt(),
      code: (json['code'] ?? '').toString(),
      dimension: (json['dimension'] ?? '').toString(),
      dimensionLabel: (json['dimension_label'] ?? '').toString(),
      questionText: (json['question_text'] ?? '').toString(),
      orderNo: (json['order_no'] as num? ?? 0).toInt(),
      options: rawOptions
          .map((e) => ScreeningOption.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class ScreeningQuestionsResponse {
  final String version;
  final bool hasCompletedScreening;
  final int totalQuestions;
  final List<ScreeningQuestionModel> questions;

  const ScreeningQuestionsResponse({
    required this.version,
    required this.hasCompletedScreening,
    required this.totalQuestions,
    required this.questions,
  });

  factory ScreeningQuestionsResponse.fromJson(Map<String, dynamic> json) {
    final rawQuestions = (json['questions'] as List? ?? []);
    return ScreeningQuestionsResponse(
      version: (json['version'] ?? 'v1').toString(),
      hasCompletedScreening: json['has_completed_screening'] == true,
      totalQuestions: (json['total_questions'] as num? ?? rawQuestions.length).toInt(),
      questions: rawQuestions
          .map((e) => ScreeningQuestionModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class ScreeningCategoryInfo {
  final String slug;
  final String displayName;
  final String description;
  final String badgeColor;

  const ScreeningCategoryInfo({
    required this.slug,
    required this.displayName,
    required this.description,
    required this.badgeColor,
  });

  factory ScreeningCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ScreeningCategoryInfo(
      slug: (json['slug'] ?? 'balanced').toString(),
      displayName: (json['display_name'] ?? 'Pemantauan Kehamilan').toString(),
      description: (json['description'] ?? '').toString(),
      badgeColor: (json['badge_color'] ?? '#FA6978').toString(),
    );
  }
}

class RecommendedFeatureModel {
  final String featureSlug;
  final String title;
  final String reason;
  final String route;
  final int priority;
  final bool isSecondaryBlend;

  const RecommendedFeatureModel({
    required this.featureSlug,
    required this.title,
    required this.reason,
    required this.route,
    required this.priority,
    this.isSecondaryBlend = false,
  });

  factory RecommendedFeatureModel.fromJson(Map<String, dynamic> json) {
    return RecommendedFeatureModel(
      featureSlug: (json['feature_slug'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      reason: (json['reason'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      priority: (json['priority'] as num? ?? 99).toInt(),
      isSecondaryBlend: json['is_secondary_blend'] == true,
    );
  }
}

class ScreeningResultModel {
  final bool hasCompletedScreening;
  final int? sessionId;
  final String version;
  final DateTime? completedAt;
  final Map<String, int> dimensionScores;
  final ScreeningCategoryInfo? primaryCategory;
  final List<String> secondaryCategories;
  final List<RecommendedFeatureModel> recommendedFeatures;

  const ScreeningResultModel({
    required this.hasCompletedScreening,
    this.sessionId,
    this.version = 'v1',
    this.completedAt,
    this.dimensionScores = const {},
    this.primaryCategory,
    this.secondaryCategories = const [],
    this.recommendedFeatures = const [],
  });

  factory ScreeningResultModel.fromJson(Map<String, dynamic> json) {
    final hasCompleted = json['has_completed_screening'] == true;
    if (!hasCompleted) {
      return const ScreeningResultModel(hasCompletedScreening: false);
    }

    final rawScores = json['dimension_scores'] as Map? ?? {};
    final scores = <String, int>{};
    rawScores.forEach((k, v) {
      scores[k.toString()] = (v as num? ?? 0).toInt();
    });

    final rawFeatures = json['recommended_features'] as List? ?? [];
    final rawSecondary = json['secondary_categories'] as List? ?? [];

    DateTime? completedAt;
    if (json['completed_at'] != null) {
      completedAt = DateTime.tryParse(json['completed_at'].toString());
    }

    return ScreeningResultModel(
      hasCompletedScreening: true,
      sessionId: (json['session_id'] as num?)?.toInt(),
      version: (json['version'] ?? 'v1').toString(),
      completedAt: completedAt,
      dimensionScores: scores,
      primaryCategory: json['primary_category'] is Map
          ? ScreeningCategoryInfo.fromJson(
              Map<String, dynamic>.from(json['primary_category'] as Map),
            )
          : null,
      secondaryCategories: rawSecondary.map((e) => e.toString()).toList(),
      recommendedFeatures: rawFeatures
          .map((e) => RecommendedFeatureModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
    );
  }
}

class ScreeningHistoryResponse {
  final int total;
  final List<ScreeningResultModel> sessions;

  const ScreeningHistoryResponse({
    required this.total,
    required this.sessions,
  });

  factory ScreeningHistoryResponse.fromJson(Map<String, dynamic> json) {
    final rawSessions = json['sessions'] as List? ?? [];
    return ScreeningHistoryResponse(
      total: (json['total'] as num? ?? rawSessions.length).toInt(),
      sessions: rawSessions
          .map((e) => ScreeningResultModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
    );
  }
}
