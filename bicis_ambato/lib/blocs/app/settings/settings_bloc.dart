// // ignore_for_file: override_on_non_overriding_member

// import 'dart:async';
// import 'package:bloc/bloc.dart';

// import '../../../utils/sharedprefs_helper.dart';
// import '../bloc.dart';

// //Cada widget tiene incorporado su bloc, en este caso va hacer el bloc de settings
// mixin SettingsBloc implements Bloc<SettingsEvent, SettingsState> {
//   final _prefs = Prefs();

//   @override
//   SettingsState get initialState => SettingsState.loadPrefs();

//   @override
//   Stream<SettingsState> mapEventToState(
//     SettingsEvent event,
//   ) async* {
//     //Poner la app en tema oscuro
//     if (event is DarkTheme) {
//       //Eventos que posee el widget (Metodo/Modulo que posee)
//       yield* _mapDarkThemeToState();
//     } else if (event is LightTheme) {
//       //Poner la ap en tema claro
//       yield* _mapLightThemeToState();
//     }
//   }

//   //Para Activar estas opciones se utiliza SharedPreferences del Celular que configuramos .
//   //Activar Tema Oscuro para la App
//   Stream<SettingsState> _mapDarkThemeToState() async* {
//     _prefs.isDarkThemeEnabled = true;

//     //El estado en el que esta la aplicacion (accion que va a realizar)
//     //yield state.update(isDarkThemeEnabled: true, themeData: kDarkTheme);
//   }

//   //Activar Tema Claro para la App
//   Stream<SettingsState> _mapLightThemeToState() async* {
//     _prefs.isDarkThemeEnabled = false;

//    // yield state.update(isDarkThemeEnabled: false, themeData: kLightTheme);
//   }
// }
