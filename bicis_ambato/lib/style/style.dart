import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

TextStyle textStyle = const TextStyle(
  color: Colors.black, //const Color(0XFF000000),
  //fontSize: 14.0,
  //fontWeight: FontWeight.normal,
  //fontFamily: "OpenSans",
);

String fuenteUtilizada = "Poppins";

TextStyle poppinsNormal(double tam, Color col) {
  return TextStyle(fontSize: tam, color: col);
}

TextStyle poppinsBold(double? tam, Color col) {
  return TextStyle(
      fontSize: tam,
      fontWeight: FontWeight.w700, //bold
      color: col);
}


TextStyle textStyleSmall = const TextStyle(
    //color: whiteColor,
    fontSize: 9.0);
TextStyle textStyleGeneral = const TextStyle(
    //color: whiteColor,
    fontSize: 12.0);
TextStyle textStyleTitleGeneral = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
TextStyle textStyleTitleAlerts = const TextStyle(
  color: whiteColor,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
TextStyle textStyleHeader = const TextStyle(color: whiteColor, fontSize: 22);

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
      /* title: base.title.copyWith(
      fontFamily: 'GoogleSans',
    ),*/
      );
}

TextStyle textGreen = const TextStyle(
  color: Color(0xFF00c497),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  fontFamily: "OpenSans",
);

final ThemeData base = ThemeData.light();

ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  //buttonColor: primaryColor,
  indicatorColor: Colors.white,
  splashColor: Colors.white24,
  splashFactory: InkRipple.splashFactory,
  //hintColor: const Color(0xFF13B9FD),
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  //backgroundColor: Colors.white,
  //errorColor: const Color(0xFFB00020),
  iconTheme: const IconThemeData(color: primaryColor),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: _buildTextTheme(base.textTheme),
  primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
  //accentTextTheme: _buildTextTheme(base.accentTextTheme),
);

///todo
Color textFieldColor = const Color.fromRGBO(168, 160, 149, 0.6);
const Color whiteColor = Colors.white; //const Color(0XFFFFFFFF);
const Color blackColor = Color(0XFF242A37);
const Color disabledColor = Color(0XFFF7F8F9);
//const Color greyColor = Color(0xFFD0D2D3); //line separasor
const Color appColorgreen = Color.fromARGB(255, 24, 93, 173); //color de botones login
const Color activeColor = Color(0xFFF44336);
const Color redColor = Color.fromARGB(255, 247, 9, 21); //Colors.redAccent; ////color boton home
const Color redColorA = Color.fromARGB(120, 247, 9, 21); //Colors.redAccent; ////color boton home
//const Color buttonOrange = Color(0xFFfe8800);
const Color secondary = Color.fromARGB(255, 0, 170, 232); //Color.fromARGB(255, 23, 57, 97);
const Color primaryColor = Color.fromARGB(255, 23, 57, 97); //Color.fromARGB(255, 0, 170, 232);
const Color yellow = Color.fromARGB(255, 245, 224, 15);
const Color purple = Color.fromARGB(255, 102, 40, 115);
const Color purpleDesable = Color.fromARGB(255, 90, 62, 95);
const Color purplelight = Color.fromARGB(255, 140, 47, 136);
const Color beige = Color.fromARGB(255, 245, 241, 244);
const Color greyColor = Color.fromARGB(255, 224, 224, 224);


const Color secondary1 = Color(0xFF8689ac); //#5b33f3 color botones
Color transp = const Color.fromARGB(0, 0, 0, 0); //#5b33f3 color botones
Color grisARGB200 = const Color.fromARGB(240, 240, 240, 240); //#5b33f3 color botones


const Color greenColor = Color.fromARGB(255, 0, 226, 94);
const Color greenColor1 = Color.fromARGB(255, 217, 240, 226);
const Color greenColorA = Color.fromARGB(120, 0, 226, 94);
//const Color greyColor = Colors.grey;

const Color transparentColor = Color.fromRGBO(0, 0, 0, 0);
const Color activeButtonColor = Color.fromRGBO(43, 194, 137, 50.0);
const Color dangerButtonColor = Color(0XFFf53a4d);
const Color blackTrasnparent = Color.fromRGBO(0, 0, 0, 0.356);

const Color blue1 = Color.fromRGBO(22, 53, 77, 1);
//const Color blue1 = Color.fromRGBO(1, 110, 156, 1);

int getColorHexFromStr(String colorStr) {
  colorStr = "FF$colorStr";
  colorStr = colorStr.replaceAll("#", "");
  int val = 0;
  int len = colorStr.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = colorStr.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw const FormatException("An error occurred when converting a color");
    }
  }
  return val;
}
