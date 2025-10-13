import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MapState extends Equatable {
  MapState([List props = const []]) : super(); //super(props);
}

class MapInitialState extends MapState {
  @override
  String toString() => "MapInitialState";

  @override
  List<Object?> get props => ["MapInitialState"];
}

class MapDoingState extends MapState {
  @override
  String toString() => "MapDoingState";

  @override
  List<Object?> get props => ["MapDoingState"];
}

class WithOutDestineState extends MapState {
  //No Hay destino

  @override
  String toString() => "WithOutDestineState";

  @override
  List<Object?> get props => ["WithOutDestineState"];
}

class WithGpsActived extends MapState {
  //No Hay destino

  @override
  String toString() => "WithGpsActived";

  @override
  List<Object?> get props => ["WithGpsActived"];
}
