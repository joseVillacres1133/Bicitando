import 'package:bicis_ambato/blocs/auth/resetPass/reset_bloc.dart';
import 'package:bicis_ambato/blocs/auth/resetPass/reset_event.dart';
import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../blocs/auth/resetPass/reset_state.dart';
import '../data/repository.dart';
import '../style/style.dart';
import '../utils/constants.dart';
import '../utils/sharedprefs_helper.dart';
import '../widget/header.dart';
import '../widget/municipio_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen(
      {super.key,
      @required Repository? repository,
      @required BuildContext? context})
      : assert(repository != null);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController(); // http://192.168.100.16:8069

  final Repository _repository = Repository(odooClient: OdooClient(BASE_URL));//"https://its.mivilsoft.com")); // http://190.63.136.138:8069

  ResetBloc? _resetBloc;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _resetBloc = ResetBloc();
    isValid = _resetBloc!.state.isEmailValid;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, 'login');
        },
        child: SafeArea(
          
          child: 
                Scaffold(
            resizeToAvoidBottomInset: true, // appBar: AppBar(
            body: BlocListener(
                bloc: _resetBloc,
                listener: (BuildContext context, ResetState state) async {
                  if (state.isSubmitting!) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        backgroundColor: purplelight,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              str_process,
                              style: poppinsBold(
                                  // ScreenUtil().setSp(
                                  //   4,
                                  // ),
                                  12,
                                  whiteColor),
                            ),
                            const CircularProgressIndicator(
                              color: yellow,
                            ),
                          ],
                        ),
                      ));
                  }
                  if (state.isSuccess!) {
                    Prefs().resetPass = true;
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext buildcontext) {
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.of(buildcontext).pop();
                            _resetBloc!.initialState;
                            Navigator.pushReplacementNamed(context, 'login');
                          });
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: purplelight,
                            content: const ListTile(
                              title: Text(
                                str_review_email,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                str_pwd_send_mail,
                                style: TextStyle(color: whiteColor),
                              ),
                            ),
                          );
                        });
                  }

                  if (state.isFailure!) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext buildcontext) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(buildcontext).pop();
                            _resetBloc!.initialState;
                            //Navigator.pushReplacementNamed(context, 'login');
                          });
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: redColor,
                            content: ListTile(
                              title: const Text(
                                str_title_wrong,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                state.error!,
                                style: const TextStyle(color: whiteColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        });
                  }
                },
                child: BlocBuilder(
                    bloc: _resetBloc,
                    builder: (BuildContext context, ResetState state) {
                      return Stack(
                        children: [
                          Header(
                              nameScreen: str_restore_pswd,
                              route: str_rout_login),

                          Align(
                            alignment: const AlignmentDirectional(0.0, -0.75),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                color: transp,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  img_reset_icon,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: const AlignmentDirectional(0, 1.0),
                            child: Container(
                                margin: const EdgeInsetsDirectional.only(
                                    bottom: 20),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.63,
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
                                child: Column(
                                  children: [
                                    formUI(state, context),
                                    Container(
                                      margin: const EdgeInsets.all(25.0),
                                      child: ElevatedButton(
                                        onPressed: state.isEmailValid
                                            ? () {
                                                _resetBloc!.add(Submitted(
                                                    _emailController.text, "",'',''));
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          disabledBackgroundColor:
                                              const Color.fromARGB(
                                                  100, 23, 57, 97),
                                          backgroundColor: primaryColor,
                                          foregroundColor: whiteColor,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0,
                                              horizontal:
                                                  48.0), // Adjust the padding as needed
                                          child: Text(str_restore),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.00, 1),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: beige,
                                ),
                                child: BarMunicipio()),
                          ),  
                        ],
                      );
                    })))
                    
        )

                    );
  }

  Widget formUI(ResetState state, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [_mailField(state)],
      ),
    );
  }

  void _onEmailChanged() {
    _resetBloc!.add(EmailChanged(email: _emailController.text.trim()));
  }

  bool isValid = false;
  Widget _mailField(ResetState state) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            margin:
                const EdgeInsets.symmetric(vertical: 5.00, horizontal: 5.00),
            decoration: BoxDecoration(
              //color: Colors.grey[100], // Color de fondo gris
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.mail_rounded,
                  color: secondary, // Color del icono
                ),
                const SizedBox(
                    width: 10.0), // Espacio entre el icono y el TextFormField
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      //hintText: hintText,
                      label: Text(str_mail),
                      //border: Inp,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      if (!state.isEmailValid) {
                        return str_valid_mail_invalid;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}
