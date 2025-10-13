// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/auth_provider.dart';
import '../../../data/repository.dart';
import '../../../utils/constants_msg.dart';
import '../../../utils/sharedprefs_helper.dart';
import '../../../utils/validators.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repository? _repository;
  final BuildContext? _context;

  final Prefs _prefs = Prefs();

  LoginBloc({
    required Repository repository,
    required BuildContext context,
  })  : _repository = repository,
        _context = context,
        super(LoginState.empty()) {
    on<EmailChanged>((event, emit) {
      emit(state.update(
        isEmailValid: Validators.isValidEmail(event.email!),
        isPasswordValid: true,
      ));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.update(
          isPasswordValid: true, //Validators.isValidPassword(event.password!),
          isEmailValid: true));
    });
    on<LoginWithCredentialsPressed>((event, emit) async {
      emit(LoginState.loading());

      //var isDeviceConnected = await DataConnectionChecker().hasConnection;
      final connectivityResult = (Connectivity().checkConnectivity());
      //MODO ONLINE
      //if (_prefs.requireOffline || !isDeviceConnected.) {
      if (_prefs.requireOffline ||
          connectivityResult == ConnectivityResult.none) {
        emit(LoginState.offline());
      } else if (_prefs.requireGPS) {
        emit(LoginState.failure(str_without_gps));
      } else {
        try {
          var resultAutehntication =
              await _repository!.authenticate(event.email, event.password);
          if (resultAutehntication!) {
            emit(LoginState.success());
          } else {
            emit(LoginState.failure(str_user_pwd_invalid));
          }
        } catch (_) {
          if (_.toString().contains(str_trie_call)) {
            emit(LoginState.failure(str_pwd_incorrect));
          } else {
            if (_.toString().contains(str_socket_except)) {
              emit(LoginState.failure(str_error_server));
            } else {
              emit(LoginState.failure(str_has_problem_into));
            }
          }
        }
      }
    });

    on<ChangePassEvent>((event, emit) {
      log("login bloc desde chagepass event al iniciar login button");
    });
    on<DesvincularOfflineEvent>((event, emit) {});
    on<Submitted>((event, emit) {
      log("login bloc desde subbmited");
    });
    on<LoginWithFacebook>((event, emit) {});
  }

  LoginState get initialState => LoginState.empty();
  BuildContext get context => _context!;

  // Stream<LoginState> _loginWithFacebook() async* {
  //   final facebookLogin = FacebookLogin();
  //   Prefs _prefs = Prefs();

  //   final result = await facebookLogin.logIn(customPermissions: ['email']);

  //   switch (result.status) {
  //     case FacebookLoginStatus.success: // loggedIn:
  //       final token = result.accessToken?.token;
  //       final graphResponse = await http.get(Uri.parse(
  //           'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}'));
  //       final profile = JSON.jsonDecode(graphResponse.body);
  //       //////print(profile);
  //       _prefs.requireUserPhoto = profile["picture"]["data"]["url"];
  //       _prefs.user = profile["name"];
  //       _prefs.email = profile["email"];
  //       yield LoginState.success();
  //       break;
  //     case FacebookLoginStatus.cancel: // cancelledByUser:
  //       _prefs.logoutFace = false;
  //       yield LoginState.failure(str_cancel_by_user);
  //       break;
  //     case FacebookLoginStatus.error:
  //       _prefs.logoutFace = false;
  //       if (_prefs.requireOffline) {
  //         yield LoginState.offline();
  //       } else {
  //         yield LoginState.failure(str_error_occu);
  //       }
  //       break;
  //   }
  //   //yield LoginState.success();
  // }

  _mapLoginWithCredentialsPressedToState(
      {required String email,
      required String password,
      required String serie}) async* {
    yield LoginState.loading();
    //var isDeviceConnected = await DataConnectionChecker().hasConnection;
    final connectivityResult = await (Connectivity().checkConnectivity());
    //MODO ONLINE
    //if (_prefs.requireOffline || !isDeviceConnected.) {
    if (_prefs.requireOffline ||
        connectivityResult == ConnectivityResult.none) {
      yield LoginState.offline();
    } else if (_prefs.requireGPS) {
      yield LoginState.failure(str_without_gps);
    } else {
      try {
        AuthProvider _authProviderAlwaysAdmin;
        _authProviderAlwaysAdmin = AuthProvider();
        //var emailVerificate = await _authProviderAlwaysAdmin.getEmailVerificate(email, 1);
        //if (emailVerificate != null) {
        // if (emailVerificate["search_read"].toString().contains("ok") &&
        //     emailVerificate["active"]) {
        //   String partnerID = emailVerificate["id"].toString();
        //   _prefs.idPartnerVerificate = int.parse(partnerID);

        //   var resultAutehntication =
        //       await _repository?.authenticate(email, password);
        //   if (resultAutehntication != null) {
        //     if (_prefs.accountValidate) {
        //       if (_prefs.changePassword.toLowerCase().toString() !=
        //           str_false) {
        //         await Navigator.pushReplacementNamed(context, 'changePWD')
        //             .catchError((Object error) {
        //           Navigator.pushReplacementNamed(context, 'changePWD');
        //         });
        //       } else {
        //         yield LoginState.success();
        //       }
        //     } else {
        //       await Navigator.pushReplacementNamed(context, 'smsVerificate')
        //           .catchError((Object error) {
        //         Navigator.pushReplacementNamed(context, 'smsVerificate');
        //       });
        //     }
        //   } else {
        //     yield LoginState.failure(str_user_pwd_invalid);
        //   }
        // } else {
        //   if (emailVerificate["search_read"]
        //       .toString()
        //       .contains(str_delivery_buss)) {
        //     yield LoginState.failure('Registrado en Wegoo Driver');
        //   } else {
        //     yield LoginState.failure(str_email_no_register);
        //   }
        // }
        // } else {
        //   yield LoginState.failure(str_email_no_register);
        // }
      } catch (_) {
        if (_.toString().contains(str_trie_call)) {
          yield LoginState.failure(str_pwd_incorrect);
        } else {
          if (_.toString().contains(str_socket_except)) {
            yield LoginState.failure(str_error_server);
          } else {
            yield LoginState.failure(str_has_problem_into);
          }
        }
      }
    }
  }
}
