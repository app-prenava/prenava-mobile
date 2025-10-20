import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle different possible field names and types
    final id = json['id'] ?? json['user_id'] ?? 0;
    final name = json['name'] ?? json['username'] ?? 'Unknown';
    final email = json['email'] ?? '';

    return UserModel(
      id: id is int ? id : int.tryParse(id.toString()) ?? 0,
      name: name.toString(),
      email: email.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

