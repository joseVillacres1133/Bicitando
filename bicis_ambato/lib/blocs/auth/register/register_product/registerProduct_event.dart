// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Eventos o acciones que va a realizar el RegisterForm
@immutable
abstract class RegisterProductEvent extends Equatable {
  const RegisterProductEvent([List props = const []])
      : super(); //super(props); coonst
}

class NameChanged extends RegisterProductEvent {
  final String? name;

  NameChanged({@required this.name}) : super([name]);

  @override
  String toString() => 'NameChanged { name :$name }';

  @override
  List<Object?> get props => ['NameChanged { name :$name }'];
}

class EmailChanged extends RegisterProductEvent {
  final String? email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  List<Object?> get props => ['EmailChanged { email :$email }'];
}

class DireccionChanged extends RegisterProductEvent {
  final String? direccion;

  DireccionChanged({@required this.direccion}) : super([direccion]);

  @override
  String toString() => 'DireccionChanged { direccion :$direccion }';

  @override
  List<Object?> get props => ['DireccionChanged { direccion :$direccion }'];
}

class PhoneChanged extends RegisterProductEvent {
  final String? phone;

  PhoneChanged({@required this.phone}) : super([phone]);

  @override
  String toString() => 'PhoneChanged { phone :$phone }';

  @override
  List<Object?> get props => ['PhoneChanged { phone :$phone }'];
}

class DescripcionChanged extends RegisterProductEvent {
  final String? descripcion;

  DescripcionChanged({@required this.descripcion}) : super([descripcion]);

  @override
  String toString() => 'DescripcionChanged { descripcion :$descripcion }';

  @override
  List<Object?> get props =>
      ['DescripcionChanged { descripcion :$descripcion }'];
}

class CedulaChanged extends RegisterProductEvent {
  final String? cedula;

  CedulaChanged({@required this.cedula}) : super([cedula]);

  @override
  String toString() => 'CedulaChanged { tipo :$cedula }';

  @override
  List<Object?> get props => ['CedulaChanged { tipo :$cedula }'];
}

class NumeroChanged extends RegisterProductEvent {
  final String? numero;

  NumeroChanged({@required this.numero}) : super([numero]);

  @override
  String toString() => 'NumeroChanged { alto :$numero }';

  @override
  List<Object?> get props => ['NumeroChanged { alto :$numero }'];
}

class AnchoChanged extends RegisterProductEvent {
  final String? numero;

  AnchoChanged({@required this.numero}) : super([numero]);

  @override
  String toString() => 'AnchoChanged { ancho :$numero }';

  @override
  List<Object?> get props => ['AnchoChanged { ancho :$numero }'];
}

class PesoChanged extends RegisterProductEvent {
  final String? numero;

  PesoChanged({@required this.numero}) : super([numero]);

  @override
  String toString() => 'PesoChanged { peso :$numero }';

  @override
  List<Object?> get props => ['PesoChanged { peso :$numero }'];
}

class LargoChanged extends RegisterProductEvent {
  final String? numero;

  LargoChanged({@required this.numero}) : super([numero]);

  @override
  String toString() => 'LargoChanged { largo :$numero }';

  @override
  List<Object?> get props => ['LargoChanged { largo :$numero }'];
}

class PrecioChanged extends RegisterProductEvent {
  final String? numero;

  PrecioChanged({@required this.numero}) : super([numero]);

  @override
  String toString() => 'PrecioChanged { precio :$numero }';

  @override
  List<Object?> get props => ['PrecioChanged { precio :$numero }'];
}

class Submitted extends RegisterProductEvent {
  final String telefonoDes;
  final String cedula;
  final String alto;
  final String ancho;
  final String largo;
  final String peso;
  final String precio;
  Submitted(this.telefonoDes, this.cedula, this.alto, this.ancho, this.largo,
      this.peso, this.precio)
      : super([telefonoDes, cedula, alto, ancho, largo, peso, precio]);

  @override
  String toString() {
    return 'Submitted { product: $telefonoDes }';
  }

  @override
  List<Object?> get props => ['Submitted { product: $telefonoDes }'];
}
