import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/repository.dart';
import '../style/style.dart';
import '../widget/frequent_questios.dart';

import 'dart:io' show Platform;

class HelpScreen extends StatefulWidget {
  const HelpScreen(
      {super.key,
      @required Repository? repository,
      @required BuildContext? context})
      : assert(repository != null);

  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: SafeArea(
            child: Scaffold(
      body: Stack(
        children: <Widget>[
          Header(nameScreen: 'Ayuda', route: str_rout_home),
          Align(
            alignment: const AlignmentDirectional(0.0, -0.70),
            child: Container(
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10, vertical: 1),
              width: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: secondary, borderRadius: BorderRadius.circular(15)),
              child: const Text(
                str_frequent_questions,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.29,
              left: 0,
              right: 0.0,
              bottom: MediaQuery.of(context).size.height * 0.40,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.40,
                //width: MediaQuery.of(context).size.height * 0.40,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                //padding: EdgeInsets.symmetric(vertical: 5),
                child: FrequentQuestionsContent(),
              )),
          Align(
            alignment: const AlignmentDirectional(0.0, 0.3),
            child: Container(
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10, vertical: 1),
              width: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: secondary, borderRadius: BorderRadius.circular(15)),
              child: const Text(
                'Contactos',
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.0, 0.5),
            child: ListTile(
              title: const Text('Soporte Técnico'),
              trailing: const Icon(Icons.share),
              onTap: () => shareToWhatsApp(
                '*Equipo de atención al cliente*,\n Detecté un problema al devolver una bicicleta el ${dateTime.year}-${dateTime.month}-${dateTime.day}, y quisiera reportarlo. \n',
                '+593994154739',
              ),
            ),
          ),
          const Align(
              alignment: AlignmentDirectional(0, 1), child: BarMunicipio())
        ],
      ),
    )));
  }
}

// Función para compartir en WhatsApp (reemplaza shareWhatsapp.share)
void shareToWhatsApp(String text, String phone) async {
  final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
  final encodedText = Uri.encodeQueryComponent(text);
  String whatsappUrl;

  if (Platform.isAndroid) {
    whatsappUrl = "whatsapp://send?phone=$cleanPhone&text=$encodedText";
  } else if (Platform.isIOS) {
    whatsappUrl = "whatsapp://send?phone=$cleanPhone&text=$encodedText";
  } else {
    whatsappUrl = "https://wa.me/$cleanPhone?text=$encodedText";
  }

  try {
    final uri = Uri.parse(whatsappUrl);

    final canLaunch = await canLaunchUrl(uri);

    if (canLaunch) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      final fallbackUrl =
          Uri.parse("https://wa.me/$cleanPhone?text=$encodedText");

      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(
          fallbackUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await Share.share(text);
      }
    }
  } catch (e) {
    print('Error al intentar abrir WhatsApp: $e');
    await Share.share(text);
  }
}



              // Container(
              //   margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
              //   width: MediaQuery.of(context).size.height * 0.9,
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //       color: primaryColor,
              //       borderRadius: BorderRadius.circular(15)),
              //   child: const Text(
              //     str_need_help,
              //     textAlign: TextAlign.justify,
              //   ),
              // ),