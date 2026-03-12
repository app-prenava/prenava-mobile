class AnemiaScanResult {
  final String prediction;
  final double? confidence;
  final double? probabilityAnemia;
  final double? probabilityNonAnemia;
  final double? thresholdUsed;
  final String? error;

  const AnemiaScanResult({
    required this.prediction,
    this.confidence,
    this.probabilityAnemia,
    this.probabilityNonAnemia,
    this.thresholdUsed,
    this.error,
  });
}
