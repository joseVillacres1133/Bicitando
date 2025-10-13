import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user.dart';

//Eventos o acciones que va a realizar el RegisterForm
@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent([List props = const []]) : super(); //super(props);
}

class CreateAccountPressed extends RegisterEvent {
  @override
  String toString() {
    return 'CreateAccountPressed';
    //return 'LoginWithCredentialsPressed { email: $email, password: $password  }';
  }

  @override
  List<Object?> get props => ['CreateAccountPressed'];
}

class EmailChanged extends RegisterEvent {
  final String? email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  // TODO: implement props
  List<Object?> get props => ['EmailChanged { email :$email }'];
}

class NameChanged extends RegisterEvent {
  final String? name;

  NameChanged({@required this.name}) : super([name]);

  @override
  String toString() => 'NameChanged { name :$name }';

  @override
  List<Object?> get props => ['NameChanged { name :$name }'];
}

class CedulaChanged extends RegisterEvent {
  final String? cedula;
  final String? passport;

  CedulaChanged({@required this.cedula, @required this.passport})
      : super([cedula, passport]);

  @override
  String toString() => 'CedulaChanged { cedula :$cedula, passport :$passport }';

  @override
  List<Object?> get props =>
      ['CedulaChanged { cedula :$cedula, passport :$passport }'];
}

class DireccionChanged extends RegisterEvent {
  final String? direccion;

  DireccionChanged({@required this.direccion}) : super([direccion]);

  @override
  String toString() => 'DireccionChanged { direccion :$direccion }';

  @override
  List<Object?> get props => ['DireccionChanged { direccion :$direccion }'];
}

class PhoneChanged extends RegisterEvent {
  final String? phone;

  PhoneChanged({@required this.phone}) : super([phone]);

  @override
  String toString() => 'PhoneChanged { phone :$phone }';

  @override
  List<Object?> get props => ['PhoneChanged { phone :$phone }'];
}

class FingerprintCodeChanged extends RegisterEvent {
  final String? fingerprintCode;

  FingerprintCodeChanged({@required this.fingerprintCode})
      : super([fingerprintCode]);

  @override
  String toString() =>
      'FingerprintCodeChanged { fingerprint_code :$fingerprintCode }';

  @override
  List<Object?> get props => throw UnimplementedError();
}

class PasswordChanged extends RegisterEvent {
  final String? password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';

  @override
  List<Object?> get props => ['PasswordChanged { password: $password }'];
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String? password;
  final String? confirmPassword;

  ConfirmPasswordChanged(
      {@required this.password, @required this.confirmPassword})
      : super([password, confirmPassword]);

  @override
  String toString() =>
      'ConfirmPasswordChanged { password: $password, confirmPassword: $confirmPassword }';

  @override
  List<Object?> get props => [
        'ConfirmPasswordChanged { password: $password, confirmPassword: $confirmPassword }'
      ];
}

class TermsAndConditiosnChange extends RegisterEvent {
  final bool isChecked;

  TermsAndConditiosnChange({required this.isChecked}) : super([isChecked]);

  @override
  List<Object?> get props => [''];
}

class Submitted extends RegisterEvent {
  final User user;
  Submitted({required this.user}) : super([user]);

  @override
  String toString() {
    return 'Submitted { user: $user }';
  }

  @override
  List<Object?> get props => ['Submitted { user: $user }'];
}

class ButtonSubmitPressed extends RegisterEvent {
  final bool? isFormValid;
  ButtonSubmitPressed({@required this.isFormValid}) : super([isFormValid]);
  
  @override
  List<Object?> get props => ['isSubmitting { isSubmitting: $isFormValid }'];
}

class ErrorSignup extends RegisterEvent {
  final String? error;
  //final bool? isFailure;

  ErrorSignup({@required this.error}): super([error]);

  @override
  List<Object?> get props => ['error {' ];
  
}


