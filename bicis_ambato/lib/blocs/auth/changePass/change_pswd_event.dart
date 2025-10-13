import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ChangePswdEvent extends Equatable {
  const ChangePswdEvent([List props = const []]) : super();
}

class OldPasswordChanged extends ChangePswdEvent {
  final String? oldPassword;

  OldPasswordChanged({@required this.oldPassword}) : super([oldPassword]);

  @override
  String toString() => 'PasswordChanged { password: $oldPassword }';

  @override
  List<Object?> get props => ['PasswordChanged { password: $oldPassword }'];
}

class NewPasswordChanged extends ChangePswdEvent {
  final String? newPassword;

  NewPasswordChanged({@required this.newPassword}) : super([newPassword]);

  @override
  String toString() => 'PasswordChanged { password: $newPassword }';

  @override
  List<Object?> get props => ['PasswordChanged { password: $newPassword }'];
}

class ConfirmPasswordChanged extends ChangePswdEvent {
  final String? password;
  final String? confirmPassword;

  ConfirmPasswordChanged(
      {@required this.password, @required this.confirmPassword})
      : super([password, confirmPassword]);

  @override
  String toString() => 'PasswordChanged { password: $password }';

  @override
  List<Object?> get props => ['PasswordChanged { password: $password }'];
}

class Submitted extends ChangePswdEvent {
  final String oldPassword;
  final String secret;
  final String newPassword;

  Submitted({required this.oldPassword, required this.secret, required this.newPassword}) : super();

  @override
  // TODO: implement props
  List<Object?> get props => [oldPassword,secret, newPassword];
}
