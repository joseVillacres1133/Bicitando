// // ignore_for_file: file_names
// import 'dart:async';
// import 'package:bloc/bloc.dart';
// //import 'package:meta/meta.dart';
// import 'package:bike_municipio/utils/validarCedula.dart';
// import 'package:bike_municipio/utils/validators.dart';
// import 'package:rxdart/rxdart.dart';
// import '../../../../utils/constants_msg.dart';
// import './bloc.dart';

// class RegisterProductBloc
//     extends Bloc<RegisterProductEvent, RegisterProductState> {
//   RegisterProductBloc() : super(RegisterProductState.empty()) {
//     on<NameChanged>((event, emit) =>
//         emit(state.update(isNameValid: Validators.isValidName(event.name!))));
//     on<DireccionChanged>((event, emit) => emit(state.update(
//         isDireccionValid: Validators.isValidName(event.direccion!))));
//     on<PhoneChanged>((event, emit) => emit(
//         state.update(isPhoneValid: Validators.isValidPhone(event.phone!))));
//     on<DescripcionChanged>((event, emit) => emit(state.update(
//         isDescripcionValid: Validators.isValidName(event.descripcion!))));
//     on<CedulaChanged>((event, emit) => emit(state.update(
//         isCedulaValid: Validators.isValidDocumento(event.cedula!))));
//     on<EmailChanged>((event, emit) => emit(
//         state.update(isEmailValid: Validators.isValidEmail(event.email!))));
//     on<NumeroChanged>((event, emit) => emit(
//         state.update(isNumeroValid: Validators.isValidDecimal(event.numero!))));
//     on<AnchoChanged>((event, emit) => emit(
//         state.update(isAnchoValid: Validators.isValidDecimal(event.numero!))));
//     on<LargoChanged>((event, emit) => emit(
//         state.update(isLargoValid: Validators.isValidDecimal(event.numero!))));
//     on<PesoChanged>((event, emit) => emit(
//         state.update(isPesoValid: Validators.isValidDecimal(event.numero!))));
//     on<PrecioChanged>((event, emit) => emit(state.update(
//         isPrecioValid: Validators.isValidDecimalPre(event.numero!))));
//     on<Submitted>((event, emit) {
//       var alt = double.parse(event.alto);
//       var anch = double.parse(event.ancho);
//       var larg = double.parse(event.largo);
//       var pes = double.parse(event.peso);
//       var prec = double.parse(event.precio);
//       var validar = verificarTelefono(event.telefonoDes);
//       var ced = validarCedula(event.cedula);
//       if (!validar) {
//         RegisterProductState.failure(str_phone_incorrect);
//       } else if (!ced) {
//         RegisterProductState.failure(str_ci_incorrect);
//       } else {
//         if (alt == 0 || anch == 0 || larg == 0 || pes == 0 || prec == 0) {
//           String val = "";
//           if (alt == 0) {
//             val = "Alto";
//           } else if (anch == 0) {
//             val = "Ancho";
//           } else if (larg == 0) {
//             val = "Largo";
//           } else if (pes == 0) {
//             val = "Peso";
//           } else if (prec == 0) {
//             val = "Precio";
//           }
//           emit(RegisterProductState.failure(
//               "El valor $val debe ser diferente de cero"));
//         } else {
//           emit(RegisterProductState.success());
//         }
//       }
//     });
//   }
//   @override
//   RegisterProductState get initialState => RegisterProductState.empty();

//   @override
//   Stream<RegisterProductState> transform(
//     Stream<RegisterProductEvent> events,
//     Stream<RegisterProductState> Function(RegisterProductEvent event) next,
//   ) {
//     final observableStream = events;
//     final nonDebounceStream = observableStream.where((event) {
//       return (event is! NameChanged &&
//           event is! DireccionChanged &&
//           event is! PhoneChanged);
//     });
//     final debounceStream = observableStream.where((event) {
//       return (event is NameChanged ||
//           event is DireccionChanged ||
//           event is PhoneChanged);
//     }).debounceTime(const Duration(milliseconds: 300));
//     return transform(nonDebounceStream.mergeWith([debounceStream]), next);
//   }

