class ConsultationType {
  final String id;
  final String name;
  final String description;

  ConsultationType({
    required this.id,
    required this.name,
    required this.description,
  });

  ConsultationType copyWith({String? id, String? name, String? description}) {
    return ConsultationType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
