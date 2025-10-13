import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../widget/terms.dart';

class TermsConditionsScreen extends StatefulWidget {

  const TermsConditionsScreen(
      {super.key,
      @required Repository? repository,
      @required BuildContext? context})
      : assert(repository != null);

  @override
  // ignore: library_private_types_in_public_api
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: SafeArea(child: 
        Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Header(nameScreen: str_terms_conditions, route: str_rout_home),
          Terms(),
         const BarMunicipio()
        ],
      ),
    )
        )
    );
  }
}
