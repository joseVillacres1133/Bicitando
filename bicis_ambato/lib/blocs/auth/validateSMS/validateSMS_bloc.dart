// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:meta/meta.dart';
// import 'package:bike_municipio/style/style.dart';
// import 'package:odoo_api_plus/odoo_api_plus.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
// import 'package:rxdart/rxdart.dart';
// //import 'package:rxdart/rxdart.dart';
// import '../../../data/models/odoo/MessageRequestOdoo.dart';
// import '../../../data/repository.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/constants_msg.dart';
// import '../../../utils/sharedprefs_helper.dart';
// import 'bloc.dart';

// class ValidateSMSBloc extends Bloc<ValidateSMSEvent, ValidateSMSState> {
//   final Repository _repository;
//   final BuildContext _context;

//   ValidateSMSBloc(
//       {required Repository repository, required BuildContext context})
//       : assert(repository != null),
//         _repository = repository,
//         _context = context,
//         super(ValidateSMSState.empty()) {
//     on<ValidateSMSPressed>((event, emit) {
//       emit(ValidateSMSState.loading());
//       _searchValidate(event.code!, event.partnerID!);
//     });
//     on<ValidateSMSRequestPressed>(
//       (event, emit) {
//         ValidateSMSState.loading();
//         _getSMSValidate(event.partnerID!);
//       },
//     );
//     on<NumberChange>(
//       (event, emit) {
//         emit(state.isCodeValidate as ValidateSMSState);
//         emit(state.update(isCodeValidate: event.code!.length == 4));
//       },
//     );
//   }

//   @override
//   ValidateSMSState get initialState => ValidateSMSState.empty();
//   BuildContext get context => _context!;

//   @override
//   Stream<ValidateSMSState>? transform(
//     Stream<ValidateSMSEvent> events,
//     Stream<ValidateSMSState> Function(ValidateSMSEvent event) next,
//   ) {
//     final observableStream = events; // as Observable<ValidateSMSEvent>;
//     final nonDebounceStream = observableStream.where((event) {
//       return (event is! ValidateSMSPressed);
//     });
//     final debounceStream = observableStream.where((event) {
//       return (event is ValidateSMSPressed);
//     }).debounceTime(Duration(milliseconds: 300));
//     return transform(nonDebounceStream.mergeWith([debounceStream]),
//         next); //super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
//   }

//   @override
//   Stream<ValidateSMSState> mapEventToState(
//     ValidateSMSEvent event,
//   ) async* {
//     if (event is ValidateSMSPressed) {
//       yield* _maGetValidateSMSlPressedToState(
//           code: event.code, partnerID: event.partnerID);
//     } else if (event is ValidateSMSRequestPressed) {
//       yield* _mapgetNewCodeSMS(partnerID: event.partnerID);
//     } else if (event is NumberChange) {
//       yield* _mapEmailChangedToState(event.code!);
//     }
//   }

//   Stream<ValidateSMSState> _maGetValidateSMSlPressedToState(
//       {String? code, String? partnerID}) async* {
//     yield ValidateSMSState.loading();
//     _searchValidate(code!, partnerID!);
//   }

//   Stream<ValidateSMSState> _mapgetNewCodeSMS({String? partnerID}) async* {
//     yield ValidateSMSState.loading();
//     _getSMSValidate(partnerID!);
//   }

//   Stream<ValidateSMSState> _mapEmailChangedToState(String code) async* {
//     yield state.update(isCodeValidate: code.length == 4);
//   }

//   noFunction() {}

//   late ProgressDialog progressDialog;
//   Prefs _prefs = Prefs();
//   List<String>? nameDataBase;
//   List<String>? nameTraccar;
//   List<String>? nameNameApp;
//   List<String>? nameURL;
//   String desreasonPass = "";
//   bool loginSucces = false;

//   Stream<ValidateSMSState> _resetSuccess() async* {
//     yield ValidateSMSState.success();
//   }

//   Stream<ValidateSMSState> _resetFailure() async* {
//     yield ValidateSMSState.failure(str_mail_no_send);
//   }

//   _searchValidate(String code, String partnerID) async {
//     //var isDeviceConnected = await DataConnectionChecker().hasConnection;
//     if (!_prefs.requireOffline) {
//       //|| isDeviceConnected) {
//       final _repository = Repository(odooClient: OdooClient(LOCAL_BASE_URL));

