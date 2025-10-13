import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Eventos o acciones que va a realizar
@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent([List props = const []])
      : super(); //super(props); const to LoginEvent
}

//on bloc
class EmailChanged extends LoginEvent {
  final String? email;

  EmailChanged({@required this.email}) : super([email]); //@required this.email

  @override
  String toString() => 'EmailChanged  { email :$email }';

  @override
  List<Object?> get props => ['EmailChanged  { email :$email }'];
}

//on bloc
class PasswordChanged extends LoginEvent {
  final String? password;

  PasswordChanged({@required this.password}) : super([password]);
  //PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';

  @override
  List<Object?> get props => ['PasswordChanged { password: $password }'];
}

//on bloc
class ChangePassEvent extends LoginEvent {
  @override
  String toString() => 'ChangePassEvent';

  @override
  List<Object?> get props => ['ChangePassEvent'];
}

//on bloc
class DesvincularOfflineEvent extends LoginEvent {
  final String email;
  final String password;
  final String serie;
  final String imei;

  /*DesvincularOfflineEvent(
      {@required this.email,
      @required this.password,
      @required this.serie,
      @required this.imei})
      : super([email, password, serie, imei]);*/
  DesvincularOfflineEvent(
      {required this.email,
      required this.password,
      required this.serie,
      required this.imei})
      : super([email, password, serie, imei]);

  @override
  String toString() => 'DesvincularOfflineEvent';

  @override
  List<Object?> get props => ['DesvincularOfflineEvent'];
}

//on bloc
class Submitted extends LoginEvent {
  final String email;
  final String password;
  final String serie;

  //Submitted({@required this.email, @required this.password,  @required this.serie ,  @required this.imei })
  Submitted({required this.email, required this.password, required this.serie})
      : super([email, password, serie]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password , serie: $serie}';
  }

  @override
  List<Object?> get props =>
      ['Submitted { email: $email, password: $password , serie: $serie}'];
}

//on bloc
class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({required this.email, required this.password})
      : super([email, password]);

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }

  @override
  List<Object?> get props =>
      ['LoginWithCredentialsPressed { email: $email, password: $password}'];
}

class LoginWithFacebook extends LoginEvent {
  @override
  String toString() {
    return 'LoginWithFacebook';
    //return 'LoginWithCredentialsPressed { email: $email, password: $password  }';
  }

  @override
  List<Object?> get props => ['LoginWithFacebook'];
}
