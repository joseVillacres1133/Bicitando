import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Estado de la clase Principal
@immutable
abstract class AuthState extends Equatable {
  const AuthState([List props = const []]); //super(props);
}

class Uninitialized extends AuthState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object?> get props => ['Uninitialized'];
}

class Authenticated extends AuthState {
  final String displayName;

  Authenticated(this.displayName) : super([displayName]);

  @override
  List<Object?> get props => [displayName];
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object?> get props => ['Unauthenticated'];
}

class UnauthenticatedOffline extends AuthState {
  @override
  String toString() => 'UnauthenticatedOffline';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Locked extends AuthState {
  @override
  String toString() => 'LocalAuth';

  @override
  // TODO: implement props
  List<Object?> get props =>
      throw UnimplementedError(); //Estado Autentificacion con PIN
}

class LockedFingerprint extends AuthState {
  @override
  String toString() => 'LockedFingerprint';

  @override
  // TODO: implement props
  List<Object?> get props =>
      throw UnimplementedError(); //Estado Autentificacion con Fingerprint
}

class LockedFaceId extends AuthState {
  @override
  String toString() => 'LockedFaceId';

  @override
  // TODO: implement props
  List<Object?> get props =>
      throw UnimplementedError(); //Estado Autentificacion con FaceId(IOS)
}
