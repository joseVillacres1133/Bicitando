import 'package:bicis_ambato/data/models/odoo/StopsAVehicle.dart';
import 'package:bicis_ambato/data/models/vehicle.dart';

class Travel {

  int id;
  String name;

  Vehicle vehicle;
  GeoStation startStation;
  GeoStation? arrivalStation;
  
  
  String? date;
  String? state;
  String? time;


  Travel(
    {
    required this.id, 
    required this.name, 
    required this.state, 
    required this.vehicle, 
    required this.startStation, 
    this.arrivalStation,
    this.date,
    this.time}
    );

}


