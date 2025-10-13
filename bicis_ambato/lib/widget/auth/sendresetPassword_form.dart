import 'dart:async';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

//import 'package:permission_handler/permission_handler.dart';

import '../../blocs/auth/resetPass/bloc.dart';
import '../../data/repository.dart';
import '../../style/style.dart';
import '../../utils/constants.dart';
import '../../utils/constants_msg.dart' as AST;
import '../../utils/constants_msg.dart';
import '../../utils/sharedprefs_helper.dart';

//Construccion del formulario de Register
//Aqui se aplica los eventos y estados del RegisterBloc
class SendResetPasswordForm extends StatefulWidget {
  final String? email;
  final String? oldPass;

  const SendResetPasswordForm({Key? key, this.email, this.oldPass})
      : super(key: key);
  @override
  State<SendResetPasswordForm> createState() => _SendResetPasswordFormState();
}

class _SendResetPasswordFormState extends State<SendResetPasswordForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _oldpasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final Prefs _prefs = Prefs();
  ResetBloc? _resetBloc;

  bool? passwordVisible;
  bool? oldpasswordVisible;
  bool? passwordVisible_confir;
  final Repository _repository = Repository(
      odooClient:
          OdooClient(URL_SERVIDO_JOSE)); //"https://its.mivilsoft.com"));

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

    /*if (_firebaseMessaging != null) {
      _firebaseMessaging?.getToken().then((token) {
        tokenFirebase = token.toString();
      });
    }*/
    if (widget.email!.isNotEmpty) {
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
    Navigator.pushReplacementNamed(context, 'login');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed("login");
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: secondary,
            ),
          ),
        ),
        backgroundColor: whiteColor,
        body: BlocListener(
          bloc: _resetBloc,
          listener: (BuildContext context, ResetState state) async {
            if (state.isSubmitting!) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AST.str_process,
                        style: poppinsBold(12, whiteColor),
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ));
            }

            if (state.isSendSuccess!) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 5), () {
                      Navigator.pushReplacementNamed(context, 'login');
                    });
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: secondary,
                      content: ListTile(
                        title: Text(
                          AST.str_pwd_send_mail,
                          style: poppinsBold(
                              // ScreenUtil().setSp(
                              //   5,
                              // ),
                              12,
                              whiteColor),
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          AST.str_review_email,
                          style: poppinsBold(
                              // ScreenUtil().setSp(
                              //   4,
                              // ),
                              12,
                              whiteColor),
                          textAlign: TextAlign.center,
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
                        Text(
                          state.error!,
                          style: poppinsBold(
                              // ScreenUtil().setSp(
                              //   4,
                              // ),
                              12,
                              whiteColor),
                        ),
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
                      height: MediaQuery.of(context).size.height * 1.25 / 3.4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            primaryColor,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .1 / 3.7,
                        left: MediaQuery.of(context).size.height * .1 / 2.5,
                        right: MediaQuery.of(context).size.height * .1 / 2.5,
                      ),
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: ExactAssetImage(img_forgot),
                        ),
                      ),
                    ),
                    // SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0.0,
                          MediaQuery.of(context).size.height * 0.32,
                          0.0,
                          MediaQuery.of(context).size.height * 0.094),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: whiteColor,
                        ),
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      prefixIcon: Image.asset(
                                        AST.img_correo,
                                        color: secondary,
                                        scale: 27,
                                      ),
                                      errorStyle: TextStyle(
                                          fontSize: 12, color: redColor),
                                      // poppinsBold(
                                      //     // ScreenUtil().setSp(
                                      //     //   3,
                                      //     // ),
                                      //     12,
                                      //     redColor),
                                      labelText: AST.str_mail,
                                      labelStyle: TextStyle(fontSize: 12)
                                      // poppinsBold(
                                      //     // ScreenUtil().setSp(
                                      //     //   5,
                                      //     // ),
                                      //     12
                                      //     ),
                                      ),
                                  style: poppinsBold(
                                      // ScreenUtil().setSp(
                                      //   5,
                                      // ),
                                      12,
                                      Colors.grey),
                                  autocorrect: false,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (_) {
                                    return !state.isEmailValid!
                                        ? str_valid_mail_invalid
                                        : null;
                                  },
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.1 /
                                      3.5,
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: MaterialButton(
                                      color: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        AST.str_restore,
                                        style: poppinsBold(
                                            // ScreenUtil().setSp(
                                            //   5,
                                            // ),
                                            12,
                                            whiteColor),
                                      ),
                                      onPressed: () {
                                        _resetBloc!.add(SendToken(
                                            _emailController.text.toString(),
                                            ""));
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
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
      EmailChanged(email: _emailController.text.trim()),
    );
  }

  void _onPasswordChanged() {
    if (_confirmPasswordController.text.isNotEmpty) {
      _resetBloc!.add(
        ConfirmPasswordChanged(
            password: _passwordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim()),
      );
    } else {
      _resetBloc!.add(
        PasswordChanged(password: _passwordController.text.trim()),
      );
    }
  }

  void _onConfirmPasswordChanged() {
    _resetBloc!.add(
      ConfirmPasswordChanged(
          password: _passwordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim()),
    );
  }
}
