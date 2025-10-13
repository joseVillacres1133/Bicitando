// // ignore: file_names
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

// class StopsAVehicle {
//   List<StopsMarket> listStopsMarket;
//   List<MarkerOdoo> markersStops = [];
//   List<Marker> listGeneral = [];

//   List<Marker> listGeneralMarketAux = [];

//   StopsAVehicle(this.listStopsMarket, this.markersStops, this.listGeneral,
//       this.listGeneralMarketAux);
// }

import 'package:bicis_ambato/data/models/stationLine.dart';

class GeoStation {
  int? _id;
  StationLine? _stationLine;

  int? get id => _id;
  StationLine? get stationLine => _stationLine;
  
  set id(int? value) {
    _id = value;
  }
  set stationLine(StationLine? value) {
    _stationLine = value;
  }

  String? name;
  String? city;
  double? lat;
  double? long;
  double? distance;
  //List<VehicleMarket> listVehicleMarket = [];

  GeoStation(this._id, this.name, this.city, this.lat, this.long,);

  setDistance(double distance) {
    this.distance = distance;
  }

  double getDistance() {
    return distance!;
  }
}

// class VehicleMarket {
//   String name;
//   String lat;
//   String long;
//   VehicleMarket(this.name, this.lat, this.long);
// }

// class MarkerOdoo {
//   Marker marker;
//   Widget builderChild;
//   String typemarker;
//   List<MarkerOdoo> listMarker;

//   MarkerOdoo(this.marker, this.builderChild, this.typemarker, this.listMarker);
// }
