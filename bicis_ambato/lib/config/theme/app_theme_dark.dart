

import 'package:bicis_ambato/style/style.dart';
import 'package:flutter/material.dart';


const seedColor =primaryColor;
const ligthColor = secondary;

class AppThemeDark {

  final bool isDarkmode;

  AppThemeDark({ required this.isDarkmode });


  ThemeData getTheme() => ThemeData(
    textTheme: Typography.blackMountainView,
    useMaterial3: true,
    colorSchemeSeed: whiteColor, //!isDarkmode ? seedColor : ligthColor,  
    brightness: Brightness.dark,//isDarkmode ? Brightness.dark : Brightness.light,
      //fontFamily: "Roboto",
    listTileTheme: const ListTileThemeData(
      iconColor: ligthColor,
    ),
    //colorScheme: ColorScheme(brightness: brightness, primary: primary, onPrimary: onPrimary, secondary: secondary, onSecondary: onSecondary, error: error, onError: onError, background: background, onBackground: onBackground, surface: surface, onSurface: onSurface)
  );

}