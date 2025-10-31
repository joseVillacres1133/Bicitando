import 'package:bicis_ambato/blocs/home_initial/bike_reserve_cubit.dart';
import 'package:bicis_ambato/widget/home/drawer.dart';
import 'package:bicis_ambato/widget/home/map_reserve.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/qrcode/qr_data_cubit.dart';
import '../data/repository.dart';
import '../utils/constants_msg.dart';

class HomeScreen extends StatefulWidget {
  final double? latitud;
  final double? longitud;
  final Repository _repository;
  Function? functionUpdate;

  // Uint8List? _bytesImage;

  HomeScreen(
      {super.key,
      required Repository repository,
      this.latitud,
      this.longitud,
      this.functionUpdate})
      : _repository = repository;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => QrDataCubit()),
          BlocProvider(create: (context) => BikeReserveCubit())
        ],
        child: PopScope(
            child: SafeArea(
          child: Scaffold(
            key: _scaffoldkey,
            drawer: const DrawerApp(),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.menu),
                  //color: blue1,
                  onPressed: () {
                    _scaffoldkey.currentState!.openDrawer();
                  }),
              flexibleSpace: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
                  child: const Center(
                    child: Image(
                      image: ExactAssetImage(img_logo),
                      fit: BoxFit
                          .scaleDown, // Para ajustar la imagen dentro del espacio flexible
                    ),
                  )),
            ),
            body: MapReserve(
              widget._repository,
              context: context,
            ),
          ),
        )));
  }
}
