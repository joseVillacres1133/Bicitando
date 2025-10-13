import 'package:bicis_ambato/blocs/auth/changePass/bloc.dart';
import 'package:bicis_ambato/blocs/auth/changePass/change_pswd_bloc.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../style/style.dart';
import '../../utils/constants_msg.dart';
import '../pswd_text_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  //final Repository _repository = Repository(odooClient: OdooClient(LOCAL_BASE_URL));
  ChangePswdBloc? changePswdBloc;
  final prefs = Prefs();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool? passwordVisible;
  bool? passwordVisibleConfir;
  bool? newPasswordVisible;

  @override
  void initState() {
    super.initState();
    changePswdBloc = ChangePswdBloc();

    _oldPasswordController.addListener(_onOldPasswordChanged);
    _newPasswordController.addListener(_onNewPasswordChanged);
    _confirmNewPasswordController.addListener(_onConfirmNewPasswordChanged);

    passwordVisible = true;
    passwordVisibleConfir = true;
    newPasswordVisible = true;
  }

  void _onOldPasswordChanged() {}
  void _onNewPasswordChanged() {
    if (_newPasswordController.text.isNotEmpty) {
      changePswdBloc!.add(
          NewPasswordChanged(newPassword: _newPasswordController.text.trim()));

      print('new confirm passwd');
      print(changePswdBloc!.state.isNewPasswordValid);
    }
  }

  void _onConfirmNewPasswordChanged() {
    changePswdBloc!.add(ConfirmPasswordChanged(
        password: _newPasswordController.text.trim(),
        confirmPassword: _confirmNewPasswordController.text.trim()));
    // changePswdBloc!.add(
    //   ConfirmPasswordChanged(password:  ,
    //   confirmPassword: ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: changePswdBloc,
        listener: (BuildContext context, ChangePswdState state) {
          if (state.isFailure!) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      str_process,
                      style: poppinsBold(12, whiteColor),
                    ),
                    const CircularProgressIndicator(),
                  ],
                ),
              ));
          }
          if (state.isSuccess!) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext buildcontext) {
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(buildcontext).pop();
                    //changePswdBloc.
                    Navigator.pushReplacementNamed(context, 'profile');
                  });
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: purplelight,
                    content: const ListTile(
                      title: Text(
                        'Cambio extitoso',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'La contraseña se ha cambiado correctamente',
                        style: TextStyle(color: whiteColor),
                      ),
                    ),
                  );
                });
          }
        },
        child: BlocBuilder(
            bloc: changePswdBloc,
            builder: (BuildContext context, ChangePswdState state) {
              return Column(children: <Widget>[
                _oldPasswordField(state),
                _newPasswordField(state),
                _confirmNewPasswordField(state),
                Container(
                  margin: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                    onPressed: enableButtonChangePswd(state)
                        ? () {
                            changePswdBloc!.add(Submitted(
                                oldPassword: _oldPasswordController.text.trim(),
                                secret: prefs.secret!,
                                newPassword:
                                    _newPasswordController.text.trim()));
                            // Navigator.of(context).pushReplacementNamed("change-psswd");
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor:
                          const Color.fromARGB(100, 23, 57, 97),
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 48.0), // Adjust the padding as needed
                      child: Text(str_change_passwd),
                    ),
                  ),
                ),
              ]);
            }));
  }

  bool enableButtonChangePswd(ChangePswdState state) {
    bool isEnable;
    isEnable = _oldPasswordController.text != '' &&
        _confirmNewPasswordController.text != '' &&
        _newPasswordController.text != '' &&
        state.isNewPasswordValid &&
        state.isOldPasswordValid &&
        state.isConfirmPasswordValid;

        return isEnable;
  }

  Widget _oldPasswordField(ChangePswdState state) {
    return PasswordTextFieldWidget(
        keyboardType: TextInputType.text,
        controller: _oldPasswordController,
        icon: const Icon(
          Icons.password_rounded,
          color: secondary,
        ),
        hintText: str_enter_current_pass,
        isValid: state.isOldPasswordValid,
        errorMessage: '',
        passwordVisible: passwordVisible!);
  }

  Widget _newPasswordField(ChangePswdState state) {
    return PasswordTextFieldWidget(
        keyboardType: TextInputType.text,
        controller: _newPasswordController,
        icon: const Icon(
          Icons.password_rounded,
          color: secondary, // Color del icono

          // Color del icono
        ),
        hintText: "Contraseña",
        isValid: state.isNewPasswordValid,
        errorMessage: str_valid_characters,
        passwordVisible: passwordVisible!);
  }

  Widget _confirmNewPasswordField(ChangePswdState state) {
    return PasswordTextFieldWidget(
        keyboardType: TextInputType.text,
        controller: _confirmNewPasswordController,
        icon: const Icon(
          Icons.password_rounded,
          color: secondary,
        ),
        hintText: str_confirm_pwd,
        isValid: state.isConfirmPasswordValid,
        errorMessage: str_valid_pwd,
        passwordVisible: passwordVisible!);
  }
}
//activar una tarjeta debe dar una  tarjeta
