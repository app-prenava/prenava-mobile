class AnemiaScanResult {
  final String prediction;
  final int? historyId;
  final double? confidence;
  final double? probabilityAnemia;
  final double? probabilityNonAnemia;
  final double? thresholdUsed;
  final String? error;

  const AnemiaScanResult({
    required this.prediction,
    this.historyId,
    this.confidence,
    this.probabilityAnemia,
    this.probabilityNonAnemia,
    this.thresholdUsed,
    this.error,
  });
}
