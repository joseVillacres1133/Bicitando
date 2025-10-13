import 'package:bicis_ambato/blocs/app/bloc.dart';
import 'package:bicis_ambato/style/style.dart';
import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:bicis_ambato/widget/profile/image_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/bloc.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({
    super.key,
  });

  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  late Prefs _prefs;
  AuthBloc? _authBloc;

  @override
  void initState() {
    super.initState();
    _prefs = Prefs();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageProfile(
                      width: 75,
                      height: 75,
                      expadend: false,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                str_hi,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Text(
                                _prefs.userName,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                            ),
                          ]),
                    ),
                  ])),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "profile");
            },
          ),
          ListTile(
            leading: const Icon(Icons.pedal_bike_sharp),
            title: const Text('Historial'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file_rounded),
            title: const Text('Términos y condiciones'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'terms');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ayuda'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'help');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Tema oscuro'),
            trailing: Switch(
              value: themeCubit.state,
              onChanged: (value) {
                themeCubit.setThemeValue(value);
              },
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Versión V 1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.power_settings_new_rounded,
              color: redColor,
            ),
            title: const Text('Cerrar sesión'),
            onTap: () {
              _warningDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _warningDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildcontext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0))),
          contentPadding: const EdgeInsets.only(top: 7.0),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.logout_rounded,
                    size: 50,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(str_out_app, style: TextStyle(fontSize: 20)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        child: const Text('Aceptar'),
                        onPressed: () {
                          _prefs.requireAuthentication = true;
                          _prefs.latitud = '0.0';
                          _prefs.longitud = '0.0';
                          _prefs.isDarkThemeEnabled = false;
                          _prefs.accountValidate = false;
                          Navigator.of(buildcontext).pop();
                          Navigator.of(context).pushReplacementNamed("login");
                          _authBloc!.add(LoggedOut());
                        },
                      ),
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(buildcontext).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
