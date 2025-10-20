import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _remoteDatasource;

  ProfileRepositoryImpl({required ProfileRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Profile?> getProfile() async {
    try {
      return await _remoteDatasource.getProfile();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> createProfile(
    Map<String, dynamic> data, {
    String? photoPath,
  }) async {
    try {
      return await _remoteDatasource.createProfile(data, photoPath: photoPath);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> updateProfile(
    Map<String, dynamic> data, {
    String? photoPath,
  }) async {
    try {
      return await _remoteDatasource.updateProfile(data, photoPath: photoPath);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePhoto() async {
    try {
      await _remoteDatasource.deletePhoto();
    } catch (e) {
      rethrow;
    }
  }
}

