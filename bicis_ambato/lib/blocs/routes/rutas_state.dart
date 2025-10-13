import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class RutasState extends Equatable {
  const RutasState([List props = const []]) : super(); //super(props); const
}

class RutasLoading extends RutasState {
  @override
  String toString() => "RutasLoading";

  @override
  List<Object?> get props => ["RutasLoading"];
}

class RutasExistentes extends RutasState {
  @override
  String toString() => "RutasExistentes";

  @override
  List<Object?> get props => ["RutasExistentes"];
}

class LoadingDrivers extends RutasState {
  @override
  String toString() => "LoadingDrivers";

  @override
  List<Object?> get props => ["LoadingDrivers"];
}

class DriverRutasState extends RutasState {
  final String? imageAsset;
  final List<Map<String, dynamic>>? listItem;
  DriverRutasState({@required this.imageAsset, @required this.listItem})
      : super([imageAsset, listItem]);
  @override
  String toString() => "DriverRutasState";

  @override
  List<Object?> get props => ["DriverRutasState"];
}

class DriverSelectedState extends RutasState {
  final String? imageAsset;
  final String? conductor;
  final String? tipoAuto;
  final String? placa;
  final String? telefono;
  final String? score;
  final String? typeService;
  DriverSelectedState({
    @required this.imageAsset,
    @required this.conductor,
    @required this.tipoAuto,
    @required this.placa,
    @required this.telefono,
    @required this.score,
    @required this.typeService,
  }) : super([
          imageAsset,
          conductor,
          tipoAuto,
          placa,
          telefono,
          score,
          typeService
        ]);
  @override
  String toString() => "DriverRutasState";

  @override
  List<Object?> get props => ["DriverRutasState"];
}

class CamionSelectedState extends RutasState {
  final String? imageAsset;
  final double? kilometro;
  final List<Map<String, dynamic>>? listItem;
  CamionSelectedState(
      {@required this.imageAsset,
      @required this.kilometro,
      @required this.listItem})
      : super([imageAsset, kilometro, listItem]);
  @override
  String toString() => "CamionSelectedState";

  @override
  List<Object?> get props => ["CamionSelectedState"];
}
