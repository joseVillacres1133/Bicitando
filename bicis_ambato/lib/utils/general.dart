// import 'package:flutter/material.dart';
// //import 'package:flutter_map/flutter_map.dart';
// //import 'package:haversine_distance/haversine_distance.dart';
// //import 'package:latlong2/latlong.dart';
// import 'dart:math';
// import '../data/models/general/GeneralModels.dart';
// import '../data/models/odoo/StopsAVehicle.dart';
// import '../style/style.dart';
// import 'constants_msg.dart';

import 'constants_msg.dart';


// /// parse a date
// DateTime dateFromUtcOffset(String dateStr, String timeZoneOffset) {
//   DateTime d = DateTime.parse(dateStr);
//   if (timeZoneOffset.startsWith("+")) {
//     final of = int.parse(timeZoneOffset.replaceFirst("+", ""));
//     d = d.add(Duration(hours: of));
//   } else if (timeZoneOffset.startsWith("-")) {
//     final of = int.parse(timeZoneOffset.replaceFirst("-", ""));
//     d = d.subtract(Duration(hours: of));
//   }
//   return d;
// }

// StopsMarket? searchStopNearby(List<StopsMarket> paradas, double prefslat,
//     double prefslng){//, double distanceMeters) {
//   if (prefslat == 0.0 || prefslng == 0.0 ){//|| distanceMeters == 0.0) {
//     return null;
//   }

//   List<StopsMarket> stopsVerificate = [];
//   HaversineDistance haversineDistance = HaversineDistance();
//   for (var i = 0; i < paradas.length; i++) {
//     Location location1 = Location(prefslat, prefslng);
//     Location location2 =
//         Location(double.parse(paradas[i].lat!), double.parse(paradas[i].long!));
//     var gcd = haversineDistance.haversine(location1, location2, Unit.METER);

//     if (gcd / 1000.0 <= 5) {
//     //if (gcd <= distanceMeters) {
//       double valor = gcd;
//       paradas[i].distance = valor;
//       stopsVerificate.add(paradas[i]);
//     }
//   }

//   if (stopsVerificate.isNotEmpty) {
//     stopsVerificate.sort((a, b) => a.distance!.compareTo(b.distance as num));
//     return stopsVerificate[0];
//   }
//   return null;
// }


bool toBoolean(String str, [bool strict = false]) {
  if (strict == true) {
    return str == '1' || str == str_true;
  }
  return str != '0' && str != 'false' && str != '';
}

// LatLng centerPoints(
//     List<Marker> latLngList, double latTraccar, double lngTraccar) {
//   if (latLngList.isEmpty) {
//     return LatLng(latTraccar, lngTraccar);
//   }

//   if (latLngList.length == 1) {
//     return LatLng(latLngList[0].point.latitude, latLngList[0].point.longitude);
//   } else {
//     double x = 0;
//     double y = 0;
//     double z = 0;

//     for (int i = 0; i < latLngList.length; i++) {
//       var latitude = latLngList[i].point.latitude * pi / 180;
//       var longitude = latLngList[i].point.longitude * pi / 180;
//       x += cos(latitude) * cos(longitude);
//       y += cos(latitude) * sin(longitude);
//       z += sin(latitude);
//     }

//     var limitLatLng = latLngList.length;

//     x = x / limitLatLng;
//     y = y / limitLatLng;
//     z = z / limitLatLng;

//     var centerLng = atan2(y, x);
//     var centerResult = sqrt(x * x + y * y);
//     var centerLat = atan2(z, centerResult);

//     return LatLng(centerLat * 180 / pi, centerLng * 180 / pi);
//   }
// }

// Widget circleAvatarNormal(String iconImage) {
//   return CircleAvatar(
//     radius: 10,
//     backgroundColor: Colors.transparent,
//     child: Transform.rotate(
//       angle: 0,
//       child: Image(
//         image: AssetImage(iconImage),
//         fit: BoxFit.fitHeight,
//       ),
//     ),
//   );
// }

