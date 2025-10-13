// import 'dart:async';
// import 'dart:convert';
// import 'package:meta/meta.dart';

// import 'package:http/http.dart' as http;
// import 'package:bike_municipio/data/models/traccar/queries.dart';
// import 'package:web_socket_channel/io.dart';
// import '../../../utils/sharedprefs_helper.dart';
// import 'device.dart';

// class Traccar {
//   /*Traccar({@required this.serverURL, this.verbose = false})
//       : assert(serverURL != null);*/

//   final http.Client _client = http.Client();
//   String? serverURL = "http://190.63.136.148:8082";
//   bool? verbose;
//   Map<String, String> _headers = {};
//   final _devicesMap = <int, Device>{};
//   final _readyCompleter = Completer<Null>();
//   late StreamSubscription<dynamic> _rawPosSub;
//   final _positions = StreamController<Device>.broadcast();
//   int keepAlive = 1;
//   final _prefs = Prefs();

//   /// The queries available
//   TraccarQueries? query;
//   String? _cookie;

//   devices() async {
//     if (verbose!) {
//       //////print("Initializing Traccar cli");
//     }
//     await _getCookie();
//     query =
//         TraccarQueries(cookie: _cookie, serverUrl: serverURL, verbose: verbose);
//     if (verbose!) {
//       //////print("Traccar client initialized");
//     }
//     var res = await query?.devices();
//     return res;
//     //_readyCompleter.complete();
//   }

//   String createPath(String path) {
//     return serverURL! + path;
//   }

//   String authorised(String email, String pass) {
//     String credentials = "$email:$pass";
//     Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
//     String encoded = stringToBase64Url.encode(credentials);
//     return encoded;
//   }

//   //Obtener session
//   /*
//   Future<http.Response> getSession(String url) async {
//     http.Response res;
//     var urll = serverURL! + url;
//     //var user = {'email': _prefs.email, "password": _prefs.traccarPwd};
//     //var user = {'email': "admin", "password": "admin"};
//     var user = {'email': "admin", "password": "Y3eRzwTy5FJDmzj9j594"};
//     _headers["Content-type"] = "application/x-www-form-urlencoded";
//     try {
//       final response = await _client.post(Uri.parse(url), body: user);
//       return response;
//     } catch (e) {}
//   }
// */
//   //Post Values
//   Future<http.Response> callRequest(
//       String url, Map payload, String auth) async {
//     var body = json.encode(payload);
//     _headers["Content-type"] = "application/json; charset=UTF-8";
//     _headers["Authorization"] = auth;
//     final response =
//         await _client.post(Uri.parse(url), body: body, headers: _headers);
//     return response;
//   }

//   //Get values
//   Future<http.Response> callDevices(String url, Map params, String auth) async {
//     _headers["Content-type"] = "application/json; charset=UTF-8";
//     _headers["Authorization"] = auth;
//     final response = await _client.get(Uri.parse(url), headers: _headers);
//     return response;
//   }

//   // Call json controller
//   Future<http.Response> callController(
//       String path, Map params, String auth) async {
//     return await callRequest(createPath(path), params, auth);
//   }

//   // Call json controller
//   Future<http.Response> callGetController(
//       String path, Map params, String auth) async {
//     return await callDevices(createPath(path), params, auth);
//   }

//   /// Get the device positions
//   Future<Stream<Device>> positions() async {
//     if (verbose!) {
//       //////print("Setting up positions stream");
//     }
//     final posStream = await _positionsStream(serverUrl: serverURL);
//     if (verbose!) {
//       //////print("Subscribing to positions stream");
//     }
//     _rawPosSub = posStream.listen((dynamic data) {
//       ////////print("DATOS POSICIONES DEVICES $data");
//       final dataMap = jsonDecode(data.toString()) as Map<String, dynamic>;
//       if (dataMap.containsKey("positions")) {
//         if (verbose!) {
//           ////////print("Device positions update:");
//         }
//         DevicePosition pos;
//         for (final posMap in dataMap["positions"]) {
//           ////////print("POS MAP $posMap");
//           pos = DevicePosition.fromJson(posMap as Map<String, dynamic>);
//           final id = posMap["deviceId"] as int;
//           Device? device;
//           if (_devicesMap.containsKey(id)) {
//             device = _devicesMap[id];
//           } else {
//             device = Device.fromPosition(posMap as Map<String, dynamic>,
//                 keepAlive: keepAlive);
//           }
//           device!.position = pos;
//           _devicesMap[id] = device;
//           _positions.sink.add(device);
//           if (verbose!) {
//             //////print(" - $pos");
//           }
//         }
//       }
//     });
//     return _positions.stream;
//   }

//   Future<void> _getCookie({String protocol = "http"}) async {
//     const addr = "/api/session";
//     if (verbose!) {
//       //////print("Getting cookie at $addr");
//     }
//     //final response = await _dio.get<dynamic>(addr);
//     try {
//       //final response = await getSession(addr);
//       //_cookie = response.headers["set-cookie"].toString();
//     } catch (e) {
//       _cookie = "";
//     }

//     if (verbose!) {
//       //////print("Cookie set: $_cookie");
//     }
//   }

//   Future<Stream<dynamic>> _positionsStream(
//       {String? serverUrl, String protocol = "http"}) async {
//     if (_cookie == null) {
//       await _getCookie();
//     }
//     String? serverUrlN =
//         serverUrl!.replaceAll("https://", "").replaceAll("http://", "");
//     final channel = IOWebSocketChannel.connect("ws://$serverUrlN/api/socket",
//         //"ws://190.63.136.148:8082/api/socket",
//         //"ws://159.65.43.181:8082/api/socket",
//         headers: <String, dynamic>{"Cookie": _cookie});
//     return channel.stream;
//   }

//   Future<http.Response> positionsSink({@required var datos}) async {
//     if (_cookie == null) {
//       await _getCookie();
//     }
//     var body = json.encode(datos);
//     var urll = "http://190.63.136.148:5055"; //"http://159.65.43.181:5055";
//     final response = await _client.post(Uri.parse(urll), body: body);
//     return response;
//   }

//   /// Dispose if using the positions stream
//   void dispose() {
//     _rawPosSub.cancel();
//     _positions.close();
//   }
// }
