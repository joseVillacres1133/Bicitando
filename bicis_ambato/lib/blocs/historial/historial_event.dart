import 'package:equatable/equatable.dart';
//import 'package:meta/meta.dart';

abstract class HistorialEvent extends Equatable {
  const HistorialEvent([List props = const []]) : super();
}

class DataReadyEvent extends HistorialEvent {
  @override
  String toString() => "DataReadyEvent";

  @override
  List<Object?> get props => ["DataReadyEvent"];
}

class DataOnWayReadyEvent extends HistorialEvent {
  @override
  String toString() => "DataOnWayReadyEvent";

  @override
  List<Object?> get props => ["DataOnWayReadyEvent"];
}

class SinDataEvent extends HistorialEvent {
  @override
  String toString() => "DataReadyEvent";

  @override
  List<Object?> get props => ["DataReadyEvent"];
}
