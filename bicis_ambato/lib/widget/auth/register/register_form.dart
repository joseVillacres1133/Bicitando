import 'package:bicis_ambato/widget/pswd_text_field.dart';
import 'package:flutter/material.dart';

import 'package:bicis_ambato/widget/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../../../blocs/auth/register/bloc.dart';
import '../../../data/models/user.dart';
import '../../../style/style.dart';
import '../../../utils/constants_msg.dart';
import '../../../utils/sharedprefs_helper.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Controllers para los campos de entrada
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool? passwordVisible;
  bool? passwordVisibleConfir;
  bool _isChecked = false;

  late RegisterBloc _registerBloc;
  final Prefs _prefs = Prefs();

  bool get isPopulated =>
      _cedulaController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _nameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _isChecked;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    // Listeners
    _cedulaController.addListener(_onCedulaChanged);
    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
    // _direccionController.addListener(_onDireccionChanged);
    // _telefonoController.addListener(_onPhoneChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);

    passwordVisible = true;
    passwordVisibleConfir = true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => Navigator.pushReplacementNamed(context, 'login'),
      child: BlocListener<RegisterBloc, RegisterState>(
        bloc: _registerBloc,
        listener: (context, state) async {
          if (state.isSubmitting!) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                backgroundColor: purplelight,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(str_process),
                    CircularProgressIndicator(color: yellow),
                  ],
                ),
              ));
          }

          if (state.isSuccess!) {
            _prefs.email = "A";

            _clearFormFields();
            FocusScope.of(context).unfocus();

            showDialog(
              context: context,
              barrierDismissible: false, // No permitir cerrar tocando afuera
              builder: (dialogContext) {
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(dialogContext).pop(); // Cerrar diálogo
                  Navigator.pushNamedAndRemoveUntil(
                    context, // Usar el context del widget, no del diálogo
                    'login',
                    (route) => false, // Limpiar todo el stack
                  );
                });
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: purplelight,
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$str_new_account_succes $str_welcome',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            );
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
        child: BlocBuilder<RegisterBloc, RegisterState>(
          bloc: _registerBloc,
          builder: (context, state) {
            // ✅ Usar el estado isSubmitting del BLoC directamente
            final bool isSubmitting = state.isSubmitting ?? false;

            return Stack(
              children: [
                // ✅ CONTENIDO PRINCIPAL - SIEMPRE VISIBLE
                Column(
                  children: [
                    formUI(state, context),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: CheckboxListTile(
                        value: _isChecked,
                        onChanged: isSubmitting
                            ? null
                            : (v) => setState(() => _isChecked = v!),
                        title: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: secondary),
                            children: [
                              const TextSpan(text: 'Acepto los '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: isSubmitting ? null : _launchTermsURL,
                                  child: const Text(
                                    'términos y condiciones',
                                    style: TextStyle(
                                      color: primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(25),
                      child: ElevatedButton(
                        onPressed:
                            (isRegisterButtonEnabled(state) && !isSubmitting)
                                ? () {
                                    _registerBloc.add(ButtonSubmitPressed(
                                        isFormValid: state.isFormValid));
                                    _onFormSubmitted();
                                  }
                                : null,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor:
                              const Color.fromARGB(103, 23, 57, 97),
                          backgroundColor: primaryColor,
                          foregroundColor: whiteColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 48),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(str_create_account),
                        ),
                      ),
                    ),
                  ],
                ),

                // ✅ OVERLAY DE CARGA - SOLO CUANDO ESTÁ PROCESANDO
                if (isSubmitting) ...[
                  Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: primaryColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              str_process,
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _clearFormFields() {
    _cedulaController.clear();
    _nameController.clear();
    _emailController.clear();
    _direccionController.clear();
    _telefonoController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() => _isChecked = false);
  }

  Widget formUI(RegisterState state, BuildContext context) {
    final bool isSubmitting = state.isSubmitting ?? false;

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(children: <Widget>[
          _cedulaField(state, isSubmitting),
          _nameField(state, isSubmitting),
          _mailField(state, isSubmitting),
          _passwordField(state, isSubmitting),
          _confirmPasswordField(state, isSubmitting),
        ]));
  }

  // Campo para Cédula
  Widget _cedulaField(RegisterState state, bool isSubmitting) {
    return TextFieldWidget(
      keyboardType: TextInputType.number,
      controller: _cedulaController,
      icon: Icon(Icons.credit_card,
          color: isSubmitting ? Colors.grey : secondary),
      hintText: 'Cédula',
      isValid: state.isCedulaValid,
      errorMessage: 'Cédula inválida',
    );
  }

  Widget _nameField(RegisterState state, bool isSubmitting) {
    return TextFieldWidget(
      controller: _nameController,
      icon: Icon(
        Icons.person_rounded,
        color: isSubmitting ? Colors.grey : secondary,
      ),
      hintText: str_name_last,
      isValid: state.isNameValid,
      errorMessage: 'Nombre no permitido',
    );
  }

  Widget _mailField(RegisterState state, bool isSubmitting) {
    return TextFieldWidget(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      icon: Icon(
        Icons.mail_rounded,
        color: isSubmitting ? Colors.grey : secondary,
      ),
      hintText: str_mail,
      isValid: state.isEmailValid,
      errorMessage: str_valid_mail_invalid,
    );
  }

  Widget _passwordField(RegisterState state, bool isSubmitting) {
    return PasswordTextFieldWidget(
        keyboardType: TextInputType.text,
        controller: _passwordController,
        icon: Icon(
          Icons.password_rounded,
          color: isSubmitting ? Colors.grey : secondary,
        ),
        hintText: "Contraseña",
        isValid: state.isPasswordValid,
        errorMessage: str_valid_min_characters,
        passwordVisible: passwordVisible!);
  }

  Widget _confirmPasswordField(RegisterState state, bool isSubmitting) {
    return PasswordTextFieldWidget(
        keyboardType: TextInputType.text,
        controller: _confirmPasswordController,
        icon: Icon(
          Icons.password_rounded,
          color: isSubmitting ? Colors.grey : secondary,
        ),
        hintText: str_confirm_pwd,
        isValid: state.isConfirmPasswordValid,
        errorMessage: str_valid_pwd,
        passwordVisible: passwordVisible!);
  }

  void _onCedulaChanged() {
    _registerBloc.add(
      CedulaChanged(cedula: _cedulaController.text.trim(), passport: ""),
    );
  }

  void _onNameChanged() {
    _registerBloc.add(
      NameChanged(name: _nameController.text),
    );
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onDireccionChanged() {
    _registerBloc.add(
      DireccionChanged(direccion: _direccionController.text),
    );
  }

  void _onPhoneChanged() {
    _registerBloc.add(
      PhoneChanged(phone: _telefonoController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onConfirmPasswordChanged() {
    _registerBloc.add(
      ConfirmPasswordChanged(
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text),
    );
  }

  Future _onFormSubmitted() async {
    final user = User(
      _emailController.text.trim(),
      _nameController.text,
      _passwordController.text.trim(),
      cedula: _cedulaController.text.trim(),
    );

    print('User antes de dispatch: $user');

    _registerBloc.add(Submitted(user: user));
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Función para abrir el enlace
  Future<void> _launchTermsURL() async {
    final Uri url = Uri.parse(
        'https://bicitando.mivilsoft.com/condiciones-de-uso-bici-municipal');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el enlace'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
