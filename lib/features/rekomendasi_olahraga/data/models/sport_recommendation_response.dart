import 'package:equatable/equatable.dart';

class SportRecommendationResponse extends Equatable {
  final String status;
  final String message;
  final bool? needUpdateData;
  final Map<String, dynamic>? forwardPayload;
  final ModelResponse? modelResponse;

  const SportRecommendationResponse({
    required this.status,
    required this.message,
    this.needUpdateData,
    this.forwardPayload,
    this.modelResponse,
  });

  factory SportRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return SportRecommendationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      needUpdateData: json['need_update_data'],
      forwardPayload: json['forward_payload'],
      modelResponse: json['model_response'] != null
          ? ModelResponse.fromJson(json['model_response'])
          : null,
    );
  }

  @override
  List<Object?> get props =>
      [status, message, needUpdateData, forwardPayload, modelResponse];
}

class ModelResponse extends Equatable {
  final String? modelVersion;
  final Map<String, dynamic>? riskProbabilities;
  final List<SportActivity> recommendations;
  final List<SportActivity> allRanked;

  const ModelResponse({
    this.modelVersion,
    this.riskProbabilities,
    required this.recommendations,
    required this.allRanked,
  });

  factory ModelResponse.fromJson(Map<String, dynamic> json) {
    return ModelResponse(
      modelVersion: json['model_version'],
      riskProbabilities: json['risk_probabilities'],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => SportActivity.fromJson(e))
              .toList() ??
          [],
      allRanked: (json['all_ranked'] as List<dynamic>?)
              ?.map((e) => SportActivity.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props =>
      [modelVersion, riskProbabilities, recommendations, allRanked];
}

class SportActivity extends Equatable {
  final String activity;
  final double score;
  final String videoLink;
  final String longText;
  final String picture1;
  final String picture2;
  final String picture3;

  const SportActivity({
    required this.activity,
    required this.score,
    required this.videoLink,
    required this.longText,
    required this.picture1,
    required this.picture2,
    required this.picture3,
  });

  factory SportActivity.fromJson(Map<String, dynamic> json) {
    return SportActivity(
      activity: json['activity'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      videoLink: json['video_link'] ?? 'data not found',
      longText: json['long_text'] ?? 'data not found',
      picture1: json['picture_1'] ?? 'data not found',
      picture2: json['picture_2'] ?? 'data not found',
      picture3: json['picture_3'] ?? 'data not found',
    );
  }

  @override
  List<Object?> get props => [
        activity,
        score,
        videoLink,
        longText,
        picture1,
        picture2,
        picture3,
      ];
}
