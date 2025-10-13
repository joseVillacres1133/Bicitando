import 'package:bicis_ambato/style/style.dart';
import 'package:flutter/material.dart';

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
      );
}
