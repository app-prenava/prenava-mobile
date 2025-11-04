import '../entities/banner_entity.dart';

abstract class BannerRepository {
  Future<List<BannerEntity>> getActiveBanners();
  Future<List<BannerEntity>> getAllBanners();
}

