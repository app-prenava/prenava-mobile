import '../../domain/entities/anemia_scan_result.dart';

class AnemiaScanResultModel extends AnemiaScanResult {
  const AnemiaScanResultModel({
    required super.prediction,
    super.confidence,
    super.probabilityAnemia,
    super.probabilityNonAnemia,
    super.thresholdUsed,
    super.error,
  });

  factory AnemiaScanResultModel.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 'error' || json['status'] == false) {
      return AnemiaScanResultModel(
        prediction: '',
        error: json['message'] as String? ?? 'Terjadi kesalahan',
      );
    }

    final data = json['data'];
    if (data == null) {
      return AnemiaScanResultModel(
        prediction: '',
        error: json['message'] as String? ?? 'Data tidak ditemukan',
      );
    }

    String predictionStr = '';
    double? confidence;
    double? probAnemia;
    double? probNonAnemia;
    double? threshold;
    
    if (data is Map<String, dynamic>) {
      // API mereturn format seperti: 
      // { "label": "non-anemia", "confidence": 0.918, "probability_anemia": 0.082, "probability_non_anemia": 0.918, "threshold_used": 0.4968 }
      final label = data['label']?.toString() ?? 'tidak diketahui';
      predictionStr = label.toUpperCase();
      
      if (data['confidence'] != null) {
         confidence = double.tryParse(data['confidence'].toString());
      }
      if (data['probability_anemia'] != null) {
         probAnemia = double.tryParse(data['probability_anemia'].toString());
      }
      if (data['probability_non_anemia'] != null) {
         probNonAnemia = double.tryParse(data['probability_non_anemia'].toString());
      }
      if (data['threshold_used'] != null) {
         threshold = double.tryParse(data['threshold_used'].toString());
      }
    } else {
       predictionStr = data.toString();
    }

    return AnemiaScanResultModel(
      prediction: predictionStr,
      confidence: confidence,
      probabilityAnemia: probAnemia,
      probabilityNonAnemia: probNonAnemia,
      thresholdUsed: threshold,
    );
  }
}
