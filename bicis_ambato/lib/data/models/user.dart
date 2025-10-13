import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'user.g.dart';

// // //Definimos el modelo o los modelos a utilizar para registrar en la base de datos interna y externa

abstract class TableElement {
  //Definicion de estructura de tabla para BDD interna
  int? id;
  final String tableName;
  TableElement(this.id, this.tableName);
  void createTable(Database db);
  Map<String?, dynamic> toMap();
}

// // //Modelo definido para enviar en MODO ONLINE
@JsonSerializable()
class User {
  User(this.login, this.name, this.password,
      {this.cedula,
      this.direccion,
      this.phone,
      this.confirmPassword,
      this.image_1920,
      this.isUser,
      this.documentVerified
      });

  final String login;
  final String name;
  final String password;
  String? image_1920;
  String? cedula;
  String? direccion;
  String? ciudad;
  String? phone;
  bool? isUser;
  String? documentVerified;


  @JsonKey(name: 'confirm_password')
  final String? confirmPassword;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User { login: $login, name: $name, phone: $phone, password: $password, confirm_password: $confirmPassword}, cedula: $cedula }';
  }
}

// //Modelo definido para enviar en MODO OFFLINE
class UserOffline extends TableElement {
  static const String tABLENAME = "User";
  String login;
  String name;
  String? cedula;
  String? phone;
  String password;
  String confirmPassword;
  String? direccion;
//   String? foto;
//   int? idUserPartner;
//   String? saldoOffline;
//   String? is_salesman;

//   //String generoUser;
//   //String birthDate;
//   //int cntChildren;

  UserOffline(
      {required this.login,
      required this.name,
      required this.cedula,
      required this.password,
//       this.saldo,
      this.direccion,
      this.phone,
      required this.confirmPassword,
      id})
      : super(id, tABLENAME);

  factory UserOffline.fromMap(Map<String, dynamic> map) {
    return UserOffline(
        login: map["login"],
        name: map["name"],
        cedula: map["cedula"],
//         saldo: map["saldo"],
        direccion: map["direccion"],
        phone: map["phone"],
        password: map["password"],
        confirmPassword: map["confirm_password"],
//         //fingerprintCode: map["fingerprint_code"],
//         seriePhone: map["serie_phone"],
//         imeiPhone: map["imei_phone"],
//         foto: map["foto"],
//         idUserPartner: map["idUserPartner"],
//         saldoOffline: map["saldoOffline"].toString(),
//         //generoUser: map["generoUser"],
//         //birthDate: map["birthDate"],
        id: map["_id"]);
  }

  @override
  void createTable(Database db) {
    db.rawUpdate("CREATE TABLE $tABLENAME("
        "_id integer primary key autoincrement,"
//         "login varchar(50),"
        "name varchar(50),"
        "cedula varchar(10),"
//         "saldo double,"
//         //"direccion varchar(50),"
        "phone varchar(10),"
        "password varchar(30),"
        "confirm_password varchar(30),"
//         //"fingerprint_code varchar(30),"
//         "serie varchar(50),"
//         "imei varchar(50),"
//         "foto varchar(500),"
//         "idUserPartner int,"
//         //"generoUser varchar(30),"
//         //"birthDate varchar(50),"
//         //"cntChildren int "
        ")");
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
//       "login": login,
      "name": name,
      "cedula": this.cedula,
//       "saldo": saldo,
      "direccion": this.direccion,
      "phone": phone,
      "password": password,
      "confirm_password": confirmPassword,
//       //"fingerprint_code": this.fingerprintCode,
//       "serie": seriePhone,
//       "imei": imeiPhone,
//       "foto": foto,
//       "idUserPartner": idUserPartner,
//       "saldoOffline": saldoOffline,
//       "is_salesman": is_salesman,
//       //"generoUser": this.generoUser,
//       //"birthDate": this.birthDate,
//       //"cntChildren": this.cntChildren,
    };
    if (id != null) {
      map["_id"] = id;
    }
    return map;
  }
}

// //Modelo definido para enviar en MODO ONLINE
// @JsonSerializable()
// class QrOnline {
//   QrOnline(
//       this.idUser,
//       this.description,
//       this.fechaPasaje,
//       this.saldo,
//       this.qrKey,
//       // this.fechaCreacion,
//       this.valido,
//       this.nameUser);

//   final int idUser;
//   final String description;
//   final DateTime fechaPasaje;
//   final double saldo;
//   final String qrKey;
//   // final DateTime fechaCreacion;
//   final bool valido;
//   final String nameUser;

//   factory QrOnline.fromJson(Map<String, dynamic> json) => _$QrFromJson(json);
//   Map<String, dynamic> toJson() => _$QrToJson(this);

//   @override
//   String toString() {
//     return 'QrOnline { idUser: $idUser, description: $description, fechaPasaje: $fechaPasaje, saldo: $saldo, qrKey: $qrKey, valido: $valido, nameUser: $nameUser }';
//     // return 'QrOnline { idUser: $idUser, description: $description, fechaPasaje: $fechaPasaje, saldo: $saldo, qrKey: $qrKey, fechaCreacion: $fechaCreacion, valido: $valido, nameUser: $nameUser }';
//   }
// }

// //Modelo definido para enviar en MODO OFFLINE
// class QrOffline extends TableElement {
//   // ignore: prefer_const_declarations
//   static final String tABLENAME = "QrModel";
//   int? idUser;
//   String? description;
//   String? fechaPasaje;
//   double? saldo;
//   String? qrKey;
//   String? nameUser;

//   QrOffline(
//       {this.idUser,
//       this.description,
//       this.fechaPasaje,
//       this.saldo,
//       this.qrKey,
//       this.nameUser,
//       id})
//       : super(id, tABLENAME);

//   factory QrOffline.fromMap(Map<String, dynamic> map) {
//     return QrOffline(
//         idUser: map["idUser"],
//         description: map["description"],
//         fechaPasaje: map["fechaPasaje"],
//         saldo: map["saldo"],
//         qrKey: map["qrKey"],
//         nameUser: map["nameUser"],
//         id: map["_id"]);
//   }

//   @override
//   void createTable(Database db) {
//     db.rawUpdate("CREATE TABLE $tABLENAME("
//         "_id integer primary key autoincrement,"
//         "idUser int,"
//         "description varchar(50),"
//         "fechaPasaje text,"
//         "saldo double,"
//         "qrKey varchar(50),"
//         "nameUser varchar(30)"
//         ")");
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       "idUser": idUser,
//       "description": description,
//       "fechaPasaje": fechaPasaje,
//       "saldo": saldo,
//       "qrKey": qrKey,
//       "nameUser": nameUser
//     };
//     if (id != null) {
//       map["_id"] = id;
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return 'User { idUser: $idUser, description: $description, fechaPasaje: $fechaPasaje, saldo: $saldo, qrKey: $qrKey, nameUser: $nameUser}';
//   }
// }
