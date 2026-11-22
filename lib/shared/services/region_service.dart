import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';

class RegionItem {
  final String code;
  final String name;

  const RegionItem({required this.code, required this.name});

  factory RegionItem.fromJson(Map<String, dynamic> json) {
    return RegionItem(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class RegionService {
  final Dio _dio;

  List<RegionItem>? _provincesCache;
  final Map<String, List<RegionItem>> _regenciesCache = {};
  final Map<String, List<RegionItem>> _districtsCache = {};

  RegionService(this._dio);

  Future<List<RegionItem>> getProvinces() async {
    if (_provincesCache != null) return _provincesCache!;
    final response = await _dio.get('/public/regions/provinces');
    final raw = response.data['data'] as List<dynamic>? ?? [];
    _provincesCache = raw
        .map((e) => RegionItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return _provincesCache!;
  }

  Future<List<RegionItem>> getRegencies(String provinceCode) async {
    if (provinceCode.isEmpty) return [];
    if (_regenciesCache.containsKey(provinceCode)) {
      return _regenciesCache[provinceCode]!;
    }
    final response = await _dio.get(
      '/public/regions/regencies',
      queryParameters: {'province_code': provinceCode},
    );
    final raw = response.data['data'] as List<dynamic>? ?? [];
    final items = raw
        .map((e) => RegionItem.fromJson(e as Map<String, dynamic>))
        .toList();
    _regenciesCache[provinceCode] = items;
    return items;
  }

  Future<List<RegionItem>> getDistricts(String regencyCode) async {
    if (regencyCode.isEmpty) return [];
    if (_districtsCache.containsKey(regencyCode)) {
      return _districtsCache[regencyCode]!;
    }
    final response = await _dio.get(
      '/public/regions/districts',
      queryParameters: {'regency_code': regencyCode},
    );
    final raw = response.data['data'] as List<dynamic>? ?? [];
    final items = raw
        .map((e) => RegionItem.fromJson(e as Map<String, dynamic>))
        .toList();
    _districtsCache[regencyCode] = items;
    return items;
  }
}

final regionServiceProvider = Provider<RegionService>((ref) {
  final dio = ref.watch(appDioProvider);
  return RegionService(dio);
});

