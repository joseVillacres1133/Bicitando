// ignore_for_file: override_on_non_overriding_member

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:io';
import './bloc.dart';

class FingerprintBloc extends Bloc<FingerprintEvent, FingerprintState> {
  FingerprintBloc() : super(FingerprintState.initial());

  @override
  FingerprintState get initialState => FingerprintState.initial();

  @override
  Stream<FingerprintState> mapEventToState(
    FingerprintEvent event,
  ) async* {
    if (event is FingerprintChanged) {
      final mens = event.autorizado;

      yield state.update(mens: event.autorizado);

      if (mens == 'Autorizado') {
        //Verificar si reconocio la huella
        yield state.update(
            mens: '',
            isSuccess: true,
            isFailure:
                false); // Decir a la aplicación que la huella esta correcta
      } else {
        yield state.update(
            mens: '',
            isSuccess: false,
            isFailure: true); // Fallo el reconocimiento
      }
    } else {
      exit(0);
    }
  }
}
