// ignore_for_file: missing_required_param, override_on_non_overriding_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import './bloc.dart';

class RutasBloc extends Bloc<RutasEvent, RutasState> {
  RutasBloc() : super(DriverRutasState());
  RutasState get initialState => RutasLoading();

  @override
  Stream<RutasState> mapEventToState(
    RutasEvent event,
  ) async* {
    if (event is TipoRutas) {
      yield* _mapRutasToState();
    } else if (event is DriverRutas) {
      yield* _mapDriverRutasToState(event.imagen!, event.listItem!);
    } else if (event is DriverDetail) {
      yield* _mapDriverDetailToState(
          event.imagen!,
          event.conductor!,
          event.placa!,
          event.tipoAuto!,
          event.telefono!,
          event.score!,
          event.typeService!);
    } else if (event is CamionsDetail) {
      yield* _mapCamionsDetailToState(
          event.imagen!, event.kilometro!, event.listItem!);
    } else if (event is RutasEmpty) {
      yield* _mapDriverToState();
    } else if (event is RutasLoadingEvent) {
      yield* _mapRutasLoadingtoState();
    }
  }
}

Stream<RutasState> _mapRutasLoadingtoState() async* {
  yield RutasLoading();
}

Stream<RutasState> _mapRutasToState() async* {
  yield RutasExistentes();
}

Stream<RutasState> _mapDriverToState() async* {
  yield LoadingDrivers();
}

Stream<RutasState> _mapDriverRutasToState(
    String im, List<Map<String, dynamic>> listItem) async* {
  yield DriverRutasState(imageAsset: im, listItem: listItem);
}

Stream<RutasState> _mapDriverDetailToState(String im, String con, String plac,
    String tip, String tel, double score, String typeService) async* {
  yield DriverSelectedState(
      imageAsset: im,
      conductor: con,
      placa: plac,
      telefono: tel,
      tipoAuto: tip,
      score: score.toStringAsFixed(1),
      typeService: typeService.toString());
}

Stream<RutasState> _mapCamionsDetailToState(
    String im, String km, List<Map<String, dynamic>> listItem) async* {
  yield CamionSelectedState(
      imageAsset: im, kilometro: double.parse(km), listItem: listItem);
}
