
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../odoo/StopsAVehicle.dart';

class StopMarker extends Marker {
  final  GeoStation _geoStation;

   GeoStation get geoStation => _geoStation;


  const StopMarker({required point, required child, required GeoStation geoStation})
      : _geoStation = geoStation,
        super(point: point, child: child);
  
}