import 'package:bicis_ambato/blocs/auth/changePass/bloc.dart';
import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/resetPass/bloc.dart';
import '../style/style.dart';
import '../utils/constants_msg.dart';
import '../widget/auth/change_password_form.dart';
import 'package:flutter/services.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<ChangePasswordScreen> {
  ChangePswdBloc? changePswdBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changePswdBloc = ChangePswdBloc();
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
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, 'profile');
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: BlocProvider(
              create: (context) => changePswdBloc!,
              child: SafeArea(
                  top: true,
                  child: Stack(
                    children: [
                      Header(
                          nameScreen: str_change_passwd,
                          route: str_rout_profile),
                      Align(
                    alignment: const AlignmentDirectional(0.00, -0.79),
                        child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                          height:MediaQuery.of(context).size.width * 0.30,
                          decoration: BoxDecoration(
                            color: transp,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              img_change_pswd,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: const AlignmentDirectional(0, 1.0),
                          child: Container(
                              margin:
                                  const EdgeInsetsDirectional.only(bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.63,
                              padding:
                                  const EdgeInsets.only(bottom: 30, top: 10),
                              decoration: const BoxDecoration(
                                color: beige,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                shape: BoxShape.rectangle,
                              ),
                              child: ListView(
                                  children: const [ChangePasswordForm()]))),
                      Align(
                        alignment: const AlignmentDirectional(0.00, 1),
                        child: Container(
                            // color: beige,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: beige,
                            ),
                            child: const BarMunicipio()),
                      ),
                    ],
                  )),
            )));
  }
}
