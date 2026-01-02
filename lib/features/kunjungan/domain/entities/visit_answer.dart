class VisitAnswer {
  final bool? jawaban; // true, false, or null
  final String? label;

  VisitAnswer({
    this.jawaban,
    this.label,
  });

  // Convert to API value (1/0/null)
  int? get apiValue => jawaban == null ? null : (jawaban! ? 1 : 0);
}
