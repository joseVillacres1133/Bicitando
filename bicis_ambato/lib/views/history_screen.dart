import 'package:bicis_ambato/blocs/historial/filter_history_cubit.dart';
import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/history.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_provider.dart';
import '../data/models/odoo/Travel.dart';
import '../data/repository.dart';
import '../style/style.dart';
import '../utils/constants_msg.dart';

class HistoryScreen extends StatefulWidget {
  //final Repository? _repository;

  HistoryScreen(
      {super.key,
      @required Repository? repository,
      @required BuildContext? context})
      : assert(repository != null);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Travel> travels = [];
  late AuthProvider authProvider;
  FilterTravelCubit? filterDateCubit;
  late String dateFilter;
  late int stateFilter;

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider();
    filterDateCubit = FilterTravelCubit();
    dateFilter = '';
    stateFilter = 0;
  }

  @override
  void dispose() {
    super.dispose();
    filterDateCubit!.close();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, 'home');
        },
        child: SafeArea(child: 
        Scaffold(
            body: MultiBlocProvider(
                providers: [
              BlocProvider(create: (context) => filterDateCubit!)
            ],
                child: Stack(children: [
                  Header(nameScreen: str_history, route: str_rout_home),
                  Align(
                    alignment: const AlignmentDirectional(0.00, -0.79),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.width * 0.30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          img_history,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: const AlignmentDirectional(0.5, -0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 25,
                            child: GestureDetector(
                                onTap: () {
                                  _datePicker();
                                  //print(date);
                                },
                                child: const Icon(Icons.calendar_month)),
                          ),
                          SizedBox(
                              width: 40,
                              child: PopupMenuButton<int>(
                                  onSelected: (value) {
                                    stateFilter = value;
                                    if (isFilter == true) {
                                      stateFilter = 0;
                                      filterDateCubit!.setFilterState(
                                          dateFilter, stateFilter);
                                      setState(() {
                                        isFilter = !isFilter;
                                      });
                                    } else {
                                      filterDateCubit!.setFilterState(
                                          dateFilter, stateFilter);
                                    }
                                    print(value);
                                  },
                                  itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Text(
                                            str_status_finish,
                                            style: TextStyle(),
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 2,
                                          child: Text(
                                            str_status_on_way,
                                            style: TextStyle(),
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 3,
                                          child: Text(
                                            str_status_cancelled,
                                            style: TextStyle(),
                                          ),
                                        ),
                                      ],
                                  icon: !isFilter
                                      ? const Icon(Icons.filter_alt)
                                      : const Icon(
                                          Icons.filter_alt_off_rounded))),
                          SizedBox(
                              width: 26,
                              child: GestureDetector(
                                  onTap: () {
                                    stateFilter = 0;
                                    dateFilter = '';
                                    filterDateCubit!.setFilterState(
                                        dateFilter, stateFilter);
                                  },
                                  child: const Icon(
                                    Icons.filter_alt_off_rounded,
                                    color: activeColor,
                                  ))),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      )),
                  Align(
                      alignment: const AlignmentDirectional(0, 1.0),
                      child: Container(
                          margin: const EdgeInsetsDirectional.only(bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.63,
                          padding: const EdgeInsets.only(top: 10, bottom: 30),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            shape: BoxShape.rectangle,
                          ),
                          child: History())),
                  Align(
                    alignment: const AlignmentDirectional(0.00, 1),
                    child: Container(
                        //color: beige,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: transparentColor,
                        ),
                        child: const BarMunicipio()),
                  ),
                ])))
        )
                
                );
  }

  bool isFilter = false;
  _datePicker() async {
    String dateChange;
    await showDialog(
        context: context,
        builder: (context) {
          return LayoutBuilder(builder: (_, constraints) {
            return Center(
              //color: transparentColor,
              child: Card(
                //width: width * 0.8,
                // decoration: const BoxDecoration(
                //color: beige,
                //  borderRadius: BorderRadius.all(Radius.circular(20)),
                //  shape: BoxShape.rectangle,
                // ), // cant managed being expanded
                child: CalendarDatePicker(
                  ///initialDate: DateTime.now().subtract(const Duration(days: 30)),
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime(2100),
                  onDateChanged: (DateTime value) {
                    //print(geDateValueOfPicker(value));
                    dateChange = geDateValueOfPicker(value);
                    //value.
                    dateFilter = dateChange;
                    filterDateCubit!.setFilterState(dateFilter, stateFilter);
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
            );
          });
        });
  }

  String geDateValueOfPicker(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    String str_month = '';
    int day = dateTime.day;
    String str_day = '';
    String date;
    if (month < 10) {
      str_month = '0$month';
    } else {
      str_month = '$month';
    }
    if (day < 10) {
      str_day = '0$day';
    } else {
      str_day = '$day';
    }
    date = '$year-$str_month-$str_day';

    return date;
  }
}
