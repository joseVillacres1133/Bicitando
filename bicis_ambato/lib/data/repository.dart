import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../utils/constants_msg.dart';
import '../utils/sharedprefs_helper.dart';
import 'auth_provider.dart';
import 'models/odoo/MessageRequestOdoo.dart';
import 'models/user.dart';

//Repositorio donde se realiza las acciones de login y register (MODO ONLINE Y OFFLINE)
class Repository {
  final AuthProvider _authProvider;

  //DatabaseHelper _databaseHelper = DatabaseHelper();
  final _prefs = Prefs();

  Repository({@required odooClient})
      : assert(odooClient != null),
        _authProvider = AuthProvider();

  Future<bool?> authenticate(String email, String password) async {
    final OdooSession? data = await _authProvider.authenticate(email, password);

    if (data != null) {
      try {
        User user = await _authProvider.getInfoUser(data, password);
        _prefs.sessionId = data.id;
        _prefs.idUser = data.userId;
        _prefs.idUserPartner = data.partnerId;
        _prefs.idUserPartner = data.partnerId;
        _prefs.secret = password;

        _prefs.userName = data.userName;
        _prefs.email = data.userLogin;
        _prefs.direccion = user.direccion!;
        _prefs.cedula = user.cedula!;//user.cedula!;
        _prefs.telefono = user.phone!;
        _prefs.requireUserPhoto = user.image_1920!;
        _prefs.requireAuthentication = false;
        _prefs.isUser = user.isUser!;
        if (user.documentVerified == null || user.documentVerified!.isEmpty) {
          _prefs.verifiedUser = "none";
        }else{
          _prefs.verifiedUser = user.documentVerified!;
        }

        _prefs.cityCompany = "Ambato";
        print(' odooSession.userId');
        print(data.userId);
        return true;
      } on OdooException catch (_) {
        print(_);
        rethrow;
      } on SocketException {
        rethrow;
      } on Exception {
        rethrow;
      }
    } else {
      return false;
    }
  }

  //Salir Cuenta del Usuario(MODO ONLINE)
  Future<void> signOut() async {
    // cambia la configuracion para que se actualice la sesion y se pueda iniciar sesion
    var cityCompany = 'Ambato'; //_prefs.cityCompany;

    _prefs.clear();
    //if (facebook) {
    //  facebookLogin.logOut();
    //} else {
    _authProvider.signOut();
    //}
    //_prefs.imeiUser = "0000";
    //_prefs.user = "User Name";
    _prefs.email = str_mail;
    _prefs.direccion = str_address;
    _prefs.cedula = str_ci;
    _prefs.telefono = str_phone;

    _prefs.cityCompany = cityCompany;
    _prefs.requireAuthentication = true;
  }

  Future<dynamic> signUp(User user) async {
    var data = await _authProvider.signUp(user);

    if (data != null) {
    
      return data;
    }
  }



  Future<MessageRequestOdoo> sendEmailUser(String email) async {
    MessageRequestOdoo res = MessageRequestOdoo(false, "", "");
    if (email.isNotEmpty) {
      res = await _authProvider.sendEmailUserResetPassword(email);
    }
    return res;
  }

  // Future<MessageRequestOdoo> verificateCodeUser(
  //     String code, String partnerId) async {
  //   MessageRequestOdoo message = MessageRequestOdoo(false, "", "");
  //   if (code.isNotEmpty) {
  //     message = await _authProvider.verificateCodeUserValidate(code, partnerId);
  //   }
  //   return message;
  // }

  // Future<dynamic> getSMSNewCode(String partnerId) async {
  //   MessageRequestOdoo message = MessageRequestOdoo(false, "", "");
  //   if (partnerId.isNotEmpty) {
  //     message = await _authProvider.getSMSCode(partnerId);
  //   }
  //   return message;
  // }
}
