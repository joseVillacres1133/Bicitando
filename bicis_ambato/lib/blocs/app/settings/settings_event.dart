import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Eventos o acciones que va a realizar el widget settings
@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent([List props = const []])
      : super(); //;super(props);  const
}

class LoadPrefs extends SettingsEvent {
  //Poner configuraciones por default
  @override
  String toString() => 'LoadPrefs';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DarkTheme extends SettingsEvent {
  //Configurar a tema oscuro
  @override
  String toString() => 'DarkTheme';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LightTheme extends SettingsEvent {
  //Configurar a tema claro
  @override
  String toString() => 'LightTheme';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class EnablePIN extends SettingsEvent {
  //Habilitar PIN
  @override
  String toString() => 'EnablePIN';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DisablePIN extends SettingsEvent {
  //Deshabilitar PIN
  @override
  String toString() => 'DisablePIN';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class EnableBiometric extends SettingsEvent {
  //Habilitar Biometrico
  @override
  String toString() => 'EnableBiometric';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DisableBiometric extends SettingsEvent {
  //Deshabilitar Biometrico
  @override
  String toString() => 'DisableBiometric';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class EnableFingerPrint extends SettingsEvent {
  //Habilitar Fingerprint
  @override
  String toString() => 'EnableFingerPrint';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DisableFingerPrint extends SettingsEvent {
  //Deshabilitar Fingerprint
  @override
  String toString() => 'DisableFingerPrint';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class EnableFaceId extends SettingsEvent {
  //Habilitar FaceId
  @override
  String toString() => 'EnableFaceId';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DisableFaceId extends SettingsEvent {
  //Deshabilitar FaceId
  @override
  String toString() => 'DisableFaceId';

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
