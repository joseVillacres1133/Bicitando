import 'package:bloc/bloc.dart';
//import 'package:flutter/material.dart';

import './bloc.dart';

class HistorialBloc extends Bloc<HistorialEvent, HistorialState> {
  HistorialBloc() : super(HistorialInitial()) {
    on<DataReadyEvent>((event, emit) => emit(DataReadyState()));
    on<DataOnWayReadyEvent>((event, emit) => emit(DataOnWayReadyState()));
    on<SinDataEvent>((event, emit) => emit(SinDataState()));
  }
  HistorialState get initialState => HistorialInitial();
}
