import '../../domain/entities/bidan_location.dart';
import '../../domain/repositories/bidan_repository.dart';
import '../datasources/bidan_remote_datasource.dart';

class BidanRepositoryImpl implements BidanRepository {
  final BidanRemoteDatasource _datasource;

  BidanRepositoryImpl(this._datasource);

  @override
  Future<List<BidanLocation>> getBidanLocations() async {
    final models = await _datasource.getBidanLocations();
    return models.map((model) => model.toEntity()).toList();
  }
}
