import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

//Estados que va a poseer el QR
@immutable
abstract class QrcodeState extends Equatable {
  QrcodeState([List props = const []]) : super(); //super(props);
}

class QrEmptyState extends QrcodeState {
  @override
  String toString() => "QrEmpty";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError(); //QR vacio
}

class QrGeneringState extends QrcodeState {
  @override
  String toString() => "QrGenering";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError(); //Generando un QR
}

class QrGeneredState extends QrcodeState {
  // final QrImage qr;
  final Image? qr;

  QrGeneredState({@required this.qr}) : super([qr]);

  @override
  String toString() => "QrGenered";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError(); //QR generado
}

class QrFailedState extends QrcodeState {
  final Image? qr;

  QrFailedState({@required this.qr}) : super([qr]);

  @override
  String toString() => "QrError";

  @override
  // TODO: implement props
  List<Object?> get props =>
      throw UnimplementedError(); //Error al generar el QR
}

class QrScannedState extends QrcodeState {
  final String? contqr;

  QrScannedState({@required this.contqr}) : super([contqr]);

  @override
  String toString() => "QrScannedState {escaneado: $contqr}";

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError(); //QR Escaneado
}

class QrFailScannedState extends QrcodeState {
  @override
  String toString() => "QrFailScannedState";

  @override
  // TODO: implement props
  List<Object?> get props =>
      throw UnimplementedError(); // Escaneo de QR Fallido
}
