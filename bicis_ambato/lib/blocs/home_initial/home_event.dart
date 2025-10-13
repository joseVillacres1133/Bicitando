import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/odoo/StopsAVehicle.dart';
import '../../data/models/stationLine.dart';

//Evento o Accion que va a realizar la pagina principal
@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent([List props = const []])
      : super(); //super(props);  const
}

class HomeCheckStatusEvent extends HomeEvent {
  @override
  String toString() => "HomeCheckStatusEvent";

  @override
  List<Object?> get props => ["HomeCheckStatusEvent"];
}

class SubmittedNewReserve extends HomeEvent {
  late final StationLine stationLine;
  @override
  String toString() => "SubmittedNewReserve";

  @override
  List<Object?> get props => [stationLine];
}
class SubmittedStopReserve extends HomeEvent {
  late final GeoStation arrivaGeoStation;
  @override
  String toString() => "SubmittedStopReserve";

  @override
  List<Object?> get props => [arrivaGeoStation];
}

class HomeMessageREvent extends HomeEvent {
  @override
  String toString() => "HomeMessageREvent";

  @override
  List<Object?> get props => ["HomeMessageREvent"];
}