//   @override
//   Stream<RegisterProductState> mapEventToState(
//     RegisterProductEvent event,
//   ) async* {
//     if (event is NameChanged) {
//       yield* _mapNameChangedToState(event.name!);
//     } else if (event is DireccionChanged) {
//       yield* _mapDireccionChangedToState(event.direccion!);
//     } else if (event is PhoneChanged) {
//       yield* _mapPhoneChangedToState(event.phone!);
//     } else if (event is DescripcionChanged) {
//       yield* _mapDescripcionChangedToState(event.descripcion!);
//     } else if (event is CedulaChanged) {
//       yield* _mapTipoChangedToState(event.cedula!);
//     } else if (event is EmailChanged) {
//       yield* _mapEmailChangedToState(event.email!);
//     } else if (event is NumeroChanged) {
//       yield* _mapNumeroChangedToState(event.numero!);
//     } else if (event is AnchoChanged) {
//       yield* _mapAnchoChangedToState(event.numero!);
//     } else if (event is LargoChanged) {
//       yield* _mapLargoChangedToState(event.numero!);
//     } else if (event is PesoChanged) {
//       yield* _mapPesoChangedToState(event.numero!);
//     } else if (event is PrecioChanged) {
//       yield* _mapPrecioChangedToState(event.numero!);
//     } else if (event is Submitted) {
//       yield* _mapFormSubmittedToState(event.telefonoDes, event.cedula,
//           event.alto, event.ancho, event.largo, event.peso, event.precio);
//     }
//   }

//   Stream<RegisterProductState> _mapNameChangedToState(String name) async* {
//     yield state.update(
//       isNameValid: Validators.isValidName(name),
//     );
//   }

//   Stream<RegisterProductState> _mapDireccionChangedToState(
//       String direccion) async* {
//     yield state.update(
//       isDireccionValid: Validators.isValidName(direccion),
//     );
//   }

//   Stream<RegisterProductState> _mapPhoneChangedToState(String phone) async* {
//     yield state.update(
//       isPhoneValid: Validators.isValidPhone(phone),
//     );
//   }

//   Stream<RegisterProductState> _mapDescripcionChangedToState(
//       String descripcion) async* {
//     yield state.update(
//       isDescripcionValid: Validators.isValidName(descripcion),
//     );
//   }

//   Stream<RegisterProductState> _mapTipoChangedToState(String cedula) async* {
//     yield state.update(
//       isCedulaValid: Validators.isValidDocumento(cedula),
//     );
//   }

//   Stream<RegisterProductState> _mapEmailChangedToState(String email) async* {
//     yield state.update(
//       isEmailValid: Validators.isValidEmail(email),
//     );
//   }

//   Stream<RegisterProductState> _mapNumeroChangedToState(String numero) async* {
//     yield state.update(
//       isNumeroValid: Validators.isValidDecimal(numero),
//     );
//   }

//   Stream<RegisterProductState> _mapAnchoChangedToState(String numero) async* {
//     yield state.update(
//       isAnchoValid: Validators.isValidDecimal(numero),
//     );
//   }

//   Stream<RegisterProductState> _mapLargoChangedToState(String numero) async* {
//     yield state.update(
//       isLargoValid: Validators.isValidDecimal(numero),
//     );
//   }

//   Stream<RegisterProductState> _mapPrecioChangedToState(String numero) async* {
//     yield state.update(
//       isPrecioValid: Validators.isValidDecimalPre(numero),
//     );
//   }

//   Stream<RegisterProductState> _mapPesoChangedToState(String numero) async* {
//     yield state.update(
//       isPesoValid: Validators.isValidDecimal(numero),
//     );
//   }

//   Stream<RegisterProductState> _mapFormSubmittedToState(
//       String telefono,
//       String cedula,
//       String alto,
//       String ancho,
//       String largo,
//       String peso,
//       String precio) async* {
//     var alt = double.parse(alto);
//     var anch = double.parse(ancho);
//     var larg = double.parse(largo);
//     var pes = double.parse(peso);
//     var prec = double.parse(precio);
//     var validar = verificarTelefono(telefono);
//     var ced = validarCedula(cedula);
//     if (!validar) {
//       yield RegisterProductState.failure(str_phone_incorrect);
//     } else if (!ced) {
//       yield RegisterProductState.failure(str_ci_incorrect);
//     } else {
//       if (alt == 0 || anch == 0 || larg == 0 || pes == 0 || prec == 0) {
//         String val = "";
//         if (alt == 0) {
//           val = "Alto";
//         } else if (anch == 0) {
//           val = "Ancho";
//         } else if (larg == 0) {
//           val = "Largo";
//         } else if (pes == 0) {
//           val = "Peso";
//         } else if (prec == 0) {
//           val = "Precio";
//         }
//         yield RegisterProductState.failure(
//             "El valor $val debe ser diferente de cero");
//       } else {
//         yield RegisterProductState.success();
//       }
//     }
//   }
// }
