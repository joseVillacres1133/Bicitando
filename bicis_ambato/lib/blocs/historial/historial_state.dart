import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HistorialState extends Equatable {
  const HistorialState([List props = const []]) : super();
}

class HistorialInitial extends HistorialState {
  @override
  List<Object?> get props => ['HistorialInitial'];
}

class DataReadyState extends HistorialState {
  @override
  String toString() => "DataReadyState";

  @override
  List<Object?> get props => ["DataReadyState"];
}

class DataOnWayReadyState extends HistorialState {
  @override
  String toString() => "DataOnWayReadyState";

  @override
  List<Object?> get props => ["DataOnWayReadyState"];
}

class SinDataState extends HistorialState {
  @override
  String toString() => "SinDataState";

  @override
  List<Object?> get props => ["SinDataState"];
}