//       MessageRequestOdoo res =
//           await _repository.verificateCodeUser(code, partnerID);
//       if (res != null) {
//         if (res.status) {
//           _prefs.accountValidate = true;
//           _resetSuccess();
//           Navigator.pushReplacementNamed(context, 'home');
//         } else {
//           //////print("no validada 1");

//           _showAlertDialogEnvio(str_code_incorrect, img_equis, googlePlus);
//           ValidateSMSState.failure(account_no_valid);
//         }
//       } else {
//         _showAlertDialogEnvio(str_code_incorrect, img_equis, googlePlus);
//         ValidateSMSState.failure(account_no_valid);
//       }
//     }
//   }

//   void _showAlertDialogEnvio(String text, String icono, Color colors) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (buildcontext) {
//           return AlertDialog(
//             backgroundColor: colors, // secondary,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(7.0))),
//             contentPadding: EdgeInsets.only(top: 7.0),
//             content: Container(
//               height: 270,
//               width: 300,
//               decoration: BoxDecoration(
//                   color: colors,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.circular(12))),
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.only(top: 3),
//                     height: 130,
//                     width: 200,
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Image.asset(icono),
//                     ),
//                     decoration: BoxDecoration(
//                         color: colors,
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(12),
//                             topRight: Radius.circular(12))),
//                   ),
//                   Text(
//                     text,
//                     style: poppinsBold(
//                         ScreenUtil().setSp(4).toDouble(), whiteColor),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   SizedBox(
//                     height: 24,
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.only(
//                           left: MediaQuery.of(context).size.height * .10,
//                           right: MediaQuery.of(context).size.height * .10,
//                         ),
//                         height: MediaQuery.of(context).size.width * 0.08,
//                         width: MediaQuery.of(context).size.height * 0.8 / 3.5,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20.0),
//                           boxShadow: [
//                             BoxShadow(
//                               color: secondary, //Colors.grey.withOpacity(0.2),
//                               spreadRadius: 3,
//                               blurRadius: 5,
//                               offset: Offset(0, 1),
//                             ),
//                           ],
//                         ),
//                         child: MaterialButton(
//                           color: colors,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "OK",
//                               style: poppinsBold(
//                                   ScreenUtil().setSp(5).toDouble(), whiteColor),
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context, true);
//                           },
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   /*void _showAlertDialogEnvio(String text, String icono, Color colors) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (buildcontext) {
//           return AlertDialog(
//             backgroundColor: colors,// secondary,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(7.0))),
//             contentPadding: EdgeInsets.only(top: 7.0),
//             content: Container(
//               height: 270,
//               width: 300,
//               decoration: BoxDecoration(
//                   color: secondary,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.circular(12))),
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.only(top: 3),
//                     height: 130,
//                     width: 200,
//                     child: Padding(
//                       padding:  const EdgeInsets.all(12.0),
//                       child: Image.asset(icono),
//                     ),
//                     decoration: BoxDecoration(
//                         color: secondary,
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(12),
//                             topRight: Radius.circular(12))),
//                   ),
//                   Text(
//                     text,
//                     style: poppinsBold( ScreenUtil().setSp(4).toDouble(),
//                         whiteColor),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   SizedBox(
//                     height: 24,
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.only(
//                           left: MediaQuery.of(context).size.height * .10,
//                           right: MediaQuery.of(context).size.height * .10,
//                         ),
//                         height: MediaQuery.of(context).size.width * 0.08,
//                         width: MediaQuery.of(context).size.height * 0.8 / 3.5,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20.0),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.2),
//                               spreadRadius: 3,
//                               blurRadius: 5,
//                               offset: Offset(0, 1),
//                             ),
//                           ],
//                         ),
//                         child: MaterialButton(
//                           color: Colors.pink,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Ok",
//                               style: poppinsBold(
//                                   ScreenUtil().setSp(5).toDouble(),
//                                   whiteColor),
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context, true);
//                           },
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }*/

//   _getSMSValidate(String partnerID) async {
//     //var isDeviceConnected = await DataConnectionChecker().hasConnection;
//     if (!_prefs.requireOffline) {
//       //|| isDeviceConnected) {
//       final _repository = Repository(odooClient: OdooClient(LOCAL_BASE_URL));

//       MessageRequestOdoo res = await _repository.getSMSNewCode(partnerID);
//       if (res.status) {
//         _resetSuccess();
//       } else {
//         ValidateSMSState.failure("");
//       }
//     }
//   }
// }
