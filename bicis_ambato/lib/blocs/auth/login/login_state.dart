// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

//Estados del Login Form
@immutable
class LoginState {
  final bool isEmailValid; //Si el email es verdadero
  final bool isPasswordValid; //Si la contraseña es verdadera
  final bool isSubmitting; //Si se presiono el botton
  final bool isSuccess; //exito al registrar
  final bool isChangeSuccess; //exito al registrar
  final bool isFailure; //fallo al registrar
  final bool isOffline;
  final String mensaje; //mensaje de error

  bool get isFormValid => isEmailValid && isPasswordValid;

  //se removio @
  const LoginState({
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isChangeSuccess,
    required this.isFailure,
    required this.isOffline,
    required this.mensaje,
  });

  //se agrega mensaje = '',
  factory LoginState.empty() {
    return const LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isChangeSuccess: false,
      isFailure: false,
      isOffline: false,
      mensaje: '',
    );
  }

  factory LoginState.loading() {
    return const LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isChangeSuccess: false,
      isFailure: false,
      isOffline: false,
      mensaje: '',
    );
  }

  factory LoginState.offline() {
    return const LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isChangeSuccess: false,
      isFailure: false,
      isOffline: true,
      mensaje: '',
    );
  }

  factory LoginState.failure(String mensaje) {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isChangeSuccess: false,
      isFailure: true,
      isOffline: false,
      mensaje: mensaje,
    );
  }

  factory LoginState.success() {
    return const LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isChangeSuccess: false,
      isFailure: false,
      isOffline: false,
      mensaje: '',
    );
  }

  factory LoginState.changesuccess() {
    return const LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isChangeSuccess: true,
      isFailure: false,
      isOffline: false,
      mensaje: '',
    );
  }

  // se agrego required
  LoginState update({
    required bool isEmailValid,
    required bool isPasswordValid,
  }) {
    //se agrego isSubmitEnabled: false,
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isChangeSuccess: false,
      isFailure: false,
      isOffline: false,
      isSubmitEnabled: false,
    );
  }

  LoginState copyWith({
   bool? isEmailValid,
  bool? isPasswordValid,
  bool? isSubmitEnabled,
  bool? isSubmitting,
  bool? isSuccess,
  bool? isChangeSuccess,
  bool? isFailure,
  bool? isOffline,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isChangeSuccess: isChangeSuccess ?? this.isChangeSuccess,
      isFailure: isFailure ?? this.isFailure,
      isOffline: isOffline ?? this.isOffline,
      mensaje: '',
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isOffline: $isOffline,
    }''';
  }
}
