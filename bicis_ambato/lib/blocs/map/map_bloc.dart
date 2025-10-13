import 'dart:async';

import 'package:bloc/bloc.dart';
//import 'package:meta/meta.dart';
import './bloc.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitialState()) {
    on<DestinityDoneEvent>((event, emit) {
      //emit(event.valor!, event.latitudDestino!, event.longitudDestino!)
    });
  }

  @override
  MapState get initialState => MapInitialState();

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is DestinityDoneEvent) {
      yield* _mapDestinityDoneToState(
          event.valor!, event.latitudDestino!, event.longitudDestino!);
    }
  }
}

Stream<MapState> _mapDestinityDoneToState(
    String valor, double latitud, double longitud) async* {}
