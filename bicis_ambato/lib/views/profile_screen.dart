import 'dart:async';
import 'dart:typed_data';

import 'package:bicis_ambato/blocs/app/settings/delete_account_counter_cubit.dart';
import 'package:bicis_ambato/style/style.dart';
import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_provider.dart';
import '../utils/constants_msg.dart';
import '../utils/sharedprefs_helper.dart';
import '../widget/profile/image_profile.dart';

class ProfileScreen extends StatefulWidget {
  Uint8List? bytesImage;
  AuthProvider? repository;
  ProfileScreen({super.key, this.bytesImage, this.repository})
      : assert(repository != null);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _prefs = Prefs();
  int counter = 0;
  late StreamController<int>? _events;
  late DeleteCounterCubbit counterCubit;

  final List<Map<String, dynamic>> statesVerification = [
    {"prefs": "none", "icon": Icons.verified_outlined, "color": greyColor,"text":"No verificado"},
    {"prefs": "unverified", "icon": Icons.verified_outlined, "color": greyColor,"text":"No verificado"},
    {"prefs": "locked", "icon": Icons.verified_outlined, "color": greyColor,"text":"Bloqueado"},
    {"prefs": "waiting", "icon": Icons.access_time_rounded, "color": greyColor,"text":"Esperando aprobación"},
    {"prefs": "rejected", "icon": Icons.cancel_outlined, "color": redColor,"text":"No aprobado"},
    {"prefs": "verified", "icon": Icons.verified_outlined, "color": greenColor,"text":"Verificado"},
  ];

  @override
  void initState() {
    super.initState();
    super.initState();
    _events = StreamController<int>();
    _events!.add(5);
    counterCubit = DeleteCounterCubbit();
  }

  @override
  Widget build(BuildContext context) {
    final String stateDocument = _prefs.verifiedUser;
    //final String stateDocument = "approved";
    Map<String,dynamic> map = findState(stateDocument);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => counterCubit,
          )
        ],
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            Navigator.pushReplacementNamed(context, 'home');
          },
          child: SafeArea(child:   
          Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Header(
                  nameScreen: str_profile,
                  route: str_rout_home,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ImageProfile(width: 75, height: 75,expadend:  true),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _prefs.userName,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: textStyleTitleGeneral,
                          ),
                          Text(
                            _prefs.email,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed("edit-profile");
                      },
                    ),
                  ],
                ),
                //const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.fromLTRB(50, 5, 50, 35),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: greyColor,
                      width: 1.0, // Grosor del borde
                      style: BorderStyle.solid, // Estilo (solid, dashed, etc.)
                    ),
                    borderRadius: BorderRadius.circular(
                        10.0), // Bordes redondeados (opcional)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("history");
                              },
                              child: const Icon(Icons.history)),
                          const Text(str_history)
                        ],
                      ),
                      SizedBox(
                        width: 1,
                        height: 50,
                        child: Container(
                          color: greyColor,
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(str_rout_help);
                              },
                              child: const Icon(Icons.help_outline_rounded)),
                          const Text(str_help)
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Información personal',
                      overflow: TextOverflow.fade,
                      style: textStyleTitleGeneral,
                    ),
                    Column(
                      children: [
                        Icon(
                          map["icon"],
                          color: map["color"],
                        ),
                        Text(
                          map["text"],
                          style: textStyleSmall,
                        ),
                      ],
                    )
                  ],
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Card(
                      elevation: 1,
                      //borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              leading:
                                  const Icon(Icons.contact_emergency_outlined),
                              title: Text(
                                _prefs.cedula,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: const Text(str_ci,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const Divider(
                              height: 1,
                            ),
                            ListTile(
                              leading: const Icon(Icons.other_houses_rounded),
                              title: Text(
                                _prefs.direccion,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: const Text(
                                str_address,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 1,
                            ),
                            ListTile(
                              leading: const Icon(Icons.phone_iphone_rounded),
                              title: Text(
                                _prefs.telefono,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: const Text(str_phone,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("change-psswd");
                  },
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: primaryColor,
                      //foregroundColor: whiteColor,
                      ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 48.0), // Adjust the padding as needed
                    child: Text(str_change_passwd),
                  ),
                ),
                const BarMunicipio()
              ],
            ),
          ),
        )
        
        
        ));
  }

  void alertDialogContDown(BuildContext ctx) {
    _events = StreamController<int>(); // Crea un nuevo StreamController
    _events!.add(5); // Agrega el valor inicial al Stream

    showDialog(
      context: ctx,
      builder: (BuildContext c) {
        return AlertDialog(
          backgroundColor: redColor,
          title: const Text(
            str_delete_account,
          ),
          content: StreamBuilder<int>(
            stream: _events!.stream, // Escucha el Stream aquí
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              counterCubit.setCounterValue(snapshot.data!);
              return Column(
                children: [
                  const Text(
                    'Todos tus datos se eliminaran de Bicitando',
                    style: TextStyle(color: whiteColor),
                  ),
                  Text(
                    '${snapshot.data}',
                    style: textStyleHeader,
                  ),
                ],
              );
            },
          ),
          actions: [
            counterCubit.state == 0
                ? IconButton(
                    onPressed: () {}, icon: const Icon(Icons.abc_outlined))
                : IconButton(
                    onPressed: () {}, icon: const Icon(Icons.ac_unit_outlined))
          ],
        );
      },
    ).then((_) {
      // Cerrar el StreamController cuando se cierre el diálogo

      _events!.close();
      AlertDialog(
          backgroundColor: activeColor,
          content: const Text('Quieres eliminar tu cuenta'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ]);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic> findState(String prefsValue) {
  return statesVerification.firstWhere(
    (state) => state["prefs"] == prefsValue,
    //orElse: () => state["prefs"] == "none"
  );
}
}
