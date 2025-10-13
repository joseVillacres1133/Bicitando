import 'dart:async';
import 'dart:io';

import 'package:bicis_ambato/blocs/app/bloc.dart';
import 'package:bicis_ambato/blocs/app/theme/theme_cubit.dart';
import 'package:bicis_ambato/blocs/auth/auth_bloc.dart';
import 'package:bicis_ambato/blocs/auth/bloc.dart';
import 'package:bicis_ambato/blocs/home_initial/bike_reserve_cubit.dart';
import 'package:bicis_ambato/blocs/qrcode/bloc.dart';
import 'package:bicis_ambato/blocs/qrcode/qr_data_cubit.dart';
import 'package:bicis_ambato/data/models/odoo/StopsAVehicle.dart';
import 'package:bicis_ambato/data/models/stationLine.dart';
import 'package:bicis_ambato/style/style.dart';
import 'package:bicis_ambato/utils/stations.dart';
import 'package:bicis_ambato/widget/camara_permission_screen.dart';
import 'package:bicis_ambato/widget/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/auth_provider.dart';
import '../../data/models/general/GeneralModels.dart';
import '../../data/models/odoo/Travel.dart';
import '../../data/models/vehicle.dart';
import '../../data/repository.dart';
import '../../utils/constants_msg.dart';
import '../../utils/sharedprefs_helper.dart';
import '../municipio_bar.dart';
import 'qr_scan.dart';

import 'dart:io' show Platform;

class MapReserve extends StatefulWidget {
  //Repository? repository;

  const MapReserve(Repository repository,
      {super.key, @required BuildContext? context});

  @override
  MapReserveState createState() => MapReserveState();
}

class MapReserveState extends State<MapReserve> {
  AuthProvider? _authProvider;
  final _prefs = Prefs();
  late Marker markerInicio;
  List<Marker> markers = [];
  List<GeoStation> geoStations = [];
  List<Marker> makerStations = [];
  late GeoStation infoGeoStaion;
  late Travel reserveActive;
  late List<Travel> reserveList = [];
  bool hideReserveList = false;

  Barcode? resultQR;

  //controlers
  MapController? _mapController;
  //QRViewController? controller;
  MobileScannerController?
      mobileScannerController; // Reemplazado QRViewController

  //time in use
  //String _stopwatchTime = '00:00:00';
  //late Stopwatch _stopwatch;
  Duration duartionStopwatch = const Duration(milliseconds: 1000);
  late bool showInfoMakerCard;
  late TabController _tabController;

  //var bikeReservedCubit = BikeReserveCubit();
  //late ThemeCubit themeCubit;

  @override
  initState() {
    super.initState();
    _mapController = MapController();
    _authProvider = AuthProvider();
    //themeCubit = ThemeCubit();
    initServices();
    showInfoMakerCard = false;
    //_stopwatch = Stopwatch();
    infoGeoStaion = GeoStation(-1, 'name', 'city', -1.2004536, -78.5961921);
    reserveActive = Travel(
        id: -1,
        name: '',
        state: '',
        vehicle: Vehicle(id: -1),
        startStation: GeoStation(-1, 'name', 'city', 0.0, 0.0));
  }

  setTimeToReserve(Travel travel) {
    String date = travel.date!; //"2024-06-25"
    String time = travel.time!; //"15:32:17"
// Parsear la fecha
    List<String> dateParts = date.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Parsear la hora original
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Restar 5 horas
    hours -= 5;

    // Crear el objeto DateTime combinando fecha y hora
    DateTime combinedDateTime =
        DateTime(year, month, day, hours, minutes, seconds);
    DateTime dateTime = DateTime.now();
    //_stopwatchTime
    duartionStopwatch = dateTime.difference(combinedDateTime);
    print(duartionStopwatch);
    //_stopwatch.start();
  }

  Future<List<Travel>> checkActiveReserve() async {
    List<Travel> items = [];
    await _authProvider!.generateNewSessionOdoo().then((value) async {
      if (!value) {
        var response = await _authProvider!.searchReserve();
        if (response.length == 0) {
          _prefs.activeService = false;
        } else {
          items = response;
          _prefs.idFrom = response[0].id;
          _prefs.activeService = true;
          //setTimeToReserve(response[0]);
        }
      }
    });

    //reserveList = response;
    return items;
  }

