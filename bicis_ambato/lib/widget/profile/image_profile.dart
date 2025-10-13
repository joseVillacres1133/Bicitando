import 'dart:convert';
import 'dart:typed_data';

import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants_msg.dart';

// ignore: must_be_immutable
class ImageProfile extends StatelessWidget {
  Uint8List? bytesImage;
  double width;
  double height;
  bool? expadend;

  final Prefs _prefs = Prefs();

  ImageProfile({
    super.key,
    this.bytesImage,
    this.expadend,
    required this.width,
    required this.height,
  });

  Future<void> imageConvert(String img) async {
    if (_prefs.requireUserPhoto != str_false) {
      String imgOcupar = _prefs.requireUserPhoto.toString();
      bytesImage = const Base64Decoder().convert(imgOcupar);
    } else {
      bytesImage = await cargarImagen(img_register);
    }
  }

  Future<Uint8List?> cargarImagen(String ruta) async {
    ByteData data = await rootBundle.load(ruta);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    if (bytesImage == null) {
      imageConvert(_prefs.requireUserPhoto);
    }

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(img_circle),
          fit: BoxFit.cover, // Ajusta la imagen al contenedor principal
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (expadend!) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => fullScreenImage(context)!,
              ),
            );
          }
        },
        child: Center(
          child: Container(
            width: 0.88 * width,
            height: 0.88 * height,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: bytesImage != null
                  ? DecorationImage(
                      image: MemoryImage(
                        bytesImage!,
                      ),
                      fit: BoxFit.cover, // Ajusta la imagen dentro del círculo
                    )
                  : const DecorationImage(
                      image: AssetImage(img_bikeMaker),
                      fit: BoxFit.cover, // Ajusta la imagen dentro del círculo
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? fullScreenImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(41, 0, 0, 0),
        body: Center(
          child: bytesImage != null
              ? Image.memory(
                  bytesImage!,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  img_register,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  
}
