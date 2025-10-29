import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bicis_ambato/data/auth_provider.dart';
import 'package:bicis_ambato/data/models/user.dart';
import 'package:bicis_ambato/style/style.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:bicis_ambato/widget/camara_permission_screen.dart';
import 'package:bicis_ambato/widget/profile/image_profile.dart';
import 'package:bicis_ambato/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/constants_msg.dart';

class EditProfileForm extends StatefulWidget {
  Uint8List? bytesImage;
  EditProfileForm({Key? key, this.bytesImage}) : super(key: key);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  File? _image;
  late AuthProvider authProvider;

  Prefs _prefs = Prefs();
  final TextEditingController _cedulaController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider();

    widget.bytesImage = base64Decode(_prefs.requireUserPhoto);

    _cedulaController.addListener(_onCedulaChanged);
    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
    _direccionController.addListener(_onDireccionChanged);
    _telefonoController.addListener(_onPhoneChanged);

    _cedulaController.text = _prefs.cedula;
    _nameController.text = _prefs.userName;
    _emailController.text = _prefs.email;
    _direccionController.text = _prefs.direccion;
    _telefonoController.text = _prefs.telefono;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Align(
            alignment: const AlignmentDirectional(0, -0.50),
            child: Container(
              width: 135,
              height: 135,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              //widget para images
              child: Stack(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.00, 0.24),
                    child: ImageProfile(
                      bytesImage: widget.bytesImage,
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.width * 0.30,
                      expadend: true,
                    ),
                  ),
                  Align(
                      alignment: const AlignmentDirectional(0.85, 0.70),
                      child: GestureDetector(
                        onTap: () => _getImage(ImageSource.gallery),
                        child: Container(
                          width: 28,
                          height: 28,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            img_plus,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          // ElevatedButton(onPressed: () => {}, child: Text(prefs.userName)),
          _cedulaField(),
          //_mailField(),
          _nameField(),
          _direccionField(),
          _phoneField(),
          const SizedBox(
            height: 40,
          ),
          _prefs.verifiedUser == "none" ||
                  _prefs.verifiedUser == "rejected" ||
                  _prefs.verifiedUser == "unverified"
              ? FloatingActionButton.extended(
                  heroTag: 'uploadfab',
                  onPressed: () async {
                    // 1) pide permiso si hace falta
                    final ok = await _ensureCameraPermission();
                    if (!ok) return; // el usuario no dio permiso

                    // 2) permiso concedido → vamos a la pantalla de validación
                    Navigator.of(context).pushReplacementNamed("upload-file");
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Validar identificación'))
              : const SizedBox(
                  height: 5,
                ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              onPressed: () async {
                //_registerBloc.add(ButtonSubmitPressed(
                //  isFormValid: state.isFormValid));
                // if (isRegisterButtonEnabled(state)) {
                _onFormSubmitted();
                // }
              },
              //: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Color.fromARGB(103, 23, 57, 97),
                //backgroundColor: secondary,
                //foregroundColor: whiteColor,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 48.0), // Adjust the padding as needed
                child: Text(str_save),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameField() {
    return TextFieldWidget(
      controller: _nameController,
      icon: const Icon(
        Icons.person_rounded,
        //color: secondary, // Color del icono
      ),
      hintText: str_name_last,
      isValid: true,
      errorMessage: 'Nombre no permitido',
    );
  }

  Widget _cedulaField() {
    return TextFieldWidget(
      keyboardType: TextInputType.number,
      controller: _cedulaController,
      icon: const Icon(
        Icons.contact_emergency_rounded,
        //color: secondary, // Color del icono
      ),
      hintText: str_ci,
      isValid: true,
      errorMessage: str_ci_invalid,
    );
  }

  Widget _mailField() {
    return TextFieldWidget(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      icon: const Icon(
        Icons.mail_rounded,
        //color: secondary, // Color del icono
      ),
      hintText: str_mail,
      isValid: true,
      errorMessage: str_valid_mail_invalid,
    );
  }

  Widget _direccionField() {
    return TextFieldWidget(
      controller: _direccionController,
      icon: const Icon(
        Icons.other_houses_rounded,
        //color: secondary,
        // Color del icono
      ),
      hintText: str_address,
      isValid: true,
      errorMessage: str_valid_address,
    );
  }

  Widget _phoneField() {
    return TextFieldWidget(
      keyboardType: TextInputType.phone,
      controller: _telefonoController,
      icon: const Icon(
        Icons.phone_iphone_rounded,
        // color: secondary,
        // Color del icono
      ),
      hintText: str_phone,
      isValid: true,
      errorMessage: str_valid_phone_invalid,
    );
  }

  void _onCedulaChanged() {}

  void _onNameChanged() {}
  void _onEmailChanged() {}

  void _onDireccionChanged() {}
  void _onPhoneChanged() {}
  Future _onFormSubmitted() async {
    User user =
        User(_emailController.text.trim(), _nameController.text.trim(), '');
    user.cedula = _cedulaController.text.trim();
    user.direccion = _direccionController.text;
    user.phone = _telefonoController.text.trim();
    user.image_1920 = convertImageToString();

    var response = await authProvider.updateUser(user).then((value) {
      if (value) {
        _prefs.userName = user.name;
        _prefs.direccion = user.direccion!;
        _prefs.cedula = user.cedula!; //user.cedula!;
        _prefs.telefono = user.phone!;
        _prefs.requireUserPhoto = user.image_1920!;
        _prefs.requireAuthentication = false;

        _prefs.cityCompany = "Ambato";
        Navigator.pushReplacementNamed(context, "profile");
      }
    });
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

  String convertImageToString() {
    String imageStr = base64Encode(widget.bytesImage!);
    return imageStr;
  }

  /// Pide permiso de cámara con tu pantalla personalizada.
  /// Devuelve true si al final el permiso está concedido.
  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Permisos de cámara requeridos'),
          content: Text(
              'Para validar tu identificación necesitamos acceso a la cámara. '
              'Actívalo en la configuración de la app.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('Abrir ajustes'),
            ),
          ],
        ),
      );
      return false;
    }
    // Si no está concedido o fue denegado antes, lanza tu pantalla:
    final granted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (ctx) => CameraPermissionScreen(
          onCameraGranted: () => Navigator.of(ctx).pop(true),
          onCameraDenied: () => Navigator.of(ctx).pop(false),
          //canSkip: false,
        ),
      ),
    );
    return granted ?? false;
  }
}
