import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MaprutasState extends Equatable {
  MaprutasState([List props = const []]) : super(); //super(props);
}

class MaprutasInitial extends MaprutasState {
  @override
  String toString() => "MaprutasInitialState";

  @override
  List<Object?> get props => ["MaprutasInitialState"];
}

class PosicionConducorState extends MaprutasState {
  final double latitudConductor;
  final double longitudConductor;

  PosicionConducorState(this.latitudConductor, this.longitudConductor);
  @override
  String toString() => "PosicionConducorState";

  @override
  List<Object?> get props => ["PosicionConducorState"];
}

// ignore: must_be_immutable
class MessageConductorState extends MaprutasState {
  String? valMessage;

  MessageConductorState({@required this.valMessage}) : super([valMessage]);
  @override
  String toString() => "MessageConductorState {mensagge: $valMessage}";

  @override
  List<Object?> get props => ["MessageConductorState {mensagge: $valMessage}"];
}

// ignore: must_be_immutable
class MessageConductorGrState extends MaprutasState {
  String? valMessage;

  MessageConductorGrState({@required this.valMessage}) : super([valMessage]);
  @override
  String toString() => "MessageConductorGrState {mensagge: $valMessage}";

  @override
  List<Object?> get props =>
      ["MessageConductorGrState {mensagge: $valMessage}"];
}

class RealizarViajeFinalState extends MaprutasState {
  @override
  String toString() => "RealizarViajeFinalState";

  @override
  List<Object?> get props => ["RealizarViajeFinalState"];
}
