import 'dart:math';

import 'package:bicis_ambato/data/models/odoo/StopsAVehicle.dart';
import 'package:latlong2/latlong.dart';

abstract class HaversineDistance {
  static double calculateDistance(
      double myLatitude, double myLongitude, GeoStation geoStation) {
    const earthRadius = 6371;

    final latitud1 = myLatitude * pi / 180.0;
    final latitud2 = geoStation.lat! * pi / 180.0;
    final deltaLatitud = (geoStation.lat! - myLatitude) * pi / 180.0;
    final deltaLongitud = (geoStation.long! - myLongitude) * pi / 180.0;

    final a = sin(deltaLatitud / 2) * sin(deltaLatitud / 2) +
        cos(latitud1) *
            cos(latitud2) *
            sin(deltaLongitud / 2) *
            sin(deltaLongitud / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distancia = earthRadius * c;
    return distancia;
  }

   static GeoStation getNearestStation(
      double myLatitude, double myLongitude, List<GeoStation> geoStations, double radius) {
     double minDistance = double.infinity;
  GeoStation nearestStation = GeoStation(-1, '','', 0.0, 0.0);

  for (final geoStation in geoStations) {
    final distance = calculateDistance(myLatitude, myLongitude, geoStation);
    if (distance < radius && distance < minDistance) {
      minDistance = distance;
      nearestStation = geoStation;
    }
    }
    return nearestStation;
  }
}
