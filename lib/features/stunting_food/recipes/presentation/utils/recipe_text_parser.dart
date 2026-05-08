List<String> parseRecipeParts(String? raw) {
  if (raw == null) return const [];
  return raw
      .split('--')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

String? normalizeSourceUrl(String? raw) {
  final v = raw?.trim();
  if (v == null || v.isEmpty) return null;
  if (v.startsWith('http://') || v.startsWith('https://')) return v;
  if (v.startsWith('/id/resep/')) return 'https://cookpad.com$v';
  return v;
}

