// ignore_for_file: library_private_types_in_public_api, invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:bicis_ambato/style/style.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../../../blocs/auth/login/bloc.dart';
import '../../../utils/constants_msg.dart';

//Creación del botton personalizado de login
class LoginButton extends StatefulWidget {
  final String _email;
  final String _pswd;

  const LoginButton(
      {Key? key,
      required VoidCallback onPressed,
      required String email,
      required String pswd})
      : _email = email,
        _pswd = pswd,
        super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

late LoginBloc _loginBloc;
bool isNoTouchable = true;

class _LoginButtonState extends State<LoginButton> {
  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.add(ChangePassEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.70,
        height: MediaQuery.of(context).size.height * 0.06,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
           color: secondary,
          onPressed: () async {
            try {
              // await FlutterWindowManager.addFlags(
              //     FlutterWindowManager.FLAG_NOT_TOUCHABLE),
              _loginBloc.add(LoginWithCredentialsPressed(
                  email: widget._email, password: widget._pswd));
              log("LOADING STATE");
              //widget._onPressed;
            } catch (e) {
              print(e);
            }
          },
          child: Center(
            child: Text(
              str_start_session,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: poppinsNormal(
                  // ScreenUtil().setSp(
                  //   6,
                  // ),
                  16,
                  whiteColor),
            ),
          ),
        ));
  }
}
