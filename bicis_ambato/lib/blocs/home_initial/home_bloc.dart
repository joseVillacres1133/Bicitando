import 'dart:io';

import 'package:bicis_ambato/data/auth_provider.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import './bloc.dart';

class HomeInitialBloc extends Bloc<HomeEvent, HomeStateReserved> {
  Prefs prefs = Prefs();
  AuthProvider authProvider = AuthProvider();
  HomeInitialBloc() : super(HomeStateReserved.empty()) {
    on<HomeCheckStatusEvent>(
      (event, emit) async {
        var response = await authProvider.searchReserve();
        if (response.id == -1) {
          prefs.activeService = false;
          emit(HomeStateReserved.noReserved());
          return response;
        } else {
          prefs.idFrom = response.id;
          prefs.activeService = true;
          emit(HomeStateReserved.reserved());
          ///setTimeToReserve(response);
          //return response;
        }
      },
    );
    on<SubmittedNewReserve>((event, emit) async {
      try {
        await authProvider.generateReserve(event.stationLine).then((value) async {
          prefs.idFrom = value;
          var result =
              await authProvider.sendCommandTraccar(595);
          print(result);
          //print(value"")
          //print("asdasd "+event.stationLine.vehicle.id);
        });
        prefs.activeService = true;
        //return true;
      } on OdooException catch (odooE) {
        print(odooE);
        //return odooE;
      } on SocketException catch (odooSE) {
        print(odooSE);
        //return odooSE;
      }
    });
    on<SubmittedStopReserve>((event, emit) async {
      try {
      var response =
          await authProvider.stopReserve(event.arrivaGeoStation, prefs.idFrom);
      prefs.activeService = false;
      emit(HomeStateReserved.noReserved());
    } catch (e) {
      print(e);
    }

    });
    on<HomeMessageREvent>((event, emit) => {});
  }

  HomeState get initialState => HomeEmptyState();
}
