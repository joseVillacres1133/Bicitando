import 'dart:io';

import 'package:bicis_ambato/utils/constants.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SessionChangedCallback = void Function(OdooSession sessionId);
final _prefs = Prefs();

/// Callback for session changed events
SessionChangedCallback storeSesion(SharedPreferences prefs) {
  /// Define func that will be called on every session update.
  /// It receives configured [SharedPreferences] instance.
  void sessionChanged(OdooSession sessionId) {
    if (sessionId.id == '') {
      Prefs().sessionId = '';
    } else {
      Prefs().sessionId = sessionId.id;
    }
  }

  return sessionChanged;
}

class OdooRPC {
  //final String baseUrl = 'http://181.198.191.105:8017';
  //final String localBaseUrl = 'http://192.168.100.60:8069';
  //final String localBaseUrl = 'http://192.168.100.60:8069';
  late OdooClient client;

  // Singleton instance
  static final OdooRPC _instance = OdooRPC._internal();

  factory OdooRPC() {
    return _instance;
  }

  OdooRPC._internal() {
    // Constructor privado para evitar instancias adicionales

    client = OdooClient(
        BASE_URL); //"https://its.mivilsoft.com" http://190.63.136.138:8069
  }

  Future<bool> checkSessionExpired() async {
    try {
      await client.checkSession().then((value) => {print(value)});
      return false;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<dynamic> authenticate(String db, String login, String password) async {
    //checkSessionExpired();
    final OdooSession response;
    try {
      response = await client.authenticate(db, login, password);
      DateTime now = DateTime.now();
      _prefs.lastLogin = now.toIso8601String();
      print(response);
      return response;
    } on OdooException {
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    }
    //Prefs().sessionId = response.id;
    //response.updateSessionId();

    //   final sessionString ='';
    // OdooSession? session = sessionString == null
    //     ? null
    //     : OdooSession.fromJson(json.decode(sessionString));
    //final orpc = OdooClient(databaseURL, session);
  }

  // Future<void> getSessionInfo() async {
  //   dynamic response = client.checkSession();
  //   client.sessionId;
  // }

  Future<void> destroySession() async {
    await client.destroySession();
  }

  Future<dynamic> callKW(String model, String method, List<dynamic> args,
      List<dynamic> domain, List<dynamic> fields, String order) async {
    var kwargs;
    var argsCKW;
    if (method == 'search_read') {
      argsCKW = {};
      kwargs = {
        'context': {'bin_size': true},
        'domain': domain, // [ ['id', '=', uid] ]
        'fields': fields // ['id', 'name', '__last_update', imageField],
      };
      if (order.isNotEmpty) {
        kwargs['order'] = order;
      }
    } else {
      argsCKW = args;
      kwargs = {};
    }
    try {
      dynamic response = await client.callKw({
        'model': model,
        'method': method,
        'args': argsCKW,
        'kwargs': kwargs,
      });
      return response;
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    }
  }

//circuitos despachadores
  Future<dynamic> callRPC(path, funcName, params) async {
    try {
      var response = await client.callRPC(path, funcName, params);
      return response;
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    }
  }

  // Future<dynamic> getEmailVerificate(String email, int op) async {
  //   const path = '/web/session/resuserAdmin/search_read';
  //   dynamic response = await client.callRPC(
  //     path,
  //     'resuserAdmin',
  //     {"valueSearch": email});
  //   if(response != null){
  //     return response;
  //   }else{
  //     return null;
  //   }
  // }

  // Future<UserInfoOdoo?> searchUserByIdentifierOrIDApiIdentifier() async{
  //   const path = '/web/session/wego/user/partner/info/data/identifier';
  //   UserInfoOdoo response = await client.callRPC(path, '', 'params');
  // }
}
