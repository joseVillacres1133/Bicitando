import 'package:bicis_ambato/blocs/app/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../style/style.dart';
import '../utils/constants_msg.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String nameScreen;
  String route;
  Header({super.key, required this.nameScreen, required this.route});
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    return Material(
        elevation: 1.5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.fromLTRB(0.5, 0, 0.5, 0.5),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration:  BoxDecoration(
            //color: blackTrasnparent,
            image: DecorationImage(
              image: themeCubit.state ? 
              const AssetImage(img_darkHeader)
              :const AssetImage(img_top),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(11),
              bottomRight: Radius.circular(11),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 12,
                height: 5,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.of(context).pushReplacementNamed(route);
              //   },
              //   child: 
                IconButton(
                  onPressed: () {
                  Navigator.of(context).pushReplacementNamed(route);
                }, 
                  icon: Icon(
                  size: 28,
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                )
                //)
                
                // const Icon(
                //   size: 28,
                //   Icons.arrow_back_ios_new_rounded,
                //   color: whiteColor,
                // ),
              ),
              const SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                nameScreen,
                style: textStyleHeader,
              ),
            ],
          ),
        ));
  }
}
