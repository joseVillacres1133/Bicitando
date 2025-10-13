import 'dart:async';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:imei_plugin/imei_plugin.dart';

import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../blocs/auth/bloc.dart';
import '../../blocs/auth/resetPass/bloc.dart';

import '../../data/repository.dart';
import '../../style/style.dart';
import '../../utils/constants.dart';
import '../../utils/constants_msg.dart' as AST;
import '../../utils/sharedprefs_helper.dart';

//Construccion del formulario de Register
//Aqui se aplica los eventos y estados del RegisterBloc
class ResetPasswordForm extends StatefulWidget {
  final String? email;
  final String? oldPass;

  const ResetPasswordForm({super.key, this.email, this.oldPass});
  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Prefs _prefs = Prefs();
  ResetBloc? _resetBloc;
  PermissionStatus _permiso = PermissionStatus.denied;

  bool? passwordVisible;
  bool? oldpasswordVisible;
  bool? passwordVisible_confir;
  final Repository _repository = Repository(
      odooClient:
          OdooClient(URL_SERVIDO_JOSE)); //"https://its.mivilsoft.com"));
  AuthBloc? _authBloc;

  var idToken;

  //FirebaseMessaging? _firebaseMessaging;

  ///= FirebaseMessaging();
  String? tokenFirebase;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(ResetState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting!;
  }

