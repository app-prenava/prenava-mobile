import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_remote_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDatasource remoteDatasource;

  BannerRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<BannerEntity>> getActiveBanners() async {
    return await remoteDatasource.getActiveBanners();
  }

  @override
  Future<List<BannerEntity>> getAllBanners() async {
    return await remoteDatasource.getAllBanners();
  }
}

