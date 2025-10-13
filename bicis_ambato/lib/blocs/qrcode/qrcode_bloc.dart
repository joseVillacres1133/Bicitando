// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../utils/constants_msg.dart';
// import '../../utils/encriptacion.dart';
// import '../../utils/sharedprefs_helper.dart';
// import './bloc.dart';

// class QrcodeBloc extends Bloc<QrcodeEvent, QrcodeState> {
//   QrcodeBloc() : super(QrEmptyState());
//   @override
//   QrcodeState get initialState => QrEmptyState();

//   @override
//   Stream<QrcodeState> mapEventToState(
//     QrcodeEvent event,
//   ) async* {
//     if (event is QrGeneratedEvent) {
//       yield* _mapQrGeneratedToState(event.mensaje!);
//     }
//     if (event is QrScannedEvent) {
//       yield* _mapQrScannedToState();
//     }
//   }
// }

// Stream<QrcodeState> _mapQrGeneratedToState(String mensaje) async* {
//   //Genera QR
//   Image? qr;
//   Prefs _prefs = Prefs();

//   var fechahora;
//   var saldofic1 = '0.75';
//   var saldofic2 = '0.50';

//   try {
//     //Encripta el mensaje con la fecha tomada del dispositivo
//     fechahora =
//         new DateFormat("dd/MM/yyyy HH:mm:ss aaa").format(new DateTime.now());

//     String contarCarateres = _prefs.idUserPartner.toString();
//     String aumentar = "";
//     if (contarCarateres.length <= 10) {
//       for (var i = contarCarateres.length; i < 10; i++) {
//         aumentar += "0";
//       }
//     }
//     if (_prefs.idUserPartner != null) {
//       final msg = Encriptar.encriptacion(mensaje +
//           "," +
//           fechahora +
//           "," +
//           saldofic1 +
//           "," +
//           saldofic2 +
//           "," +
//           aumentar +
//           _prefs.idUserPartner.toString());
//       ////////print("Encriptar QR "+msg);
//       // qr = await QrUtils.generateQR(msg);
//     } else {
//       final msg = Encriptar.encriptacion(mensaje +
//           "," +
//           fechahora +
//           "," +
//           saldofic1 +
//           "," +
//           saldofic2 +
//           "," +
//           aumentar +
//           _prefs.idUserPartner.toString());
//     }

//     //Hace el QR del mensaje encriptado
//     yield QrGeneredState(
//         qr: qr!); //Manda al screen en el estado que se encuentra
//   } catch (_) {
//     if (mensaje == null) {
//       yield QrEmptyState();
//     } else {
//       yield QrFailedState(qr: Image.asset(img_qr_error));
//     }
//   }
// }

// Stream<QrcodeState> _mapQrScannedToState() async* {
//   yield QrGeneringState();
// }