  Future<List<Travel>> getReserveList() async {
    return reserveList;
  }

  Future<void> initServices() async {
    //BikeReserveCubit bikeReserveCubit) async {
    _authProvider!.generateNewSessionOdoo().then((value) => {
          getGeoStations().then((value) async {
            if (value) {
              //&& !bikeReserveCubit.state.isReserved) {
              if (reserveList.isNotEmpty) {
                //bikeReserveCubit.isReserved();
                setState(() async {
                  reserveList = await checkActiveReserve();
                });
              }
              //print(response);
              setMakerStations();
            } else {
              Navigator.of(context).pushReplacementNamed("login");
              context.read<AuthBloc>().add(LoggedOut());
              showMessageAllScreen(str_title_wrong,
                  'Estamos teniendo problemas con el servidor 1');
            }
          })
        });
  }

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // }
    // controller!.resumeCamera();
  }

  void getResultScan(value) {
    setState(() {
      resultQR = value; // Actualiza el atributo en el estado de WidgetA
    });
  }

  dynamic getMyPosition() {
    var pos =
        LatLng(double.parse(_prefs.latitud), double.parse(_prefs.longitud));
    return pos;
  }

  void setMaker() {}

  @override
  void dispose() {
    super.dispose();
  }

  // Función para compartir en WhatsApp (reemplaza shareWhatsapp.share)
  void shareToWhatsApp(String text, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final encodedText = Uri.encodeQueryComponent(text);
    String whatsappUrl;

    if (Platform.isAndroid) {
      whatsappUrl = "whatsapp://send?phone=$cleanPhone&text=$encodedText";
    } else if (Platform.isIOS) {
      whatsappUrl = "whatsapp://send?phone=$cleanPhone&text=$encodedText";
    } else {
      whatsappUrl = "https://wa.me/$cleanPhone?text=$encodedText";
    }

    try {
      final uri = Uri.parse(whatsappUrl);

      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        final fallbackUrl =
            Uri.parse("https://wa.me/$cleanPhone?text=$encodedText");

        if (await canLaunchUrl(fallbackUrl)) {
          await launchUrl(
            fallbackUrl,
            mode: LaunchMode.externalApplication,
          );
        } else {
          await Share.share(text);
        }
      }
    } catch (e) {
      print('Error al intentar abrir WhatsApp: $e');
      await Share.share(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrCubit = context.watch<QrDataCubit>();
    final bikeReservedCubit = context.watch<BikeReserveCubit>();
    final themeCubit = context.watch<ThemeCubit>();
    DateTime dateTime = DateTime.now();

    //final geoStationCubit = context.watch<MakerInfoCubit>();
    // _stopwatch.start();
    // bikeReservedCubit.isReserved();

    //initServices();
    if (_prefs.activeService) {
      bikeReservedCubit.isReserved();
    }
    return PopScope(
        child: Scaffold(
            body: Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            //initialZoom: 20.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            initialCenter: LatLng(double.parse(_prefs.latitud.toString()),
                double.parse(_prefs.longitud.toString())),
            minZoom: 10.0,
            maxZoom: 20,
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              minZoom: 10.0,
              maxZoom: 25,
              // NetworkTileProvider con un User-Agent
              tileProvider: NetworkTileProvider(
                headers: {
                  'User-Agent': 'BicisAmbato/1.0.0 (info@mivilsoft.com)',
                },
              ),
              tileBuilder: _lightModeTileBuilder,
            ),
            MarkerLayer(markers: markers),
            MarkerLayer(markers: makerStations),
            // if (!bikeReservedCubit.state.isReserved)
            //   Align(
            //     alignment: const Alignment(0.0, 0.85),
            //     child: Container(
            //         margin: const EdgeInsets.only(top: 2.5),
            //         height: 65,
            //         width: 65,
            //         decoration: BoxDecoration(
            //           color: purplelight,
            //           borderRadius: BorderRadius.circular(
            //               50), // Hace que el contenedor sea redondo
            //         ),
            //         child: IconButton(
            //           onPressed: () async {
            //             if (infoGeoStaion.id == -1) {
            //               MessageDialog.show(
            //                   context,
            //                   str_has_reserve,
            //                   'Selecciona una estación para realizar una reserva',
            //                   () => {});
            //             } else if (vehiclesFree <= 0) {
            //               MessageDialog.show(
            //                   context,
            //                   'Lo sentimos',
            //                   '${infoGeoStaion.name} no tiene bicis disponibles',
            //                   () => {});
            //             } else {
            //               final result = await Navigator.of(context)
            //                   .push(MaterialPageRoute(
            //                 builder: (context) => QRViewScan(infoGeoStaion),
            //               ));
            //               if (result != null) {
            //                 if (_prefs.activeService) {
            //                   MessageDialog.show(context, str_has_reserve,
            //                       str_has_reserve_active, () => {});
            //                 } else {
            //                   if ( //_prefs.cedula == str_ci ||
            //                       _prefs.cedula == '') {
            //                     MessageDialog.show(
            //                         context,
            //                         str_has_reserve,
            //                         str_has_all_data,
            //                         () => {
            //                               Navigator.pushReplacementNamed(
            //                                   context, "edit-profile")
            //                             });
            //                   } else {
            //                     qrCubit.setQrValue(result);

            //                     MessageDialog.show(
            //                         context,
            //                         '¿Quieres generar una reserva?',
            //                         qrCubit.state, () async {
            //                       var registrationVehicle =
            //                           qrCubit.state.split(' ');
            //                       var result = await generateBikeReserve(
            //                           registrationVehicle[1]);
            //                       if (result == null) {
            //                         MessageDialog.show(
            //                             context,
            //                             'El vehículo no pertenecese a esa estación',
            //                             qrCubit.state,
            //                             () {});
            //                       } else if (result == true) {
            //                         //_stopwatch.start();
            //                         bikeReservedCubit.isReserved();
            //                       } else {
            //                         await stopBikeReserve(infoGeoStaion);
            //                         MessageDialog.show(
            //                             context,
            //                             'Algo salió mal intenta más tarde',
            //                             qrCubit.state,
            //                             () {});
            //                       }
            //                     });
            //                   }
            //                 }
            //               }
            //             }
            //           },
            //           icon: const Icon(Icons.qr_code_2_rounded),
            //           iconSize: 45,
            //           color: whiteColor,
            //         )),
            //   ),

            //),
          ],
        ),
        //if (bikeReservedCubit.state.isReserved)
        Positioned(
          top: 5,
          left: 15,
          right: 15,
          child: Container(
              decoration: BoxDecoration(
                color: grisARGB200,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                shape: BoxShape.rectangle,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      shape: BoxShape.rectangle,
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          str_reserve,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              setState(
                                  () => hideReserveList = !hideReserveList);

                              if (reserveList.isEmpty) {
                                final result = await checkActiveReserve();
                                setState(() => reserveList = result);
                              }
                            } catch (e) {
                              print('Error: $e');
                              // Mostrar snackbar o diálogo de error
                            }
                          },
                          icon: Icon(
                              hideReserveList
                                  ? Icons.expand_less_sharp
                                  : Icons.expand_more,
                              size: 30),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  hideReserveList
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height *
                                0.35, // 60% de pantalla
                          ),
                          //child: Card(
                          child: FutureBuilder(
                              future: reserveList.isEmpty
                                  ? checkActiveReserve()
                                  : getReserveList(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(
                                    color: secondary,
                                  );
                                } else {
                                  reserveList = snapshot.data!;
                                  return reserveList.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "No tienes reservas activas",
                                            style: TextStyle(color: blackColor),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: reserveList.length,
                                          itemBuilder: (context, index) {
                                            Travel travel;
                                            travel = reserveList[index];
                                            return Card(
                                                margin:
                                                    const EdgeInsets.all(2.0),
                                                child: ListTile(
                                                  leading: Image.asset(
                                                    img_travel,
                                                    height: 35,
                                                  ),
                                                  title: Text(travel.vehicle
                                                      .registrationVehicle!),
                                                  subtitle: Text(travel.date!),
                                                  trailing: IconButton(
                                                    onPressed: () {
                                                      GeoStation?
                                                          arrivaGeoStation =
                                                          searchNearestGeoStation();
                                                      if (arrivaGeoStation
                                                              .id! <=
                                                          0) {
                                                        showMessageAllScreen(
                                                            'Algo salio mal',
                                                            'No estas en una estacion');
                                                      } else {
                                                        MessageDialog.show(
                                                            context,
                                                            str_finish,
                                                            '¿Quieres finalizar tu reserva?',
                                                            () async {
                                                          //print(_stopwatchTime);
                                                          bool isSucces =
                                                              await stopBikeReserve(
                                                                  arrivaGeoStation);
                                                          if (isSucces) {
                                                            //_stopwatch.reset();
                                                            //_stopwatch.stop();
                                                            setState(() {
                                                              reserveList
                                                                  .remove(
                                                                      travel);
                                                            });
                                                            bikeReservedCubit
                                                                .initState();

                                                            qrCubit.setQrValue(
                                                                'noQr');
                                                          } else {
                                                            MessageDialog.show(
                                                                context,
                                                                'Error',
                                                                'algo salio mal',
                                                                () => {});
                                                          }
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.close_rounded),
                                                    iconSize: 20,
                                                  ),
                                                ));
                                          });
                                }
                              }),
                          //),
                        )
                      : const SizedBox(
                          height: 1,
                        )
                ],
              )),
        ),

        Align(
          alignment: const AlignmentDirectional(-0.95, 0.90),
          child: FloatingActionButton.small(
            backgroundColor: purplelight,
            heroTag: 'supportfab',
            onPressed: () => shareToWhatsApp(
              '*Equipo de atención al cliente*,\n Detecté un problema al devolver una bicicleta el ${dateTime.year}-${dateTime.month}-${dateTime.day}, y quisiera reportarlo. \n',
              '+593994154739',
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: whiteColor,
              size: 24,
            ),
          ),
        ),

        Align(
          alignment: const AlignmentDirectional(0.95, 0.70),
          child: FloatingActionButton.small(
              backgroundColor: purplelight,
              heroTag: 'reloadfab',
              onPressed: () {
                setState(() {
                  makerStations.clear();
                  infoGeoStaion =
                      GeoStation(-1, 'name', 'city', -1.2004536, -78.5961921);
                  initServices();
                });
              },
              child: const Icon(
                Icons.replay_circle_filled_outlined,
                color: whiteColor,
                size: 30,
              )),
        ),
        Align(
          alignment: const AlignmentDirectional(0.95, 0.90),
          child: FloatingActionButton(
            heroTag: 'locationfab',
            backgroundColor: secondary,
            onPressed: () {
              var pos = getMyPosition();
              _mapController?.move(pos, 18);
              setState(() {
                markers.clear();
                markerInicio = setMarkerInfo(
                  pointPass: LatLng(pos.latitude, pos.longitude),
                  iconData: Image.asset(
                    img_location,
                  ),
                  generalSizeCicleAvatar:
                      GeneralSizeCicleAvatar(25, 100, 50, 50),
                );

                markers.add(
                  markerInicio,
                );
              });
            },
            child: const Icon(
              Icons.location_on_rounded,
              size: 30,
            ),
          ),
        ),
        if (showInfoMakerCard)
          //prueba modal
          FutureBuilder(
            future: _showModalBottomSheet(
                infoGeoStaion, qrCubit, bikeReservedCubit, context),
            builder: (context, snapshot) {
              return const Text('');
            },
          ),

        //_showModalBottomSheet(infoGeoStaion)
        // FutureBuilder(
        //   future: _showModalBottomSheet(infoGeoStaion),//setInfoMakerCard(infoGeoStaion),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       // Mientras se carga el widget, puedes mostrar un indicador de progreso
        //       return Align(
        //           alignment: const AlignmentDirectional(0.00, -0.95),
        //           child: Container(
        //               width: MediaQuery.of(context).size.width * 0.85,
        //               height: MediaQuery.of(context).size.height * 0.25,
        //               decoration: const BoxDecoration(
        //                 //color: whiteColor,
        //                 borderRadius: BorderRadius.only(
        //                   topLeft: Radius.circular(20),
        //                   topRight: Radius.circular(20),
        //                 ),
        //                 shape: BoxShape.rectangle,
        //               ),
        //               child: Stack(
        //                 children: [
        //                   Align(
        //                       alignment: const AlignmentDirectional(
        //                           0.97, -0.97),
        //                       child: IconButton(
        //                         onPressed: () {
        //                           setState(() {
        //                             showInfoMakerCard = false;
        //                           });
        //                         },
        //                         icon: const Icon(
        //                           Icons.close_rounded,
        //                           // color: secondary,
        //                         ),
        //                       )),
        //                   const Align(
        //                       alignment: AlignmentDirectional(0, 0),
        //                       child: CircularProgressIndicator(
        //                         color: secondary,
        //                       )),
        //                 ],
        //               )));
        //     }
        //     else if (snapshot.hasError) {
        //       // Manejar el error si ocurre
        //       //return showMessageConnection() as Widget;
        //       return Text('Error: ${snapshot.error}');
        //     } else {
        //       // Cuando el widget se carga correctamente, lo muestras
        //       return Text('');//snapshot.data!;
        //     }
        //   },
        // ),
        Align(
          alignment: const AlignmentDirectional(0.00, 1),
          child: Container(
              //color: beige,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: const BoxDecoration(
                color: transparentColor,
              ),
              child: const BarMunicipio()),
        ),
      ],
    )));

    //);
  }

  Future<bool> getGeoStations() async {
    try {
      List<GeoStation> geoStationsOdoo = await _authProvider!.getGeoStations();
      geoStations = geoStationsOdoo;
      print(geoStations);
      return true;
    } on OdooException {
      _prefs.clearSession();
      Navigator.pushReplacementNamed(context, 'login');
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      showMessageAllScreen(
          str_title_wrong, 'Estamos teniendo problemas con el servidor 2');
      return false;
    }
  }

  Future<bool> searchReserveActive() async {
    try {
      reserveActive = (await _authProvider!.searchReserve())!;
      return true;
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  showMessageAllScreen(String titleMessage, String subtitle) async {
    return showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop(); // Cierra el AlertDialog
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: purplelight,
            content: ListTile(
              title: Text(
                titleMessage,
                style: const TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              subtitle: Text(
                subtitle, //Realiza Encomiendas, Transporte a donde desees',
                style: const TextStyle(color: whiteColor),
              ),
            ),
          );
        });
  }

  setMakerStations() {
    // makerStations = [];
    if (geoStations.isNotEmpty) {
      for (var geoStation in geoStations) {
        makerStations.add(setMarkerInfo(
            pointPass: LatLng(geoStation.lat!, geoStation.long!),
            iconData: Image.asset(
              maker_station,
            ),
            generalSizeCicleAvatar: GeneralSizeCicleAvatar(45, 100, 45, 45),
            geoStation: geoStation,
            isSelected: selectedMarkerId == geoStation.id.toString()));
      }
    }
  }

  int countFreeVehicles(List<StationLine> stationsLine) {
    int freeVehicles = 0;
    for (var stationLine in stationsLine) {
      if (stationLine.isFree) {
        freeVehicles += 1;
      }
    }
    return freeVehicles;
  }

  int vehiclesFree = -1;
  List<StationLine> stationsLine = [];

  Future _showModalBottomSheet(GeoStation geoStation, QrDataCubit qrCubit,
      BikeReserveCubit bikeReservedCubit, BuildContext context) async {
    print('setInfoMakerCard');
    List<int?> geoStationsIds = [];
    geoStationsIds.add(geoStation.id);
    stationsLine = await _authProvider!.getGeoStationsLine(geoStationsIds);
    vehiclesFree = countFreeVehicles(stationsLine);

    var pos = LatLng(geoStation.lat!, geoStation.long!);
    _mapController?.move(pos, 13);
    if (!mounted) return;
    return showModalBottomSheet(
      context: context,
      builder: (context) => DefaultTabController(
        length: 2,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          // Solución clave 1: Altura fija en el contenedor padre
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max, // Solución clave 2
              children: [
                // Parte superior (tu contenido existente)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Image.asset(
                                maker_station,
                                height: 55,
                              ),
                              title: Text(
                                geoStation.name!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(geoStation.city!),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (infoGeoStaion.id == -1) {
                                MessageDialog.show(
                                  context,
                                  str_has_reserve,
                                  'Selecciona una estación para realizar una reserva',
                                  () => {},
                                );
                              } else if (vehiclesFree <= 0) {
                                MessageDialog.show(
                                  context,
                                  'Lo sentimos',
                                  '${infoGeoStaion.name} no tiene bicis disponibles',
                                  () => {},
                                );
                              } else {
                                // 1) Pedir permiso de cámara si hace falta
                                final ok = await _ensureCameraPermission();
                                if (!ok) {
                                  // El usuario no concedió: salimos sin abrir el escáner
                                  return;
                                }

                                // 2) Permiso concedido → abrimos el QR Scanner
                                final result =
                                    await Navigator.of(context).push<String?>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QRViewScan(infoGeoStaion),
                                  ),
                                );

                                // 3) Procesa el resultado si lo hay
                                if (result != null) {
                                  if (_prefs.activeService && _prefs.isUser) {
                                    MessageDialog.show(
                                      context,
                                      str_has_reserve,
                                      str_has_reserve_active,
                                      () => {},
                                    );
                                  } else {
                                    if (_prefs.cedula ==
                                        '' /* o tu condición */) {
                                      MessageDialog.show(
                                        context,
                                        str_has_reserve,
                                        str_has_all_data,
                                        () => Navigator.pushReplacementNamed(
                                            context, "edit-profile"),
                                      );
                                    } else {
                                      qrCubit.setQrValue(result);
                                      MessageDialog.show(
                                        context,
                                        '¿Quieres generar una reserva?',
                                        qrCubit.state,
                                        () async {
                                          var registrationVehicle =
                                              qrCubit.state.split(' ');
                                          var res = await generateBikeReserve(
                                              registrationVehicle[1]);
                                          if (res == null) {
                                            MessageDialog.show(
                                              context,
                                              'El vehículo no pertenecese a esa estación',
                                              qrCubit.state,
                                              () => {},
                                            );
                                          } else if (res == true) {
                                            bikeReservedCubit.isReserved();
                                          } else {
                                            await stopBikeReserve(
                                                infoGeoStaion);
                                            MessageDialog.show(
                                              context,
                                              'Algo salió mal intenta más tarde',
                                              qrCubit.state,
                                              () => {},
                                            );
                                          }
                                        },
                                      );
                                    }
                                  }
                                }

                                // 4) Cerrar el modal de estaciones si estaba abierto
                                Navigator.pop(context);
                              }
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.qr_code_2_rounded),
                                Text('Scan QR'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 48,
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Disponibles  ($vehiclesFree)'),
                      Tab(
                          text:
                              'Ocupadas  (${stationsLine.length - vehiclesFree})'),
                    ],
                  ),
                ),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: TabBarView(
                          children: [
                            _buildVehicleList(
                              filteredList:
                                  stationsLine.where((s) => s.isFree).toList(),
                              emptyMessage: 'No hay bicicletas disponibles',
                            ),
                            //)),
                            // ),
                            _buildVehicleList(
                              filteredList:
                                  stationsLine.where((s) => !s.isFree).toList(),
                              emptyMessage: 'No hay bicicletas ocupados',
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((value) {
      setState(() {
        showInfoMakerCard = false;
      });
    });
  }

  Widget _buildVehicleList({
    required List<StationLine> filteredList,
    required String emptyMessage,
  }) {
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              StationLine stationLine;
              stationLine = filteredList[index];
              return stationLine.isFree
                  ? Card(
                      child: _buildListTile(stationLine),
                    )
                  : Card.filled(
                      child: _buildListTile(stationLine),
                    );
            })
        : Center(child: Text(emptyMessage));
  }

  // Widget _buildListTile(StationLine station) {
  //   return ListTile(
  //     leading: Image.asset(img_bike, height: 35),
  //     title: Text(station.vehicle.model!),
  //     trailing: Icon(
  //       station.isFree ? Icons.check_circle : Icons.cancel,
  //       color: station.isFree ? greenColor : redColor,
  //     ),
  //   );
  // }

  Widget _buildListTile(StationLine station) {
    return ListTile(
      leading: Image.asset(img_bike, height: 35),
      title: Text(station.vehicle.model!),
      // Sustituye el antiguo trailing por un Row con el icono de estado + la batería
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tu icono de free/occupied
          Icon(
            station.isFree ? Icons.check_circle : Icons.cancel,
            color: station.isFree ? greenColor : redColor,
          ),
          const SizedBox(width: 8),
          // Aquí el FutureBuilder para la batería
          FutureBuilder<double>(
            future: AuthProvider().readBattery(station.vehicle.id),
            builder: (ctx, snap) {
              print('Estados batería BICI: ${station.vehicle.id}');

              if (snap.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
              if (snap.hasError) {
                return const Icon(Icons.battery_unknown, size: 24);
              }
              final voltage = snap.data!;

              // Usa distintos iconos según nivel
              IconData icon;
              if (voltage >= 4.0) {
                icon = Icons.battery_full;
              } else if (voltage >= 3.5) {
                icon = Icons.battery_3_bar;
              } else {
                icon = Icons.battery_alert;
              }
              return Icon(icon, size: 24);
            },
          ),
        ],
      ),
    );
  }

  Future<Widget> setInfoMakerCard(GeoStation geoStation) async {
    //GeoStation geoStation = seacrhGeoStation('C1');
    print('setInfoMakerCard');
    List<int?> geoStationsIds = [];
    geoStationsIds.add(geoStation.id);
    stationsLine = await _authProvider!.getGeoStationsLine(geoStationsIds);
    vehiclesFree = countFreeVehicles(stationsLine);

    var pos = LatLng(geoStation.lat!, geoStation.long!);
    _mapController?.move(pos, 18);
    return Align(
        alignment: const AlignmentDirectional(0.00, -0.95),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                shape: BoxShape.rectangle,
              ),
              child: Stack(
                children: [
                  Align(
                      alignment: const AlignmentDirectional(0.97, -0.97),
                      child: IconButton(
                          onPressed: () => {
                                setState(() {
                                  showInfoMakerCard = false;
                                })
                              },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: secondary,
                          ))),
                  Align(
                    alignment: const AlignmentDirectional(-0.85, -0.90),
                    child: Text(
                      '${geoStation.name}'.toUpperCase(),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-0.85, -0.5),
                    child: Text(
                      '${geoStation.city}',
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.55, -0.5),
                    child: Text(
                      'Bicis: ${stationsLine.length}',
                    ),
                  ),
                  Align(
                      alignment: const AlignmentDirectional(-0.7, 0.8),
                      child: Image.asset(
                        img_bike,
                        height: 100,
                      )),
                  Align(
                      alignment: const AlignmentDirectional(0.8, 0.8),
                      child: Card(
                          // decoration: const BoxDecoration(
                          //   color: greyColor,
                          //   borderRadius: BorderRadius.all(Radius.circular(5)),
                          //   shape: BoxShape.rectangle,
                          // ),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.height * 0.13,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'Disponibles',
                                  ),
                                  Text(
                                    '$vehiclesFree',
                                  ),
                                  const Text('Ocupadas',
                                      style: TextStyle(color: secondary)),
                                  Text(
                                    '${stationsLine.length - vehiclesFree}',
                                  ),
                                ],
                              )))),
                ],
              )),
        ));
  }

  String? selectedMarkerId; // Variable para rastrear el marcador seleccionado

  Marker setMarkerInfo({
    required LatLng pointPass,
    required Widget iconData,
    required GeneralSizeCicleAvatar generalSizeCicleAvatar,
    GeoStation? geoStation,
    bool isSelected = false, // Nuevo parámetro para controlar el estado
  }) {
    Color colorSelected = beige;
    return Marker(
      rotate: true,
      width: generalSizeCicleAvatar.widthImage,
      height: generalSizeCicleAvatar.heightImage,
      point: pointPass,
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(4), // Espacio para el efecto
          decoration: BoxDecoration(
              color: Color.fromARGB(209, 255, 255,
                  255), //Color.fromARGB(197, 255, 255, 255), //isSelected ? Colors.white.withOpacity(0.8) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: purple, width: 1)
              //isSelected
              // ? Border.all(color: Colors.black, width: 10)
              // : null,
              ),
          child: iconData,
        ),
        onTap: () {
          print(geoStation.toString());
          setState(() {
            colorSelected = whiteColor;
            infoGeoStaion = geoStation!;
            showInfoMakerCard = true;
            selectedMarkerId =
                geoStation.id.toString(); // Asume que tienes un ID único
          });
        },
      ),
    );
  }

  StationLine? searchVehicle(String registrationVehicle) {
    for (var stationLine in stationsLine) {
      if (stationLine.vehicle.registrationVehicle!.split("/").last ==
              registrationVehicle &&
          stationLine.isFree) {
        return stationLine;
      }
    }
    return null;
  }

  Future<dynamic> generateBikeReserve(String data) async {
    print("entraaaaa  generateBikeReserve");
    StationLine? stationLine = searchVehicle(data);
    if (stationLine != null) {
      try {
        await _authProvider!.generateReserve(stationLine).then((value) async {
          _prefs.idFrom = value;
          var result =
              await _authProvider!.sendCommandTraccar(stationLine.vehicle.id);
          DateTime dateNow = DateTime.now();
          String formatDate = DateFormat('dd/MM/yyyy').format(dateNow);
          Travel travelGenerated = Travel(
              id: value,
              name: '',
              state: 'active',
              vehicle: stationLine.vehicle,
              startStation: infoGeoStaion,
              date: formatDate);
          setState(() {
            reserveList.add(travelGenerated);
            _prefs.activeService = true;
            //showInfoMakerCard = !showInfoMakerCard;
          });
          print(result);
          print(value);
        });
        return true;
      } on OdooException catch (odooE) {
        print(odooE);
        return odooE;
      } on SocketException catch (odooSE) {
        print(odooSE);
        return odooSE;
      }
    } else {
      return null;
    }
    // setState(() {
    //   isReserve = true;
    // });
  }

  double millisecondsToHour(dynamic milliseconds) {
    return (milliseconds / 3600000);
  }

  double millisecondsToMinutes(dynamic milliseconds) {
    return ((milliseconds / 60000) % 60);
  }

  double millisecondsToSeconds(dynamic milliseconds) {
    return ((milliseconds / 1000) % 60);
  }

  Future<bool> stopBikeReserve(GeoStation arrivaGeoStation) async {
    try {
      var response =
          await _authProvider!.stopReserve(arrivaGeoStation, _prefs.idFrom);
      _prefs.activeService = false;
      //duartionStopwatch = const Duration(milliseconds: 1000);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _ensureCameraPermission() async {
    // 1) Comprueba el estado actual
    final status = await Permission.camera.status;

    // Si ya está concedido, devolvemos true
    if (status.isGranted) return true;

    // Si fue denegado permanentemente, abrimos la configuración
    if (status.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Permisos de cámara requeridos'),
          content: Text(
              'Para usar el escáner QR necesitas el permiso de cámara. Actívalo en ajustes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('Abrir ajustes'),
            ),
          ],
        ),
      );
      return false;
    }

    // Si no está concedido (o fue denegado una vez), mostramos tu pantalla personalizada
    final granted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (ctx) => CameraPermissionScreen(
          onCameraGranted: () => Navigator.of(ctx).pop(true),
          onCameraDenied: () => Navigator.of(ctx).pop(false),
          canSkip: false, // o true, según tu flujo
        ),
      ),
    );

    return granted ?? false;
  }

  GeoStation searchNearestGeoStation() {
    var pos = getMyPosition();
    GeoStation? geoStation = HaversineDistance.getNearestStation(
        pos.latitude, pos.longitude, geoStations, 0.1);
    if (geoStation.id! > 0) {
      print(geoStation.name);
      print(geoStation.distance);
    }
    return geoStation;
  }

  Widget _darkModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -0.2126, -0.7152, -0.0722, 0, 255, // Red channel
        -0.2126, -0.7152, -0.0722, 0, 255, // Green channel
        -0.2126, -0.7152, -0.0722, 0, 255, // Blue channel
        0, 0, 0, 1, 0, // Alpha channel// Alpha channel
      ]),
      child: tileWidget,
    );
    // return ColorFiltered(
    //   colorFilter: const ColorFilter.matrix(<double>[
    //     -0.2126, -0.7152, -0.0722, 0, 255, // Red channel
    //     -0.2126, -0.7152, -0.0722, 0, 255, // Green channel
    //     -0.2126, -0.7152, -0.0722, 0, 255, // Blue channel
    //     0, 0, 0, 1, 0, // Alpha channel
    //   ]),
    //   child: tileWidget,
    // );
  }
}

Widget _lightModeTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0, // Red channel
      0, 1, 0, 0, 0, // Green channel
      0, 0, 1, 0, 0, // Blue channel
      0, 0, 0, 1, 0, // Alpha channel
    ]),
    child: tileWidget,
  );
}
