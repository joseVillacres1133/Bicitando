import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Eventos o acciones que va a realizar el QR
@immutable
abstract class QrcodeEvent extends Equatable {
  QrcodeEvent([List props = const []]) : super(); //super(props);
}

class QrGeneratedEvent extends QrcodeEvent {
  final String? mensaje;

  QrGeneratedEvent({@required this.mensaje}) : super([mensaje]);

  @override
  String toString() => "QrGenerated { mensaje: $mensaje}";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError(); //Generara el QR
}

class QrScannedEvent extends QrcodeEvent {
  @override
  String toString() => "QrScanned";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError(); //Escaneara el QR
}
