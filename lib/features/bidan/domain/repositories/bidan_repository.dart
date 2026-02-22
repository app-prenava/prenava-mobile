import '../entities/bidan_location.dart';

abstract class BidanRepository {
  Future<List<BidanLocation>> getBidanLocations();
}
