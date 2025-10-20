import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile();
  Future<Profile> createProfile(Map<String, dynamic> data, {String? photoPath});
  Future<Profile> updateProfile(Map<String, dynamic> data, {String? photoPath});
  Future<void> deletePhoto();
}

