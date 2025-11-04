import 'package:dio/dio.dart';
import '../models/banner_model.dart';

class BannerRemoteDatasource {
  final Dio _dio;

  BannerRemoteDatasource(this._dio);

  Future<List<BannerModel>> getActiveBanners() async {
    final response = await _dio.get('/banner/show/production');
    final data = response.data['data'] as List;
    return data.map((json) => BannerModel.fromJson(json)).toList();
  }

  Future<List<BannerModel>> getAllBanners() async {
    final response = await _dio.get('/banner/show/all');
    final data = response.data['data'] as List;
    return data.map((json) => BannerModel.fromJson(json)).toList();
  }
}

