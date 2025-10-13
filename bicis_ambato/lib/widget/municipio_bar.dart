import 'package:bicis_ambato/blocs/app/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/constants_msg.dart';

class BarMunicipio extends StatelessWidget {
  const BarMunicipio({super.key});


  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    return Image.asset(
                  themeCubit.state ?
                  img_darkBar
                  :img_color_bar,
                  fit: BoxFit.fitWidth,
                );
  }
  
}

