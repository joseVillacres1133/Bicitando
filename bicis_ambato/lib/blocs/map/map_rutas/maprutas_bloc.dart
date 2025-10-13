import 'dart:async';

import 'package:bloc/bloc.dart';
import './bloc.dart';

class MaprutasBloc extends Bloc<MaprutasEvent, MaprutasState> {
  MaprutasBloc() : super(MaprutasInitial()) {
    on<PoscicionConductorEvent>((event, emit) => emit(PosicionConducorState(
        event.latitudConductor!, event.longitudConductor!)));
    on<MessageConductorEvent>((event, emit) =>
        emit(MessageConductorState(valMessage: event.valMessage)));
    on<MessageConductorGrEvent>(
        (event, emit) => MessageConductorGrState(valMessage: event.valMessage));
    on<RealizarViajeFinalEvent>(
        (event, emit) => emit(RealizarViajeFinalState()));
  }
  MaprutasState get initialState => MaprutasInitial();

  Stream<MaprutasState> mapEventToState(
    MaprutasEvent event,
  ) async* {
    if (event is PoscicionConductorEvent) {
      yield* _mapPoscicionConductorToState(
          event.latitudConductor!, event.longitudConductor!);
    } else if (event is MessageConductorEvent) {
      yield* _mapMessageConductorToState(event.valMessage!);
    } else if (event is MessageConductorGrEvent) {
      yield* _mapMessageConductorGrToState(event.valMessage!);
    } else if (event is RealizarViajeFinalEvent) {
      yield* _mapRealizarViajeFinalToState();
    }
  }

  Stream<MaprutasState> _mapPoscicionConductorToState(
      double latitud, double longitud) async* {
    yield PosicionConducorState(latitud, longitud);
  }

  Stream<MaprutasState> _mapMessageConductorToState(String mensaje) async* {
    yield MessageConductorState(valMessage: mensaje);
  }

  Stream<MaprutasState> _mapMessageConductorGrToState(String mensaje) async* {
    yield MessageConductorGrState(valMessage: mensaje);
  }

  Stream<MaprutasState> _mapRealizarViajeFinalToState() async* {
    yield RealizarViajeFinalState();
  }
}
