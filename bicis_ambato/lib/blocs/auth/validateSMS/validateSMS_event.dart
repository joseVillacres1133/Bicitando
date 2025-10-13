// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:bike_municipio/data/models/user.dart';

// //Eventos o acciones que va a realizar el ResetPasswordForm
// @immutable
// abstract class ValidateSMSEvent extends Equatable {
//   ValidateSMSEvent([List props = const []]) : super(); //super(props);
// }

// class NumberChange extends ValidateSMSEvent {
//   final String? code;

//   NumberChange({@required this.code}) : super([code]);

//   @override
//   String toString() => 'NumberChange { code :$code }';

//   @override
//   List<Object?> get props => ['NumberChange { code :$code }'];
// }

// class ValidateSMSPressed extends ValidateSMSEvent {
//   final String? code;

//   final String? partnerID;

//   ValidateSMSPressed({@required this.code, @required this.partnerID})
//       : super([code, partnerID]);

//   @override
//   String toString() {
//     return 'ValidateSMSPressed { code: $code, partnerID: $partnerID }';
//   }

//   @override
//   List<Object?> get props =>
//       ['ValidateSMSPressed { code: $code, partnerID: $partnerID }'];
// }

// class ValidateSMSRequestPressed extends ValidateSMSEvent {
//   final String? partnerID;

//   ValidateSMSRequestPressed({@required this.partnerID}) : super([partnerID]);

//   @override
//   String toString() {
//     return 'ValidateSMSRequestPressed {partnerID: $partnerID }';
//   }

//   @override
//   List<Object?> get props =>
//       ['ValidateSMSRequestPressed {partnerID: $partnerID }'];
// }

// class Submitted extends ValidateSMSEvent {
//   final User? user;

//   Submitted(this.user) : super([user]);

//   @override
//   String toString() {
//     return 'Submitted { user: $user}';
//   }

//   @override
//   List<Object?> get props => ['Submitted { user: $user}'];
// }
