import 'package:bicis_ambato/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const seedColor = primaryColor;
const ligthColor = purple; //Color.fromARGB(255, 1, 72, 226);

class AppTheme {
  final bool isDarkmode;

  AppTheme({required this.isDarkmode});

  ThemeData getThemeData(bool darkMode) {
    if (darkMode) {
      return getDarkTheme();
    } else {
      return getThemeLight();
    }
  }

  ThemeData getThemeLight() => ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorSchemeSeed: seedColor, //isDarkmode ? seedColor : ligthColor,
        brightness: Brightness
            .light, //,//isDarkmode // ? Brightness.dark : Brightness.light,
        listTileTheme: const ListTileThemeData(
          iconColor: seedColor,
        ),
        iconTheme: const IconThemeData(color: primaryColor),

        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Status bar transparente
            statusBarIconBrightness: Brightness.dark, // Iconos oscuros
            statusBarBrightness: Brightness.light, // Para iOS
          ),
        ),
        //colorScheme: lightScheme(),

        //canvasColor: purple,
      );

  ThemeData getDarkTheme() => ThemeData(
        brightness: Brightness.dark,
        buttonTheme: const ButtonThemeData(
          buttonColor:
              Colors.blue, // Color de fondo de los botones en tema claro
          textTheme: ButtonTextTheme
              .primary, // Estilo de texto para los botones en tema claro
        ),

        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light, // Iconos claros en dark mode
            statusBarBrightness: Brightness.dark, // Para iOS
          ),
        ),

      );
}
