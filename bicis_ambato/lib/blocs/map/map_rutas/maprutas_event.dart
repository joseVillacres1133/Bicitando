import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MaprutasEvent extends Equatable {
  const MaprutasEvent([List props = const []]) : super(); //super(props); const
}

class PoscicionConductorEvent extends MaprutasEvent {
  final double? latitudConductor;
  final double? longitudConductor;

  PoscicionConductorEvent(
      {@required this.latitudConductor, @required this.longitudConductor})
      : super([latitudConductor, longitudConductor]);
  @override
  String toString() =>
      "PoscicionConductorEvent {latitudConductor: $latitudConductor, longitudConductor: $longitudConductor}";

  @override
  List<Object?> get props => [
        "PoscicionConductorEvent {latitudConductor: $latitudConductor, longitudConductor: $longitudConductor}"
      ];
}

// ignore: must_be_immutable
class MessageConductorEvent extends MaprutasEvent {
  String? valMessage;

  MessageConductorEvent({@required this.valMessage}) : super([valMessage]);
  @override
  String toString() => "MessageConductorEvent {mensagge: $valMessage}";

  @override
  List<Object?> get props => ["MessageConductorEvent {mensagge: $valMessage}"];
}

// ignore: must_be_immutable
class MessageConductorGrEvent extends MaprutasEvent {
  String? valMessage;

  MessageConductorGrEvent({@required this.valMessage}) : super([valMessage]);
  @override
  String toString() => "MessageConductorEvent {mensagge: $valMessage}";

  @override
  List<Object?> get props => ["MessageConductorEvent {mensagge: $valMessage}"];
}

class RealizarViajeFinalEvent extends MaprutasEvent {
  @override
  String toString() => "RealizarViajeFinalEvent {}";

  @override
  List<Object?> get props => ["RealizarViajeFinalEvent {}"];
}
