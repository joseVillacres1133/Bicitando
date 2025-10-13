// import 'package:flutter/material.dart';
// //import 'package:meta/meta.dart';

// import '../../../utils/sharedprefs_helper.dart';
// //import '../../../utils/theme.dart';

// //Estados en el que se encuentra las configuraciones
// @immutable
// class SettingsState {
//   final bool isDarkThemeEnabled;
//   final ThemeData themeData;

//   const SettingsState({
//     required this.isDarkThemeEnabled,
//     required this.themeData,
//   });

//   factory SettingsState.loadPrefs() {
//     final prefs = Prefs();

//     //final List<int> pin = [];

//     return SettingsState(
//       isDarkThemeEnabled: prefs.isDarkThemeEnabled,
//       themeData: prefs.isDarkThemeEnabled ? kDarkTheme : kLightTheme,
//     );
//   }

//   SettingsState update({
//     required bool isDarkThemeEnabled,
//     required ThemeData themeData,
//   }) {
//     return copyWith(
//         isDarkThemeEnabled: isDarkThemeEnabled, themeData: themeData);
//   }

//   SettingsState copyWith({
//     bool? isDarkThemeEnabled,
//     ThemeData? themeData,
//   }) {
//     return SettingsState(
//       isDarkThemeEnabled: isDarkThemeEnabled ?? this.isDarkThemeEnabled,
//       themeData: themeData ?? this.themeData,
//     );
//   }

//   @override
//   String toString() {
//     String themeOption = isDarkThemeEnabled ? 'DarkTheme' : 'LightTheme';
//     //String BiometricOption = isFingerPrintEnabled ? 'Fingerprint' : 'Face Id';

//     return ''' SettingsState {
//       isDarkThemeEnabled: $isDarkThemeEnabled,
//       themeData: $themeOption,
//     }
//     ''';
//   }
// }
