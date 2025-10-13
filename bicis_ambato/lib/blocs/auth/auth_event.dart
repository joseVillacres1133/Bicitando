import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Eventos o acciones que va a realizar la clase principal
@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent([List props = const []]) : super();
}

class AppStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object?> get props => ['AppStarted'];
}

class LoggedIn extends AuthEvent {
  @override
  String toString() => 'LoggedIn';

  @override
  List<Object?> get props => ['LoggedIn'];
}

class LoggedOut extends AuthEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object?> get props => ['LoggedOut'];
}
