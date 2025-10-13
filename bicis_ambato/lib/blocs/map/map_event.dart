import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MapEvent extends Equatable {
  const MapEvent([List props = const []]) : super(); //super(props);
}

class DestinityDoneEvent extends MapEvent {
  //Va a Veificar el destino
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
  List<Object?> get props => [
        "PaymentDid {valor: $valor, cantidadCompleta: $latitudDestino, cantidadMedia: $longitudDestino}"
      ];
}

class LocationActivedEvent extends MapEvent {
  //Va a Veificar el destino
  final String? valor;
  final double? latitudDestino;
  final double? longitudDestino;

  LocationActivedEvent(
      {this.valor,
      @required this.latitudDestino,
      @required this.longitudDestino})
      : super([valor, latitudDestino, longitudDestino]);
  @override
  String toString() =>
      "LocationActivedEvent {valor: $valor, cantidadCompleta: $latitudDestino, cantidadMedia: $longitudDestino}";

  @override
  List<Object?> get props => [
        "LocationActivedEvent {valor: $valor, cantidadCompleta: $latitudDestino, cantidadMedia: $longitudDestino}"
      ];
}
