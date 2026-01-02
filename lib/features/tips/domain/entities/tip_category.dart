class TipCategory {
  final int id;
  final String name;
  final String slug;
  final String? iconName;
  final String? iconUrl;
  final String? description;
  final int tipsCount;

  TipCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.iconName,
    this.iconUrl,
    this.description,
    required this.tipsCount,
  });
}

