import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class Prefs {
  static final Prefs _instance = Prefs._internal();
  Prefs._internal();
  factory Prefs() => _instance;

  late SharedPreferences _prefs;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  void clear() => _prefs.clear();

  // Booleans
  bool get requireAuthentication =>
      _prefs.getBool(kSharedPrefRequireAuthentication) ?? true;
  set requireAuthentication(bool value) =>
      _prefs.setBool(kSharedPrefRequireAuthentication, value);

  bool get isUser => _prefs.getBool(kSharedPrefIsUser) ?? true;
  set isUser(bool value) => _prefs.setBool(kSharedPrefIsUser, value);

  bool get requireOffline => _prefs.getBool(kSharedPrefOffline) ?? false;
  set requireOffline(bool value) => _prefs.setBool(kSharedPrefOffline, value);

  bool get requireGPS => _prefs.getBool(kSharedPrefGPS) ?? false;
  set requireGPS(bool value) => _prefs.setBool(kSharedPrefGPS, value);

  bool get resetPass => _prefs.getBool(KSharedPrefResetPass) ?? false;
  set resetPass(bool value) => _prefs.setBool(KSharedPrefResetPass, value);

  bool get isDarkThemeEnabled =>
      _prefs.getBool(kSharedPrefIsDarkThemeEnabled) ?? false;
  set isDarkThemeEnabled(bool value) =>
      _prefs.setBool(kSharedPrefIsDarkThemeEnabled, value);

  bool get accountValidate =>
      _prefs.getBool(KSharedPrefValidateAccount) ?? false;
  set accountValidate(bool value) =>
      _prefs.setBool(KSharedPrefValidateAccount, value);

  bool get activeService => _prefs.getBool(kSharedActiveService) ?? false;
  set activeService(bool value) => _prefs.setBool(kSharedActiveService, value);

  // Ints
  int get idUser => _prefs.getInt(kSharedPrefIdUser) ?? 0;
  set idUser(int? value) => _prefs.setInt(kSharedPrefIdUser, value ?? 0);

  int get idUserPartner => _prefs.getInt(kSharedPrefIdUserPartner) ?? 0;
  set idUserPartner(int value) =>
      _prefs.setInt(kSharedPrefIdUserPartner, value);

  int get tiempoSeconds => _prefs.getInt(kSharedPrefTimeSecond) ?? 0;
  set tiempoSeconds(int value) => _prefs.setInt(kSharedPrefTimeSecond, value);

  int get idTo => _prefs.getInt(kSharedPrefIdTo) ?? 0;
  set idTo(int value) => _prefs.setInt(kSharedPrefIdTo, value);

  int get idFrom => _prefs.getInt(kSharedPrefIdFrom) ?? 0;
  set idFrom(int value) => _prefs.setInt(kSharedPrefIdFrom, value);

  int get idStatus => _prefs.getInt(kSharedPrefIdStatus) ?? 0;
  set idStatus(int value) => _prefs.setInt(kSharedPrefIdStatus, value);

  int get idPickCon => _prefs.getInt(kSharedPrefIdPickCon) ?? 0;
  set idPickCon(int value) => _prefs.setInt(kSharedPrefIdPickCon, value);

  // Strings
  String get userName => _prefs.getString(kSharedPrefName) ?? '';
  set userName(String value) => _prefs.setString(kSharedPrefName, value);

  String get email => _prefs.getString(kKeychainEmail) ?? '';
  set email(String value) => _prefs.setString(kKeychainEmail, value);

  String get sessionId => _prefs.getString(kKeychainSessionId) ?? '';
  set sessionId(String value) => _prefs.setString(kKeychainSessionId, value);

  String get secret => _prefs.getString(kKeychainSecret) ?? '';
  set secret(String value) => _prefs.setString(kKeychainSecret, value);

  String get verifiedUser =>
      _prefs.getString(kSharedPrefVerifiedUser) ?? 'none';
  set verifiedUser(String? value) =>
      _prefs.setString(kSharedPrefVerifiedUser, value ?? '');

  String get requireUserPhoto =>
      _prefs.getString(kSharedPrefRequireUserPhoto) ?? 'false';
  set requireUserPhoto(String? value) =>
      _prefs.setString(kSharedPrefRequireUserPhoto, value ?? '');

  String get requireUserPhotoUrl =>
      _prefs.getString(kSharedPrefRequireUserPhotoUrl) ?? '';
  set requireUserPhotoUrl(String? value) =>
      _prefs.setString(kSharedPrefRequireUserPhotoUrl, value ?? '');

  String get servicState => _prefs.getString(kSharedPrefEstadoServicio) ?? '';
  set servicState(String value) =>
      _prefs.setString(kSharedPrefEstadoServicio, value);

  String get cityOrigen => _prefs.getString(kSharedPrefcityOrigen) ?? '';
  set cityOrigen(String value) =>
      _prefs.setString(kSharedPrefcityOrigen, value);

  String get cityCompany => _prefs.getString(kSharedPrefcityCompany) ?? '';
  set cityCompany(String value) =>
      _prefs.setString(kSharedPrefcityCompany, value);

  String get origen => _prefs.getString(KSharedPrefOrigen) ?? '';
  set origen(String value) => _prefs.setString(KSharedPrefOrigen, value);

  String get destino => _prefs.getString(KSharedPrefDestino) ?? '';
  set destino(String value) => _prefs.setString(KSharedPrefDestino, value);

  String get latitud => _prefs.getString(KSharedPrefLatitud) ?? '-1.2490800';
  set latitud(String value) => _prefs.setString(KSharedPrefLatitud, value);

  String get longitud => _prefs.getString(KSharedPrefLongitud) ?? '-78.6167500';
  set longitud(String value) => _prefs.setString(KSharedPrefLongitud, value);

  String get latitudOrigen => _prefs.getString(KSharedPrefLatitudOrigen) ?? '';
  set latitudOrigen(String value) =>
      _prefs.setString(KSharedPrefLatitudOrigen, value);

  String get longitudOrigen =>
      _prefs.getString(KSharedPrefLongitudOrigen) ?? '';
  set longitudOrigen(String value) =>
      _prefs.setString(KSharedPrefLongitudOrigen, value);

  String get cedula => _prefs.getString(kSharedPrefCedula) ?? '';
  set cedula(String value) => _prefs.setString(kSharedPrefCedula, value);

  String get direccion => _prefs.getString(kSharedPrefDireccion) ?? '';
  set direccion(String value) => _prefs.setString(kSharedPrefDireccion, value);

  String get telefono => _prefs.getString(kSharedPrefTelefono) ?? '';
  set telefono(String value) => _prefs.setString(kSharedPrefTelefono, value);

  String get changePassword => _prefs.getString(kKeychangePassword) ?? 'false';
  set changePassword(String value) =>
      _prefs.setString(kKeychangePassword, value);

  String get distanceMeters => _prefs.getString(kSharedPrefIPTraccar) ?? '10.0';
  set distanceMeters(String value) =>
      _prefs.setString(kSharedPrefIPTraccar, value);

  String get lastLogin => _prefs.getString(kKeychainLastLogin) ?? '';
  set lastLogin(String value) => _prefs.setString(kKeychainLastLogin, value);

  // Guardar y leer credenciales
  Future<void> saveLoginCredentials(String email, String password) async {
    await _prefs.setString('login_email', email);
    await _prefs.setString('login_password', password);
  }

  Future<Map<String, String>> getLoginCredentials() async {
    return {
      'email': _prefs.getString('login_email') ?? '',
      'password': _prefs.getString('login_password') ?? '',
    };
  }

  Future<void> clearSession() async {
    await _prefs.remove(kKeychainSessionId);
    await _prefs.remove(kSharedPrefIdUser);
    await _prefs.remove(kSharedPrefIdUserPartner);
  }

  bool? get locationPermissionAsked =>
      _prefs?.getBool('location_permission_asked');
  set locationPermissionAsked(bool? value) =>
      _prefs?.setBool('location_permission_asked', value ?? false);

// 🆕 NUEVO: Para cámara:
  bool? get cameraPermissionAsked => _prefs?.getBool('camera_permission_asked');
  set cameraPermissionAsked(bool? value) =>
      _prefs?.setBool('camera_permission_asked', value ?? false);

// También puedes agregar métodos para limpiar estas banderas si necesitas:
  void resetLocationPermission() {
    locationPermissionAsked = false;
  }

  void resetCameraPermission() {
    cameraPermissionAsked = false;
  }

  void resetAllPermissions() {
    resetLocationPermission();
    resetCameraPermission();
  }
}
