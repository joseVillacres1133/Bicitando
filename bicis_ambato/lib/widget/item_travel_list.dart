import 'package:bicis_ambato/style/style.dart';
import 'package:flutter/material.dart';

import '../data/models/odoo/Travel.dart';
import '../utils/constants_msg.dart';

// ignore: must_be_immutable
class ItemTravel extends StatelessWidget {
  Travel travel;

  ItemTravel(this.travel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(

        //color: whiteColor,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            setColorState(travel.state!),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(5.0), // Bordes redondeados
                        color: setColor(travel.state!), // Color de fondo
                      ),
                    )
                  ],
                ),
                const Icon(
                  Icons.date_range,
                  // color: secondary,
                ),
                const Icon(
                  Icons.timer_outlined,
                  //color: secondary,
                ),
              ],
            ),
            Column(
              children: [
                Text(travel.date!),
                Text(travel.time!),
              ],
            ),
            const Column(
              children: [
                Icon(
                  Icons.directions_bike_rounded,
                  // color: secondary,
                ),
                Icon(
                  Icons.my_location_sharp,
                  //color: secondary,
                ),
                Icon(
                  Icons.location_on,
                  color: redColor,
                )
              ],
            ),
            Flexible(child: 
            Column(
              children: [
                Text(travel.vehicle.registrationVehicle!,
                overflow: TextOverflow.ellipsis,
                          maxLines: 1,),
                Text(travel.startStation.name!,
                overflow: TextOverflow.ellipsis,
                          maxLines: 1,),
                Text(travel.startStation.name!,
                overflow: TextOverflow.ellipsis,
                          maxLines: 1,),
              ],
            ),
            
            ),
           // setColorState(''),
          ],
        ));
  }

  String stateTranslate = '';
  Widget setColorState(String state) {
    Color color = blackColor;
    color = setColor(state);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        const Text('Reserva'),
        Image.asset(
          img_travel,
          height: 40,
          color: primaryColor,
        ),
        SizedBox(
            height: 25,
            width: 80,
            child: Container(
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5),
                      //topLeft: Radius.circular(12)
                      )),
              child: Center(child: Text(
                stateTranslate,
                style: const TextStyle(
                    color: whiteColor, fontWeight: FontWeight.bold),
              ),)
            ))
      ],
    );
  }

  Color setColor(String state) {
    Color color = blackColor;
    if (state == 'finished') {
      color = purplelight;
      stateTranslate = 'Finalizado';
    }
    if (state == 'active') {
      color = primaryColor;
      stateTranslate = 'Activa';
    }
    if (state == 'cancelled') {
      color = redColor;
      stateTranslate = 'Cancelada';
    }
    if (state == '') {
      color = transparentColor;
    }

    return color;
  }
}
