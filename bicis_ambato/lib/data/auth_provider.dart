// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bicis_ambato/data/models/odoo/FrequentQuestions.dart';
import 'package:bicis_ambato/data/models/odoo/StopsAVehicle.dart';
import 'package:bicis_ambato/data/models/odoo/Travel.dart';
import 'package:bicis_ambato/data/models/vehicle.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:camera/camera.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../utils/constants.dart';
import 'models/odoo/MessageRequestOdoo.dart';
import 'models/stationLine.dart';
import 'models/user.dart';
import 'odoo/odoo_rpc.dart';

class AuthProvider {
  final OdooRPC odooRPC;
  final _prefs = Prefs();

  static final AuthProvider _instance = AuthProvider._internal(OdooRPC());

  factory AuthProvider() {
    return _instance;
  }

  AuthProvider._internal(this.odooRPC);

  Future<OdooSession?> authenticate(String email, String password) async {
    try {
      OdooSession user = await odooRPC.authenticate("odoo", email, password);
      print(user);
      return user;
    } on OdooException catch (_) {
      print(_);
      rethrow;
    } on SocketException catch (socketException) {
      rethrow;
    }
  }

  Future<dynamic> getSessionInfo() async {
    try {
      final response =
          await odooRPC.client.checkSession(); // .getSessionInfo();
      return response.result;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<dynamic> getInfoUser1(int idUser) async {
    List<dynamic> domain = [
      [
        "id",
        "in",
        [idUser]
      ]
    ];
    try {
      var response = await odooRPC.callKW("res.users", "search_read", [],
          domain, ["id", "name", "login", "image_1920"], '');

      if (response != null) {
        var dataUser = response[0];
        User user = User(dataUser["login"], dataUser["name"], '');
        user.image_1920 = dataUser["image_1920"];
        return user;
      }
    } on OdooException catch (_) {
      print(_);
      rethrow;
    } on SocketException {
      rethrow;
    }
  }

  Future<dynamic> getInfoUser(OdooSession odooSession, String secret) async {
    //int userId,String password,int partnerId
    String path = '/jsonrpc';
    String method = 'call';
    var params = {
      "service": "object",
      "method": "execute",
      "args": [
        LOCAL_DATABASE,
        odooSession.userId,
        secret,
        "res.partner",
        "search_read",
        [
          ["id", "=", odooSession.partnerId]
        ],
        ["vat", "street", "city", "mobile", "image_128", "is_user", "state"]
      ]
    };
    try {
      var response = await odooRPC.callRPC(path, method, params);
      if (response != null) {
        response = response[0];
        User user = User(odooSession.userLogin, odooSession.userName, secret);
        if (response["vat"] is bool) {
          response["vat"] = '';
        }
        if (response["street"] is bool) {
          response["street"] = '';
        }
        if (response["mobile"] is bool) {
          response["mobile"] = '';
        }
        if (response["image_128"] is bool) {
          response["image_128"] = '';
        }
        if (response["city"] is bool) {
          response["city"] = '';
        }

        user.cedula = response["vat"];
        user.direccion = response["street"];
        user.ciudad = response["city"];
        user.phone = response["mobile"];
        user.image_1920 = response["image_128"];
        user.isUser = response["is_user"];
        user.documentVerified = response["state"];
        return user;
      }
    } on OdooException catch (_) {
      print(_);
      rethrow;
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> updateUser(User user) {
    var model = 'res.partner';
    var method = 'write';
    var args = [
      _prefs.idUserPartner,
      {
        "vat": user.cedula,
        "name": user.name,
        "street": user.direccion,
        "city": 'Ambato', //user.ciudad,
        "mobile": user.phone,
        "image_128": user.image_1920
      }
    ];
    try {
      var response = odooRPC.callKW(model, method, args, [], [], '');
      return response;
    } on OdooException catch (_) {
      print(_);
      rethrow;
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<void> signOut() async {
    dynamic response = await odooRPC.destroySession().then((value) => {});
    print(response);
  }

  Future<dynamic> signUp(User user) async {
    String result;
    final params = {
      "login": user.login,
      "name": user.name,
      "password": user.password,
      "vat": user.cedula,
    };
    print('Signup params: $params');
    var path = '/web/bike_municipal/signup';
    var funcName = 'web_bike_signup';
    //odooRPC.callKW(model, method, ids, fields)
    try {
      var response = await odooRPC.callRPC(path, funcName, params);
      String message = response["message"];
      print(message);
      if (response["message"] == 'Your account was created successfully' ||
          message.contains("Tu cuenta ha sido creada exitosamente")) {
        return "ok";
      } else if (response["message"] ==
              "Another user is already registered using this email address." ||
          message.contains(
              "Otro usuario ya está registrado con esta dirección de correo electrónico")) {
        return "is already";
      } else if (response["message"] ==
              "Another user is already registered with this ID number." ||
          message.contains(
              "Otro usuario ya está registrado con este número de identificación.")) {
        return "is already id";
      } else {
        return "wrong";
      }
    } on OdooException {
      rethrow;
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> changePassword(
      String password, String newpasswordPhone) async {
    bool isSuccess = false;
    var model = 'res.users';
    var method = 'change_password';
    var args = [
      password,
      newpasswordPhone,
    ];
    final domain = [];
    final fields = [];
    try {
      var response =
          await odooRPC.callKW(model, method, args, domain, fields, '');
      if (response) {
        isSuccess = response;
      }
      return isSuccess;
      //////print(r.getErrorMessage());
      // if (response) {
      //   return null;
      // } else {
      //   return response;
      // }
    } on OdooException {
      rethrow;
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<MessageRequestOdoo> sendEmailUserResetPassword(String username) async {
    MessageRequestOdoo message = MessageRequestOdoo(false, "", "");
    var path = '/web/bike_municipal/reset_password';
    var funcName = 'web_bike_reset_password';
    var params = {"login": username};
    final result = await odooRPC.callRPC(path, funcName, params);
    //var result = response.getResult();
    if (result != null && result["code"] == 200) {
      message = MessageRequestOdoo(true, result["message"], "");
      print(message);
    } else {
      message = MessageRequestOdoo(false, result["message"], "");
    }
    return message;
  }

//   Future<MessageRequestOdoo> verificateCodeUserValidate(
//       String code, String partnerID) async {
//     MessageRequestOdoo message = MessageRequestOdoo(false, "", "");
//     var path = '/web/session/account/validate/sms/verificate';
//     var funcName = 'searchUserVerificateSMS';
//     var params = {"code": code, "partnerID": partnerID, "context": {}};

//     final result = await odooRPC.callRPC(path, funcName, params);
//     //var result = response.getResult();
//     if (result != null) {
//       message = MessageRequestOdoo(result["success"], result["message"], "");
//     }
//     return message;
//   }

//   Future<MessageRequestOdoo> getSMSCode(String partnerID) async {
//     MessageRequestOdoo message = MessageRequestOdoo(false, "", "");
//     var path = '/web/session/account/validate/sms/twilio';
//     var funcName = 'searchUserSMS';
//     var params = {"partnerID": partnerID, "context": {}};

//     final result = await odooRPC.callRPC(path, funcName, params);
//     //var result = response.getResult();
//     if (result != null) {
//       message = MessageRequestOdoo(result["success"], result["message"], "");
//     }

//     return message;
//   }

//   Future<List<Travels>> searchReserveUser(int userReservations) async {
//     List<Travels> travels = [];
//     var path = '/web/session/sarch/reservations/vehicle/user';
//     var funcName = 'searchUserVehicular';
//     var params = {"user_reservations": userReservations, "context": {}};

//     var result = await odooRPC.callRPC(path, funcName, params);
//     //var result = response.getResult();

//     if (result != null) {
//       if (result["success"]) {
//         List res = result["message"];
//         for (var i in res) {
//           travels.add(Travels(
//               i['stations_start'].toString(),
//               i['stations_end'].toString(),
//               i['state'].toString(),
//               i['vehicle'].toString(),
//               i['name'].toString(),
//               i["date1"].toString(),
//               i["vType"].toString(),
//               "",
//               i["time"].toString()));
//         }
//       }
//     }
//     return travels;
//   }

//   Future<dynamic> searchApis() async {
//     var path = '/web/session/wego/apis';
//     var funcName = 'wegoApiReturn';
//     var params = {"context": {}};

//     var result = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();
//     if (result != null) {
//       if (result["success"]) {
//         return result["message"];
//       } else {
//         return [];
//       }
//     }
//     return [];
//   }

  Future<bool> generateNewSessionOdoo() async {
    bool isSessionExpired = await odooRPC.checkSessionExpired();
    if (isSessionExpired) {
      print('session expired--');
      final savedDate = DateTime.parse(_prefs.lastLogin!);
      final now = DateTime.now();
      final difference = now.difference(savedDate);
      if (difference.inHours >= 24 || !_prefs.accountValidate) {
        _prefs.requireAuthentication = true;
        _prefs.latitud = '0.0';
        _prefs.longitud = '0.0';
        _prefs.isDarkThemeEnabled = false;
        return false;
      } else {
        try {
          OdooSession response =
              await odooRPC.authenticate("odoo", _prefs.email, _prefs.secret!);
          print(odooRPC.client.sessionId);
          print('--------');
          String session = response.id;
          _prefs.sessionId = session;
          _prefs.idUserPartner = response.partnerId;
          _prefs.idUser = response.userId;

          print('auth again');
          return false;
        } catch (e) {
          return true;
        }
      }
    } else {
      print('session ok');
      return false;
    }
  }

  List<String> splitFleetVehicleName(String fleetVehicle) {
    var namesVehile = fleetVehicle.split('/');
    return namesVehile;
  }

  Future<dynamic> getGeoStationsLine(List<int?> idstations) async {
    List<dynamic> domain = ['station_id', 'in', idstations];
    try {
      var result = await odooRPC.callKW(
          'bike_municipal.station.line', //'bike.municipal.station',
          'search_read',
          [],
          [domain], //[stations_lines],
          ['station_id', 'fleet_vehicle_id', 'is_free'],
          'is_free asc');

      if (result != null) {
        //if(stations_lines.length == 1){
        List<StationLine> stationsLineList = [];
        for (var stationLine in result) {
          var fleetVehicle = stationLine['fleet_vehicle_id'];
          var idStationLine = stationLine['id'];
          var station = stationLine['station_id'];
          //var vehicleData = splitFleetVehicleName(fleetVehicle[1]);
          var vehicleData = fleetVehicle[1];
          Vehicle vehicle = Vehicle(id: fleetVehicle[0]);
          //vehicle.model = vehicleData[0];
          //vehicle.registrationVehicle = vehicleData[0];
          vehicle.model = vehicleData;
          vehicle.registrationVehicle = vehicleData;
          stationsLineList.add(StationLine(
              id: idStationLine,
              vehicle: vehicle,
              isFree: stationLine['is_free'],
              idStation: station[0]));
        }
        //}
        return stationsLineList;
      }
    } on OdooException {
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    }
  }

  Future<dynamic> getGeoStationLine(int idstation) async {
    List<String> vehicleData = [];
    try {
      var result = await odooRPC.callKW(
          'bike_municipal.station.line', //'bike.municipal.station',
          'search_read',
          [],
          [
            'id',
            '=',
            [idstation]
          ], //[stations_lines],
          ['station_id', 'fleet_vehicle_id', 'is_free'],
          '');

      if (result != null) {
        vehicleData = splitFleetVehicleName(result['fleet_vehicle_id']);
        StationLine(
            id: result['id'],
            vehicle: result['fleet_vehicle_id'],
            isFree: result['is_free'],
            idStation: result['station_id']);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getGeoStations() async {
    print('bike_municipal.station');
    var result;
    var resultLine;
    String strIds = '';
    List<dynamic> stationsLines = ["station_id", "in"];
    List<GeoStation> geoStationsList = [];

    try {
      await odooRPC
          .callKW(
              'bike_municipal.station', //'bike.municipal.station',
              'search_read',
              [],
              [],
              ['id', 'name', 'latitude', 'longitude', 'station_line_ids'],
              '')
          .then((value) async {
        List<dynamic> ids = [];

        for (var station in value) {
          List<dynamic> line_ids = station['station_line_ids'];
          final int id = station['id'];
          final String name = station['name'];
          const String city = 'Ambato';
          final double latitude = station['latitude'];
          final longitude = station['longitude'];
          final GeoStation geoStation =
              GeoStation(id, name, city, latitude, longitude);
          geoStationsList.add(geoStation);
          if (!line_ids.isEmpty) {
            for (var line_id in line_ids) {
              final int id = line_id;
              ids.add(id);
            }
          }
          //strIds = '$strIds$id,';
        }
        //strIds = strIds.substring(0, strIds.length - 1);
        stationsLines.add(ids);
        //await getGeoStationsLine(stationsLines).then((value){

        //});
      });

      if (geoStationsList != null) {
        print(stationsLines);
        return geoStationsList;
      }
    } on OdooException {
      //print(odooException);
      rethrow;
    } on SocketException {
      //print(socketException);
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> generateReserve(StationLine stationLine) async {
    try {
      var response = await odooRPC.callKW(
          'bike_municipal.bike.rental',
          'create',
          [
            {
              "fleet_vehicle_id": stationLine.vehicle.id,
              "starting_station_id": stationLine.idStation
            }
          ],
          [],
          [],
          '');
      return response;
    } on OdooException {
      rethrow;
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> stopReserve(
      GeoStation arrivaGeoStation, int idReserve) async {
    try {
      var response = await odooRPC.callKW(
          'bike_municipal.bike.rental',
          'write',
          [
            idReserve,
            {"arrival_station_id": arrivaGeoStation.id}
          ],
          [],
          [],
          '');
      return response;
    } on OdooException {
      rethrow;
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> searchReserve() async {
    dynamic reserve;
    List<Travel> travels = [];
    List<dynamic> domain = [
      'state',
      'in',
      ['active']
    ];
    //Reserve
    Travel travel = Travel(
        id: -1,
        name: '',
        state: '',
        vehicle: Vehicle(id: -1),
        startStation: GeoStation(-1, 'name', 'city', 0.0,
            0.0)); //= Travel(id: id, name: name, state: state, vehicle: vehicle, startStation: startStation)
    try {
      await odooRPC
          .callKW(
              'bike_municipal.bike.rental',
              'search_read',
              [],
              [domain],
              [
                'id',
                'name',
                'partner_id',
                'fleet_vehicle_id',
                'datetime',
                'starting_station_id',
                'arrival_station_id',
                'state'
              ],
              '')
          .then((value) {
        if (value.isNotEmpty) {
          List.generate(value.length, (index) {
            //print(value[index]);
            reserve = value[index];
            List<dynamic> vehicleData = reserve['fleet_vehicle_id'];
            List<dynamic> stationFromData = reserve['starting_station_id'];
            List<dynamic> stationToData = [];
            Vehicle vehicle = Vehicle(id: vehicleData[0]);
            String dateTimeData = reserve['datetime'];
            var dateTime = dateTimeData.split(' ');
            GeoStation geoStationFrom =
                GeoStation(stationFromData[0], stationFromData[1], '', 0, 0);
            if (reserve['arrival_station_id'] is List<dynamic>) {
              stationToData = reserve['arrival_station_id'];
            } else {
              stationToData = [0, ''];
            }
            GeoStation geoStationTo =
                GeoStation(stationToData[0], stationToData[1], '', 0, 0);
            vehicle.registrationVehicle = vehicleData[1];

            travel = Travel(
                id: reserve['id'],
                name: reserve['name'],
                state: reserve['state'],
                vehicle: vehicle,
                startStation: geoStationFrom,
                arrivalStation: geoStationTo,
                date: dateTime[0],
                time: dateTime[1]);

            travels.add(travel);
          });
        }
      });
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
    return travels;
  }

  Future<dynamic> sendCommandTraccar(int vehicleId) async {
    //5260
    String model = 'fleet.vehicle';
    String method = 'send_traccar_command';
    var args = [vehicleId, "UNLOCK=L0,0,1234"];
    var domain = [];
    var fields = [];
    try {
      var response =
          await odooRPC.callKW(model, method, args, domain, fields, '');
      return response;
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  /// Solicita al candado el estado (incluida la batería) con el comando S5
  Future<double> readBattery(int vehicleId) async {
    const model = 'fleet.vehicle';
    const method = 'send_traccar_command';
    final args = [vehicleId, 'GPS=S51'];
    final domain = <dynamic>[];
    final fields = <dynamic>[];
    try {
      final response =
          await odooRPC.callKW(model, method, args, domain, fields, '');
      final data = response['data'] as List<dynamic>;
      final rawVoltage = data[1] as int;
      return rawVoltage / 100.0;
    } on OdooException {
      rethrow;
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Travel>?> getTravels() async {
    List<Travel> travels = [];
    try {
      await odooRPC
          .callKW(
              'bike_municipal.bike.rental',
              'search_read',
              [],
              [],
              [
                'id',
                'name',
                'partner_id',
                'fleet_vehicle_id',
                'datetime',
                'starting_station_id',
                'arrival_station_id',
                'state'
              ],
              '')
          .then((value) {
        if (value != null) {
          for (var travel in value) {
            List<dynamic> vehicleData = travel['fleet_vehicle_id'];
            List<dynamic> stationFromData = travel['starting_station_id'];
            List<dynamic> stationToData = [];
            Vehicle vehicle = Vehicle(id: vehicleData[0]);
            String dateTimeData = travel['datetime'];
            var dateTime = dateTimeData.split(' ');
            GeoStation geoStationFrom =
                GeoStation(stationFromData[0], stationFromData[1], '', 0, 0);
            if (travel['arrival_station_id'] is List<dynamic>) {
              stationToData = travel['arrival_station_id'];
            } else {
              stationToData = [0, ''];
            }
            GeoStation geoStationTo =
                GeoStation(stationToData[0], stationToData[1], '', 0, 0);
            vehicle.registrationVehicle = vehicleData[1];

            travels.add(Travel(
                    id: travel['id'],
                    name: travel['name'],
                    state: travel['state'],
                    vehicle: vehicle,
                    startStation: geoStationFrom,
                    arrivalStation: geoStationTo,
                    date: dateTime[0],
                    time: dateTime[1])
                // Travel(, , ,
                //   vehicle, geoStationFrom, geoStationTo, 'date', '')
                );
          }
        }
      });
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
    print('authprovider travels');
    return travels;
  }

  Future<List<String>> getTerms() async {
    List<String> response = [];
    String term;
    try {
      await odooRPC
          .callKW(
              'bike_municipal.terms_conditions',
              'search_read',
              [],
              [],
              [
                'id',
                'description',
              ],
              '')
          .then((value) {
        for (var element in value) {
          term = element["description"];
          response.add(term);
        }
      });
      return response;
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> getFrequentQuestions() async {
    List<FrequentQuestion> questions = [];
    try {
      await odooRPC
          .callKW(
              'bike_municipal.frequent_questions',
              'search_read',
              [],
              [],
              [
                'id',
                'question',
                'answer',
              ],
              '')
          .then((value) {
        if (value != null) {
          for (var question in value) {
            questions.add(FrequentQuestion(
                question['question'], question['answer'], '', true));
          }
        }
      });
      return questions;
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> sendImagesValidation(
      List<XFile> imgs, int userPartner) async {
    var response = null;
    List<dynamic> data = [];
    for (var i = 0; i < imgs.length; i++) {
      Uint8List imageBytes = await imgs[i].readAsBytes(); // Leer bytes
      String base64Image = base64Encode(imageBytes);
      data.add({
        "name": imgs[i].name,
        "type": "binary",
        "datas": base64Image.toString(),
        "res_model": "res.partner",
        "res_id": userPartner,
        "mimetype": "image/jpeg"
      });
    }
    try {
      response =
          await odooRPC.callKW('ir.attachment', 'create', [data], [], [], '');
      return response;
    } on OdooException catch (odooException) {
      print(odooException);
      rethrow;
    } on SocketException catch (socketException) {
      print(socketException);
      rethrow;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> checkSessionExpired() async {
    return await odooRPC.checkSessionExpired(); // ya lo usas
  }

//reporte mayo despachos realizado
//   Future<StopsAVehicle?> getStationAndVehicle(
//       String city, Function setState) async {
//     try {
//       List<StopsMarket> listStopsMarket = [];
//       List<VehicleMarket> listVehicleMarket = [];
//       List<MarkerOdoo> markersStops = [];
//       List<MarkerOdoo> markersVehicleB = [];
//       List<Marker> listGeneral = [];
//       List<Marker> listGeneralMarketAux = [];

//       StopsAVehicle stopsAVehicle = StopsAVehicle(
//           listStopsMarket, markersStops, listGeneral, listGeneralMarketAux);

//       GeneralSizeCicleAvatar generalSize = GeneralSizeCicleAvatar(
//           ScreenUtil().setHeight(3),
//           ScreenUtil().setSp(
//             4,
//           ),
//           ScreenUtil().setWidth(20),
//           ScreenUtil().setWidth(20));

//       var path = '/web/session/search/stations/reservations';
//       var funcName = 'wegoMessageByApp';
//       var params = {'city_name': city, "context": {}};

//       var result = await odooRPC.callRPC(path, funcName, params);
//       //var result = response.getResult();
//       if (result != null) {
//         if (result["success"]) {
//           var stops = result["message"];

//           for (var i in stops) {
//             print(i["name"]);
//             print(i["latitude_reserve"]);
//             print(i["longitude_reserve"]);
//             var vehicles = i["listv"];

//             listVehicleMarket = [];
//             markersVehicleB = [];
//             for (var v in vehicles) {
//               listVehicleMarket.add(VehicleMarket(v["name"].toString(),
//                                                   v["latitude"].toString(),
//                                                   v["longitude"].toString()));
//               markersVehicleB.add(MarkerOdoo(
//                   markerInfo(
//                       LatLng(v["latitude"], v["longitude"]),
//                       imageBiciConst,
//                       false,
//                       generalSize,
//                       v["name"].toString(),
//                       setState),
//                   circleAvatarNormal(imageBiciConst),
//                   "vehicle",
//                   []));

//               listGeneralMarketAux
//                   .add(markersVehicleB[markersVehicleB.length - 1].marker);
//               listGeneral.add(markersVehicleB[markersVehicleB.length-1].marker);
//             }

//             listStopsMarket.add(StopsMarket(
//                 i["id"].toString(),
//                 i["name"].toString(),
//                 i["parish_name"].toString(),
//                 i["latitude_reserve"].toString(),
//                 i["longitude_reserve"].toString(),
//                 listVehicleMarket));

//             markersStops.add(MarkerOdoo(
//                markerInfo(
//                     LatLng(i["latitude_reserve"], i["longitude_reserve"]),
//                     imageStationConst,
//                     false,
//                     generalSize,
//                     i["name"].toString(),
//                     setState),
//                 circleAvatarNormal(imageStationConst),
//                 "stop",
//                 markersVehicleB));

//             //listGeneralMarketAux.add(markersStops[markersStops.length-1].marker);
//             listGeneral.add(markersStops[markersStops.length - 1].marker);
//           }

//           stopsAVehicle = StopsAVehicle(
//               listStopsMarket, markersStops, listGeneral, listGeneralMarketAux);
//           return stopsAVehicle;
//         }
//       }

//       return stopsAVehicle;
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }

//   Future<ReserveOnWay?> searchState(int userReservations) async {
//     ReserveOnWay reserveOnWay = ReserveOnWay("", "", "");

//     var path = '/web/session/sarch/reservations/vehicle/user/onway';
//     var funcName = 'searchUserOnWayVehicular';
//     var params = {"user_reservations": userReservations, "context": {}};

//     var result = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();
//     if (result != null) {
//       if (result["success"]) {
//         List resultado = result["message"];
//         if (resultado.isNotEmpty) {
//           reserveOnWay = ReserveOnWay(resultado[0]["id"].toString(),
//               resultado[0]["date1"].toString(), resultado[0]["v"].toString());
//           return reserveOnWay;
//         }
//       } else {
//         return null;
//       }
//     }
//     return null;
//   }

//   Future<dynamic> updateReserveMB(idReservations, stateValue, amountC, time,
//       latitudeE, longitudeE, stationsE) async {
//     var path = '/web/session/update/reservations/vehicle/user/mb';
//     var funcName = 'updateVehicleUserMB';
//     var params = {
//       "idReservations": idReservations,
//       "stateValue": stateValue,
//       "amount_cost": amountC,
//       "time": time,
//       "latitude_end": latitudeE,
//       "longitude_end": longitudeE,
//       "stations_end": stationsE,
//       "context": {}
//     };
//     var result = await odooRPC.callRPC(path, funcName, params);
//     //var result = r.getResult();
//     if (result != null) {
//       if (result["success"]) {
//         return result["message"];
//       } else {
//         return null;
//       }
//     }
//     return null;
//   }

//   Future<dynamic> generateReserveMB(
//       String vehicle, userR, idStations, lat, lng) async {
//     DateTime fecha1 = await NTP.now();
//     fecha1 = fecha1.add((const Duration(hours: 5)));

//     String datePass =
//         formatDate(fecha1, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);

//     var path = '/web/session/create/reservations/vehicle/user/stations/start/mb';
//     var funcName = '';
//     var params = {
//       "vehicle": vehicle,
//       "stations_start": idStations,
//       "user_reservations": userR,
//       "date_reservations": datePass,
//       "lat": lat,
//       "lng": lng,
//       "context": {}
//     };

//     var result = await odooRPC.callRPC(path, funcName, params);
//     //var result = r.getResult();
//     if (result != null) {
//       if (result["success"]) {
//         return result["message"];
//       } else {
//         return null;
//       }
//     }
//     return null;
//   }

//   Future<MessageRequestOdoo> searchAdsearchPoliciesConditions() async {
//     MessageRequestOdoo messageRequest = MessageRequestOdoo(false, "", "");
//     var path = '/web/session/wego/errand/policies/condition';
//     var funcName = 'serachWegoPoliciesConditions';
//     var params = {"context": {}};

//     var result = await odooRPC.callRPC(path, funcName, params);
//     //var result = r.getResult();
//     if (result != null) {
//       if (result["success"]) {
//         var resultadoTermsConditions = result["message"];
//         messageRequest = MessageRequestOdoo(
//             result["success"],
//             resultadoTermsConditions["terms_conditions"],
//             resultadoTermsConditions["use_policies"]);
//       }
//     }

//     return messageRequest;
//   }

//    Future<MessageRequestOdoo> searhcHelpMessageApi() async {
//     MessageRequestOdoo messageRequest = MessageRequestOdoo(false, "", "");
//     var path = '/web/session/wego/get/help/message';
//     var funcName = 'wegoMessageByApp';
//     var params = {"typeApp": "wego", "context": {}};

//     dynamic r = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();
//     if (r != null) {
//       if (r["success"]) {
//         List res = r["message"];
//         if (res.isNotEmpty) {
//           messageRequest = MessageRequestOdoo(
//               r["success"], res[0]["number_help"], res[0]["message_help"]);
//         }
//       }
//     }

//     return messageRequest;
//   }

// Future<List<FrequentQuestions>> getFrequentMessage() async {
//     List<FrequentQuestions> frequentquestion = [];
//     var path = '/web/session/wego/get/frequentquestion';
//     var funcName = 'frequestionByApp';
//     var params = {"typeApp": "wegoo_client", "context": {}};

//     var r = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();

//     if (r != null) {
//       if (r["success"]) {
//         List res = r["message"];
//         for (var i in res) {
//           frequentquestion.add(FrequentQuestions(
//               i["name"], i["description"], i["typeApp"], i["isExpanded"]));
//         }
//       }
//     }

//     return frequentquestion;
//   }

// Future<dynamic> updateCedulaApi(int idS, String identifier, String typeIdentifier) async {
//     var path = '/web/session/wego/update/identifier';
//     var funcName = 'updateIdentifier';

//     var params = {
//       "idS": idS,
//       "identifier": identifier,
//       "type_identifier": typeIdentifier,
//       "context": {}
//     };

//     var r = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();
//     if (r != null) {
//       return r["success"]; // true or false
//     }

//     return false;
//   }

// Future<dynamic> tokenUserCreateUpdateApi(
//       String deviceId, int partnerId, String token) async {
//     var path = '/web/session/wego/save/token/user';
//     var funcName = 'saveTokenWego';

//     String description = "{'fcmToken': '$token', 'fcmDeviceId':'$deviceId'}";
//     var params = {
//       "token": token,
//       "device_id": deviceId,
//       "partner_id": partnerId,
//       "description": description,
//       "context": {}
//     };

//     var result = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();
//     if (result != null) {
//       return result["success"]; // true or false
//     }

//     return false;
//   }

//   Future<bool> createPasswordOdoo(String p, int userID) async {
//     var path = '/web/session/create/pwd/user';
//     var funcName = '';
//     var params = {
//       "p": p, //'old_pwd', 'new_password','confirm_pwd'
//       "userID": userID,
//       "context": {}
//     };

//     var result = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();

//     if (result["success"]) {
//       return result["success"];
//     }

//     return false;
//   }

//  Future<dynamic> changePasswordOdoo(String oldpasswordPhone,
//       String newpasswordPhone, String confirmpasswordPhone, int userID) async {
//     var path = '/web/session/change_password_phone';
//     var funcName ='';
//     var params = {
//       "old_passwordPhone":
//           oldpasswordPhone, //'old_pwd', 'new_password','confirm_pwd'
//       "new_passwordPhone": newpasswordPhone,
//       "confirm_passwordPhone": confirmpasswordPhone,
//       "userId": userID,
//       "context": {}
//     };

//     var r = await odooRPC.callRPC(path, funcName, params);

//     return r.getResult();
//   }

// Future<bool> changePasswordUser(int userID) async {
//     var path = '/web/session/update/user/info/temporalPwd';
//     var funcName = '';
//     var params = {"userID": userID, "context": {}};

//     var resFavoritesProduct = await odooRPC.callRPC(path, funcName, params);
//     // return r.getResult();
//     //var resFavoritesProduct = r.getResult();

//     if (resFavoritesProduct != null) {
//       return resFavoritesProduct["success"];
//     }
//     return false; // api ya caducada
//   }

// Future<dynamic> updateInfoUserApi(
//       int id, String name, String city, String image, String telefono) async {
//     var path = '/web/session/wego/update/user/info/userPart';
//     var funcName = 'updateInfoUser';
//     var params = {
//       "partnerID": id,
//       "name": name,
//       "city": city,
//       "image": image,
//       "telefono": telefono,
//       "context": {}
//     };
//     var result = await odooRPC.callRPC(path, funcName, params);
//     ////var result = r.getResult();
//     if (result != null) {
//       PaintingBinding.instance.imageCache.clear();
//       return result["success"]; // true or false
//     }
//     return false;
//   }

// Future<PriceServices?> searchErrandConfig(
//       String typeVehicle, String type, String city) async {
//     var path = 'web/session/wego/search/errand/config';
//     var funcName = '';
//     var params = {
//       "typevehicle": typeVehicle,
//       "type": type,
//       "city": city,
//       "context": {}
//     };

//     var r = await odooRPC.callRPC(path, funcName, params);
//     var result = r.getResult();
//     if (result != null) {
//       if (result["success"]) {
//         var res = result["message"];
//         PriceServices priceServices = PriceServices(
//             res["name"],
//             res["type"],
//             res["cost_time"],
//             res["cost_kilometer"],
//             res["fare"],
//             res["base_fare"],
//             res["cost_weight"]);
//         return priceServices;
//       } else {
//         return null;
//       }
//     }
//     return null;
//   }

//
}
