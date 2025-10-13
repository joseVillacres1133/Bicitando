import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Eventos o acciones que va a realizar el fingerprint_widget
@immutable
abstract class FingerprintEvent extends Equatable {
  FingerprintEvent([List props = const []]) : super(); //super(props);
}

class VerifyFingerprint extends FingerprintEvent {
  final bool finger;

  VerifyFingerprint(this.finger) : super([finger]);

  @override
  String toString() => 'VerifyFingerprint { finger: $finger }';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ResetFingerprint extends FingerprintEvent {
  @override
  String toString() => 'ResetFingerprint';

  @override
  // TODO: implement props
  List<Object?> get props => ['ResetFingerprint'];
}

class FingerprintChanged extends FingerprintEvent {
  final String autorizado;

  FingerprintChanged({required this.autorizado}) : super([autorizado]);

  @override
  String toString() => 'FingerprintChanged { autorizado: $autorizado }';

  @override
  // TODO: implement props
  List<Object?> get props => ['FingerprintChanged { autorizado: $autorizado }'];
}
