import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class RutasEvent extends Equatable {
  const RutasEvent([List props = const []]) : super(); //super(props);
}

class DestinityDoneEvent extends RutasEvent {
  final String? valor;
  final double? latitudDestino;
  final double? longitudDestino;

  DestinityDoneEvent(
      {@required this.valor,
      @required this.latitudDestino,
      @required this.longitudDestino})
      : super([valor, latitudDestino, longitudDestino]);
  @override
  String toString() =>
      "PaymentDid {valor: $valor, cantidadCompleta: $latitudDestino, cantidadMedia: $longitudDestino}";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RutasEmpty extends RutasEvent {
  @override
  String toString() => "RutasEmpty";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RutasLoadingEvent extends RutasEvent {
  @override
  String toString() => "RutasLoadingEvent";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TipoRutas extends RutasEvent {
  @override
  String toString() => "TipoRutas";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DriverRutas extends RutasEvent {
  final String? imagen;
  final List<Map<String, dynamic>>? listItem;
  DriverRutas({
    @required this.imagen,
    @required this.listItem,
  }) : super([imagen, listItem]);
  @override
  String toString() => "DriverRutas";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DriverDetail extends RutasEvent {
  final String? imagen;
  final String? conductor;
  final String? tipoAuto;
  final String? placa;
  final String? telefono;
  final double? score;
  final String? typeService;
  DriverDetail({
    @required this.imagen,
    @required this.conductor,
    @required this.tipoAuto,
    @required this.placa,
    @required this.telefono,
    @required this.score,
    @required this.typeService,
  }) : super(
            [imagen, conductor, tipoAuto, placa, telefono, score, typeService]);
  @override
  String toString() => "DriverDetail";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CamionsDetail extends RutasEvent {
  final String? imagen;
  final String? kilometro;
  final List<Map<String, dynamic>>? listItem;
  CamionsDetail(
      {@required this.imagen,
      @required this.kilometro,
      @required this.listItem})
      : super([imagen, kilometro, listItem]);
  @override
  String toString() => "CamionsDetail";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
