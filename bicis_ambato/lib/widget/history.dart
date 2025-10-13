import 'dart:async';
import 'dart:io';

import 'package:bicis_ambato/blocs/historial/bloc.dart';
import 'package:bicis_ambato/data/auth_provider.dart';
import 'package:bicis_ambato/style/style.dart';
import 'package:bicis_ambato/widget/item_travel_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/odoo/Travel.dart';
import '../utils/constants_msg.dart';

// ignore: must_be_immutable
class History extends StatefulWidget {
  List<Travel> travels = [];

  History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late AuthProvider authProvider;
  bool isLoading = true;
  late List<Travel> travels;
  late List<Travel> searchTravels;

  @override
  void initState() {
    super.initState();
    travels = [];
    searchTravels = [];
    authProvider = AuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    final filterDateCubit = context.watch<FilterTravelCubit>();

    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => filterDateCubit,
      )
    ], child: listViewTravels(filterDateCubit));
  }

  String getState(int valueState) {
    if (valueState == 1) {
      return 'finished';
    }
    if (valueState == 2) {
      return 'active';
    }
    if (valueState == 3) {
      return 'cancelled';
    }
    return '';
  }

  List<Travel> filterStateTravel(List<Travel> travels, String state) {
    List<Travel> filterTravels = [];
    if (state != '') {
      for (var travel in travels) {
        if (travel.state == state) {
          filterTravels.add(travel);
        }
      }
      return filterTravels;
    } else {
      return travels;
    }
  }

  List<Travel> filterDateTravel(List<Travel> travels, String date) {
    List<Travel> filterTravels = [];
    if (date != '') {
      for (var travel in travels) {
        if (travel.date == date) {
          filterTravels.add(travel);
        }
      }
      return filterTravels;
    } else {
      return travels;
    }
  }

  Future<List<Travel>> filterTravels(String date, int stateTravel) async {
    String valueState = getState(stateTravel);
    List<Travel> auxTravels = [];
    if (date == '' && stateTravel == 0) {
      searchTravels = travels;
      return searchTravels;
    } else {
      auxTravels = filterDateTravel(travels, date);
      auxTravels = filterStateTravel(auxTravels, valueState);
      searchTravels = auxTravels;
      return searchTravels;
    }
  }

  Widget listViewTravels(Cubit filterCubit) {
    searchTravels = [];

    return FutureBuilder(
        future: travels.isEmpty
            ? loadTravels()
            : filterTravels(filterCubit.state.filterDate,
                filterCubit.state.filterStateTravel),
        builder: (context, resultH) {
          if (resultH.connectionState == ConnectionState.waiting) {
            //if (resultH.error is SocketException) {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          } else 
          if (resultH.hasData == true && resultH.data!.isEmpty) {
            return const Center(child: Text('No tienes reservas'));
          } else if (resultH.hasError == true || resultH is SocketException) {
            return const Center(child: Text('Intenta más tarde'));
          } else {
            return ListView.builder(
                itemCount: searchTravels.isEmpty
                    ? resultH.data!.length
                    : searchTravels.length,
                itemBuilder: (context, index) {
                  Travel travel;
                  if (searchTravels.isEmpty) {
                    travel = travels[index];
                  } else {
                    travel = searchTravels[index];
                  }
                  return ItemTravel(travel);

                  //     ListTile(
                  //   title: Text(travel.name),
                  //   subtitle: Text(travel.state!),
                  // );
                });
          }
        });
  }

  showMessageConnection() {
    return showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context).pop(); // Cierra el AlertDialog
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: purplelight,
            content: const ListTile(
              title: Text(
                str_title_wrong,
                style: TextStyle(
                    //color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              subtitle: Text(
                'Necesitas conectarte a internet', //Realiza Encomiendas, Transporte a donde desees',
                //style: TextStyle(color: whiteColor
               // ),
              ),
            ),
          );
        });
  }

  Future<List<Travel>> loadTravels() async {
    var data = await authProvider.getTravels();
    if (data!.isNotEmpty) {
      travels = data;
      //searchTravels = travels;
      print('load Travels setState');
    } else {
      travels = [];
    }

    return travels;
    //showMessageConnection();
  }
}
