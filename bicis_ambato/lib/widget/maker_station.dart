import 'package:flutter_map/flutter_map.dart';

class MakerStation extends Marker {
  final String? nameStation;
  final int? bikes;

  const MakerStation(this.nameStation, this.bikes, {required super.point, required super.child});


}