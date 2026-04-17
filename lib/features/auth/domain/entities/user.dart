class User {
  final int id;
  final String name;
  final String email;
  final String? category;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.category,
  });
}