// Widget circleAvatarSizes(
//   String iconImage,
//   int stopsResCant,
//   GeneralSizeCicleAvatar generalSizeCicleAvatar,
// ) {
//   return Wrap(
//     alignment: WrapAlignment.center,
//     runAlignment: WrapAlignment.center,
//     crossAxisAlignment: WrapCrossAlignment.center,
//     spacing: 0.0,
//     runSpacing: 0.0,
//     direction: Axis.horizontal, //
//     children: <Widget>[
//       CircleAvatar(
//         radius: generalSizeCicleAvatar.radius,
//         backgroundColor: secondary,
//         child: Text(
//           stopsResCant.toString(),
//           textAlign: TextAlign.center,
//           style: poppinsBold(generalSizeCicleAvatar.textSize, whiteColor),
//         ),
//       ),
//       Image.asset(
//         iconImage,
//         height: generalSizeCicleAvatar.heightImage,
//         width: generalSizeCicleAvatar.widthImage,
//         fit: BoxFit.cover,
//       ),
//     ],
//   );

//   /*Image( 
//                     width: generalSizeCicleAvatar.widthImage,
//                     height:  generalSizeCicleAvatar.heightImage, 
//                     image:  AssetImage(iconImage),
//                   );*/

//   /*Column(  
//                 children: [
                  
//                   Image( 
//                     width: generalSizeCicleAvatar.widthImage,
//                     height:  generalSizeCicleAvatar.heightImage, 
//                     image:  AssetImage(iconImage),
//                   ),

//                   /*CircleAvatar(
//                     radius: generalSizeCicleAvatar.radius,
//                     backgroundColor: secondary,
//                     child:  Text(stopsResCant.toString(), 
//                               textAlign: TextAlign.center,
//                               style: poppinsBold(
//                                   generalSizeCicleAvatar.textSize,
//                                   whiteColor),),),*/

//                 ],
//               );*/
// }


// Marker markerInfo(
//     LatLng pointPass,
//     String iconImage,
//     bool press,
//     GeneralSizeCicleAvatar generalSizeCicleAvatar,
//     String textShow,
//     Function setState) {
//   return Marker(
//     width: press
//         ? generalSizeCicleAvatar.widthImage * 2
//         : generalSizeCicleAvatar.widthImage * 1.5,
//     height: press
//         ? generalSizeCicleAvatar.heightImage * 2
//         : generalSizeCicleAvatar.heightImage * 1.5,
//     point: pointPass,
//     child: Wrap(
//         alignment: WrapAlignment.center,
//         runAlignment: WrapAlignment.center,
//         crossAxisAlignment: WrapCrossAlignment.center,
//         spacing: 0.0,
//         runSpacing: 0.0,
//         direction: Axis.horizontal, //
//         children: <Widget>[
//           Image.asset(
//             iconImage,
//             height: press
//                 ? generalSizeCicleAvatar.heightImage * 0.75
//                 : generalSizeCicleAvatar.heightImage * 1.05,
//             width: press
//                 ? generalSizeCicleAvatar.widthImage * 0.75
//                 : generalSizeCicleAvatar.widthImage * 1.05,
//             fit: BoxFit.cover,
//           ),
//           (press)
//               ? Container(
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(15)),
//                     color: secondary,
//                   ),
//                   height: generalSizeCicleAvatar.heightImage * 0.55,
//                   width: generalSizeCicleAvatar.widthImage * 1.9,
//                   child: Center(
//                     child: Text(
//                       textShow.toString(),
//                       textAlign: TextAlign.center,
//                       style: poppinsBold(
//                           generalSizeCicleAvatar.textSize, whiteColor),
//                     ),
//                   ),
//                 )
//               : const SizedBox(),
//         ],
//       ),
//     /*builder: (ctx) => GestureDetector(
//       onTap: () {
//         setState(() {
//           press = !press;
//         });
//       },
      
//     ),*/
//   );
// }



// Marker markerInfoInicio(LatLng pointPass, IconData iconData,
//     GeneralSizeCicleAvatar generalSizeCicleAvatar) {
//   return Marker(
//     width: generalSizeCicleAvatar.widthImage,
//     height: generalSizeCicleAvatar.heightImage,
//     point: pointPass,
//     child: const Icon(Icons.refresh),
//     /*null,
//     builder: (ctx) =>  CircleAvatar(
//                       radius: generalSizeCicleAvatar.radius,
//                       backgroundColor: secondary,
//                       child: Icon(
//                             iconData,
//                             color: whiteColor,
//                           ),
//                     ), */
//   );
// }