  @override
  void initState() {
    passwordVisible = true;
    passwordVisible_confir = true;
    oldpasswordVisible = true;

    if (widget.email != "") {
      _emailController = TextEditingController(text: widget.email);
    }
    if (_prefs.secret != null) {
      _oldpasswordController = TextEditingController(text: _prefs.secret);
    }
    _resetBloc = ResetBloc();
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  Future<bool> _requestPop() {
    setState(() {
      _prefs.requireAuthentication = true;
    });
    Navigator.pushReplacementNamed(
        context, "login"); // bloquear el boton de regreso
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        body: BlocListener(
          bloc: _resetBloc,
          listener: (BuildContext context, ResetState state) async {
            if (state.isSubmitting!) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AST.str_process),
                      CircularProgressIndicator(),
                    ],
                  ),
                ));
            }

            if (state.isSuccess!) {
              if (_prefs.requireAuthentication) {
                setState(() {
                  _prefs.resetPass = false;
                  _prefs.secret = "";
                });
                Navigator.pushReplacementNamed(context, 'login');
              } else {
                setState(() {
                  _prefs.resetPass = false;
                  _prefs.secret = _passwordController.text.toString();
                });
                setState(() {
                  //_authBloc.dispatch(LoggedOut());
                  _prefs.requireAuthentication = true;
                });

                Navigator.pushReplacementNamed(context, 'login');
              }
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 5), () {
                      Navigator.pop(context, this);
                    });
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: secondary,
                      content: ListTile(
                        title: Text(
                          'Clave Cambiada Exitosamente',
                          style: poppinsBold(
                              ScreenUtil().setSp(
                                5,
                              ),
                              whiteColor),
                        ),
                      ),
                    );
                  });
            }

            if (state.isFailure!) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.error!),
                        const Icon(Icons.error),
                      ],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          child: BlocBuilder(
              bloc: _resetBloc,
              builder: (BuildContext context, ResetState state) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: secondary,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1 / 3.5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            secondary,
                            secondary,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .1 / 3.5),
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: ExactAssetImage(AST.img_logo)),
                      ),
                    ),
                    Center(
                      child: SingleChildScrollView(
                          child: Container(
                        child: formUI(state),
                      )),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget formUI(ResetState state) {
    return Column(children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.9 / 3.5,
      ),
      Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * .03,
          right: MediaQuery.of(context).size.height * .03,
          top: MediaQuery.of(context).size.height * .1 / 3.5,
        ),
        child: Column(children: <Widget>[
          _emailField(state),
          _oldpasswordField(state),
          _passwordField(state),
          _confirmPasswordField(state),
        ]),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1 / 3.5,
      ),
      SizedBox(
          width: ScreenUtil().setWidth(85),
          child: MaterialButton(
            color: redColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed:
                isRegisterButtonEnabled(state) ? _onFormSubmitted : () {},
            child: Text(
              AST.str_change_pwd,
              style: poppinsBold(
                  ScreenUtil().setSp(
                    5,
                  ),
                  whiteColor),
            ),
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.50 / 3.5,
      ),
    ]);
  }

  void showWarningMessage(
      BuildContext context, String titulo, String subtitulo) {
    final dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: ListTile(
        title: Text(titulo),
        subtitle: Text(
          subtitulo,
          textAlign: TextAlign.justify,
        ),
      ),
    );
    showDialog(
        context: context, barrierDismissible: false, builder: (x) => dialog);
  }

  Widget _emailField(ResetState state) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Image.asset(
          AST.img_correo,
          color: Colors.black,
          scale: 27,
        ),
        labelText: AST.str_mail,
        labelStyle: poppinsBold(
            ScreenUtil().setSp(
              5,
            ),
            whiteColor),
      ),
      style: poppinsBold(
          ScreenUtil().setSp(
            5,
          ),
          whiteColor),
      autocorrect: false,
      autovalidateMode: AutovalidateMode.always,
      validator: (_) {
        return !state.isEmailValid
            ? '\t\t\t\t\t\t         \t Correo Electrónico Inválido\n'
            : null;
      },
    );
  }

  Widget _oldpasswordField(ResetState state) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: _oldpasswordController,
      //initialValue: widget.oldPass,
      //readOnly: true,
      obscureText: oldpasswordVisible!,
      decoration: InputDecoration(
        prefixIcon: Image.asset(
          AST.img_contrasenia,
          scale: 27,
        ),
        labelText: AST.str_old_pwd,
        labelStyle: poppinsBold(
            ScreenUtil().setSp(
              5,
            ),
            whiteColor),
        suffixIcon: IconButton(
          icon: Icon(
            oldpasswordVisible! ? Icons.visibility : Icons.visibility_off,
            color: whiteColor,
          ),
          onPressed: () {
            setState(() {
              oldpasswordVisible = !oldpasswordVisible!;
            });
          },
        ),
      ),
      style: poppinsBold(
          ScreenUtil().setSp(
            5,
          ),
          whiteColor),
    );
  }

  Widget _passwordField(ResetState state) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      decoration: InputDecoration(
        prefixIcon: Image.asset(
          AST.img_contrasenia,
          scale: 27,
        ),
        labelText: AST.str_new_pwd,
        labelStyle: poppinsBold(
            ScreenUtil().setSp(
              5,
            ),
            whiteColor),
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible! ? Icons.visibility : Icons.visibility_off,
            color: whiteColor,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible!;
            });
          },
        ),
      ),
      style: poppinsBold(
          ScreenUtil().setSp(
            5,
          ),
          whiteColor),
      obscureText: passwordVisible!,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.always,
      validator: (_) {
        return !state.isPasswordValid ? AST.str_valid_characters : null;
      },
    );
  }

  Widget _confirmPasswordField(ResetState state) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        prefixIcon: Image.asset(
          AST.img_contrasenia,
          scale: 27,
        ),
        labelText: AST.str_confirm_pwd,
        labelStyle: poppinsBold(
            ScreenUtil().setSp(
              5,
            ),
            whiteColor),
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible_confir! ? Icons.visibility : Icons.visibility_off,
            color: whiteColor,
          ),
          onPressed: () {
            setState(() {
              passwordVisible_confir = !passwordVisible_confir!;
            });
          },
        ),
      ),
      style: poppinsBold(
          ScreenUtil().setSp(
            5,
          ),
          whiteColor),
      obscureText: passwordVisible_confir!,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.always,
      validator: (_) {
        return !state.isConfirmPasswordValid ? AST.str_valid_pwd : null;
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _resetBloc!.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    if (_confirmPasswordController.text.isNotEmpty) {
      _resetBloc!.add(
        ConfirmPasswordChanged(
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text),
      );
    } else {
      _resetBloc!.add(
        PasswordChanged(password: _passwordController.text),
      );
    }
  }

  void _onConfirmPasswordChanged() {
    _resetBloc!.add(
      ConfirmPasswordChanged(
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text),
    );
  }

  Future _onFormSubmitted() async {
    _resetBloc!.add(Submitted(
        _emailController.text.toString(),
        _passwordController.text.toString(),
        _confirmPasswordController.text.toString(),
        _oldpasswordController.text.toString()));
  }
}
