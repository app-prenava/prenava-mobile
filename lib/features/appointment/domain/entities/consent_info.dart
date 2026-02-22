class ConsentInfo {
  final String consentText;
  final String version;
  final List<String> availableFields;

  ConsentInfo({
    required this.consentText,
    required this.version,
    required this.availableFields,
  });

  ConsentInfo copyWith({
    String? consentText,
    String? version,
    List<String>? availableFields,
  }) {
    return ConsentInfo(
      consentText: consentText ?? this.consentText,
      version: version ?? this.version,
      availableFields: availableFields ?? this.availableFields,
    );
  }
}
