// // // GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// // // **************************************************************************
// // // JsonSerializableGenerator
// // // **************************************************************************

// // //Mapeado de datos para MODO ONLINE

User _$UserFromJson(Map<String, dynamic> json) {
   return User(
    json['login'] as String,
    json['name'] as String,
    json['cedula'] as String,
    //json['direccion'] as String,
    //json['phone'] as String,
   // json['password'] as String,
    //json['confirm_password'] as String
//     json['identifier'] as String,
//     json['city'] as String,
//     //json['imei_phone'] as String,
//     //json['serie_phone'] as String,
//     //json['tipoCel'] as String,
//     json['email_template'] as String,
//     //json['is_salesman'] as bool,
//     //json['is_delivery_boy'] as bool,
//     //json['is_errand_boy'] as bool,
//     json['type_identifier'] as String,
//     //json['birthDate'] as DateTime,
//     //json['cntChildren'] as int
   );
 }

 Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
       'login': instance.login,
       'name': instance.name,
//       'identifier': instance.cedula,
//       'city': instance.direccion,
      'phone': instance.phone,
       'password': instance.password,
//       //'imei_phone': instance.imei_phone,
//       //'serie_phone': instance.serie_phone,
//       //'tipoCel': instance.tipoCel.toString(),
//       'confirm_password': instance.confirmPassword,
//       'email_template': instance.email_template,
//       'is_salesman': instance.is_salesman,
//       'is_delivery_boy': instance.is_delivery_boy,
//       //'is_errand_boy': instance.is_errand_boy,
//       'type_identifier': instance.type_identifier,
//       //'birthDate': instance.birthDate.toString(),
//       //'cntChildren': instance.cntChildren
     };

// // QrOnline _$QrFromJson(Map<String, dynamic> json) {
// //   return QrOnline(
// //       json['idUser'] as int,
// //       json['description'] as String,
// //       json['fechaPasaje'] as DateTime,
// //       json['saldo'] as double,
// //       json['qrKey'] as String,
// //       // json['fechaCreacion'] as DateTime,
// //       json['valido'] as bool,
// //       json['nameUser'] as String);
// // }

// // Map<String, dynamic> _$QrToJson(QrOnline instance) => <String, dynamic>{
// //       'idUser': instance.idUser,
// //       'description': instance.description,
// //       'fechaPasaje': instance.fechaPasaje,
// //       'saldo': instance.saldo,
// //       'qrKey': instance.qrKey,
// //       // 'fechaCreacion': instance.fechaCreacion,
// //       'valido': instance.valido,
// //       'nameUser': instance.nameUser
// //     };
