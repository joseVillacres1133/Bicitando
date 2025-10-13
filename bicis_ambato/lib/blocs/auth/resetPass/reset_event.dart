import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Eventos o acciones que va a realizar el RegisterForm
@immutable
abstract class ResetEvent extends Equatable {
  const ResetEvent([List props = const []]) : super(); // super(props);
}

class EmailChanged extends ResetEvent {
  final String? email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  List<Object?> get props => ['EmailChanged { email :$email }'];
}

class OldPasswordChanged extends ResetEvent {
  final String? password;

  OldPasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';

  @override
  List<Object?> get props => ['PasswordChanged { password: $password }'];
}
class PasswordChanged extends ResetEvent {
  final String? password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';

  @override
  List<Object?> get props => ['PasswordChanged { password: $password }'];
}

class ConfirmPasswordChanged extends ResetEvent {
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

class Submitted extends ResetEvent {
  final String email;
  final String oldPass;
  final String password;
  final String confirmPassword;
  Submitted(this.email, this.password, this.confirmPassword, this.oldPass)
      : super([email, password, confirmPassword, oldPass]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }

  @override
  List<Object?> get props =>
      ['Submitted { email: $email, password: $password }'];
}

class SendToken extends ResetEvent {
  final String email;
  final String token;
  SendToken(this.email, this.token) : super([email, token]);

  @override
  String toString() {
    return 'SendToken { email: $email, token: $token }';
  }

  @override
  List<Object?> get props => ['SendToken { email: $email, token: $token }'];
}
