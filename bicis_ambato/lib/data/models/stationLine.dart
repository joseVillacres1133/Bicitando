import 'package:bicis_ambato/data/models/vehicle.dart';

class StationLine {
  int id;
  Vehicle vehicle;
  bool isFree;
  int idStation;


  StationLine({required this.id, required this.vehicle, required this.isFree,required this.idStation});
}