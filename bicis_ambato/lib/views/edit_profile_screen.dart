import 'dart:io';
import 'dart:typed_data';

import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../data/auth_provider.dart';
import '../widget/profile/edit_profile_form.dart';

class EditProfileScreen extends StatefulWidget {
  final AuthProvider? _repository;
  final BuildContext? _context;
  Uint8List? bytesImage;

  EditProfileScreen(
      {super.key,
      @required AuthProvider? repository,
      @required BuildContext? context,
      this.bytesImage})
      : assert(repository != null),
        _repository = repository!,
        _context = context!;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, 'profile');
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body:
             SafeArea(
                top: true,
                child: 
                //Column(children: [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Header(nameScreen: 'Editar perfil', route: 'profile'),
                    EditProfileForm(),
                    const BarMunicipio()
                  ],
                )
                //],
                )
                
                 )
                 //)
                 );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        loadAsset(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  void loadAsset(File? imageReduce) async {
    List<int> imageBytes = imageReduce!.readAsBytesSync();
    Uint8List imageRaw = await imageReduce.readAsBytes();
    //String base64Image = base64Encode(imageBytes);
    setState(() {
      //_image = base64Image.toString();
      widget.bytesImage = imageRaw;
    });
  }
}
