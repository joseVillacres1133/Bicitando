import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/register/register_bloc.dart';
import '../../data/repository.dart';
import '../../style/style.dart';
import '../utils/constants_msg.dart';
import '../widget/auth/register/register_form.dart';
import 'package:flutter/services.dart';

//Construccion de la Page para Register
//Aqui se aplica los eventos y estados del Registerbloc
class RegisterScreen extends StatefulWidget {
  final Repository _repository;

  const RegisterScreen({super.key, required Repository repository})
      : _repository = repository;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = RegisterBloc(repository: widget._repository);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // SIEMPRE íconos claros
        statusBarBrightness: Brightness.dark, // Para iOS
      ),
    );
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,

      body: BlocProvider<RegisterBloc>(
          create: (context) => _registerBloc,
          child: Stack(children: [
            Header(nameScreen: str_create_account, route: str_rout_login),
            Align(
              alignment: const AlignmentDirectional(0.0, -0.75),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.width * 0.30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    img_register,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
                alignment: const AlignmentDirectional(0, 1.0),
                child: Container(
                    margin: const EdgeInsetsDirectional.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.65,
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    decoration: const BoxDecoration(
                      color: beige,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      shape: BoxShape.rectangle,
                    ),
                    child: ListView(children: [
                      Center(
                        child: Text(
                          "Ingresa tus datos",
                          style: textStyleTitleGeneral,
                        ),
                      ),
                      const RegisterForm(),
                    ]))),
            Align(
              alignment: const AlignmentDirectional(0.00, 1),
              child: Container(
                  //color: beige,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: transparentColor,
                  ),
                  child: const BarMunicipio()),
            ),
          ])),

      //),
    ));
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }
}
