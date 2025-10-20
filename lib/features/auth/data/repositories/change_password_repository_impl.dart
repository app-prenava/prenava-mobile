import '../../domain/repositories/change_password_repository.dart';
import '../datasources/change_password_datasource.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordDatasource _datasource;

  ChangePasswordRepositoryImpl({
    required ChangePasswordDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<void> changePassword(String newPassword) async {
    try {
      await _datasource.changePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }
}

