import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.category,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle different possible field names and types
    final id = json['id'] ?? json['user_id'] ?? 0;
    final name = json['name'] ?? json['username'] ?? 'Unknown';
    final email = json['email'] ?? '';
    final category = json['category'];

    return UserModel(
      id: id is int ? id : int.tryParse(id.toString()) ?? 0,
      name: name.toString(),
      email: email.toString(),
      category: category?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'category': category,
    };
  }
}

