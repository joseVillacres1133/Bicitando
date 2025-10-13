import 'package:bicis_ambato/data/auth_provider.dart';
import 'package:bloc/bloc.dart';
import '../../../utils/validators.dart';
import 'bloc.dart';

class ResetBloc extends Bloc<ResetEvent, ResetState> {
  //Repository? _repository;
  ResetBloc():super(ResetState.empty())
         {
    on<EmailChanged>((event, emit) => emit(
        state.update(isEmailValid: Validators.isValidEmail(event.email!))));
    on<OldPasswordChanged>((event, emit) => state.update(
        isPasswordValid: Validators.isValidPassword(event.password!)));
    on<PasswordChanged>((event, emit) {  
      bool isValid =  Validators.isValidPassword(event.password!);
      state.update(isPasswordValid: isValid);
      });
    on<ConfirmPasswordChanged>((event, emit) => state.update(
        isConfirmPasswordValid: event.password == event.confirmPassword));
    // on<SendToken>((event, emit) async {
    //   Prefs _prefs = Prefs();
    //   ResetState.loading();
    //   print("HOLA DESDE SEND TOKEN  **** $event.email");
    //   emit(ResetState.loading());
    //   MessageRequestOdoo result = await _repository!.sendEmailUser(event.email);
    //   if (result.status == true) {
    //     emit(ResetState.sentsuccess());
    //   } else {
    //     emit(ResetState.failure(result.msg));
    //   }
    // });
    on<Submitted>((event, emit) async {
      AuthProvider authProvider = AuthProvider();
      var response = await authProvider.sendEmailUserResetPassword(event.email);
      if (response.msg== 'Password reset instructions sent to your email') {
        emit(ResetState.success());
        print(state);
      }else{
        emit(ResetState.failure("Usuario no registrado"));
      }
    });
  }

  @override
  ResetState get initialState => ResetState.empty();

  // @override
  // Stream<ResetState> transform(
  //   Stream<ResetEvent> events,
  //   Stream<ResetState> Function(ResetEvent event) next,
  // ) {
  //   final observableStream = events as Stream<ResetEvent>;
  //   final nonDebounceStream = observableStream.where((event) {
  //     return (event is! EmailChanged &&
  //             event is! PasswordChanged &&
  //             event is! ConfirmPasswordChanged //&&
  //         //event is! FingerprintCodeChanged
  //         );
  //   });
  //   final debounceStream = observableStream.where((event) {
  //     return (event is EmailChanged ||
  //             event is PasswordChanged ||
  //             event is ConfirmPasswordChanged //||
  //         //event is FingerprintCodeChanged
  //         );
  //   }).debounceTime(Duration(milliseconds: 300));
  //   return transform(nonDebounceStream.mergeWith([debounceStream]), next);
  // }
  /*Rx<ResetEvent> transformEvents(Stream<ResetEvent> events, next) {
  final observableStream = Rx<ResetEvent>(events);
  final nonDebounceStream = observableStream.where((event) {
    return (event is! EmailChanged &&
        event is! PasswordChanged &&
        event is! ConfirmPasswordChanged);
  });
  final debounceStream = observableStream.where((event) {
    return (event is EmailChanged ||
        event is PasswordChanged ||
        event is ConfirmPasswordChanged);
  }).debounceTime(Duration(milliseconds: 300));
  return Rx.merge([nonDebounceStream, debounceStream]).transform(next);
}*/

//   @override
//   Stream<ResetState> mapEventToState(
//     ResetEvent event,
//   ) async* {
//     if (event is EmailChanged) {
//       yield* _mapEmailChangedToState(event.email!);
//     } else if (event is PasswordChanged) {
//       yield* _mapPasswordChangedToState(event.password!);
//     } else if (event is ConfirmPasswordChanged) {
//       yield* _mapConfirmPasswordChangedToState(
//           event.password!, event.confirmPassword!);
//     } else if (event is SendToken) {
//       yield* _mapFormSendToState(event.email, event.token);
//     } else if (event is Submitted) {
//       yield* _mapFormSubmittedToState(
//           event.email, event.password, event.confirmPassword, event.oldPass);
//     }
//   }

//   Stream<ResetState> _mapEmailChangedToState(String email) async* {
//     yield state.update(
//       isEmailValid: Validators.isValidEmail(email),
//     );
//   }

//   Stream<ResetState> _mapPasswordChangedToState(String password) async* {
//     yield state.update(
//       isPasswordValid: Validators.isValidPassword(password),
//     );
//   }

//   Stream<ResetState> _mapConfirmPasswordChangedToState(
//       String password, String confirmPassword) async* {
//     yield state.update(isConfirmPasswordValid: password == confirmPassword);
//   }

//   Stream<ResetState> _mapFormSubmittedToState(
//       String email, String password, String confirmp, String oldpass) async* {
//     Prefs _prefs = Prefs();
//     //Registro solo en MODO ONLINE
//     yield ResetState.loading();
//     if (!await validarCorreoExistente(email)) {
//       yield ResetState.failure("Correo Electrónico no registrado");
//     } else {
//       final res = await _repository!
//           .changePass(oldpass, password, confirmp, _prefs.idUser);

//       yield res != null
//           ? ResetState.success()
//           : ResetState.failure(str_cannot_chan_pwd);
//     }
//   }

//   Stream<ResetState> _mapFormSendToState(String email, String token) async* {
//     Prefs _prefs = Prefs();
//     var codigo = randomAlphaNumeric(8);
//     yield ResetState.loading();

//     if (email.isEmpty) {
//       yield ResetState.failure(str_enter_email);
//     } else {
//       if (!await validarCorreoExistente(email)) {
//         yield ResetState.failure("Correo Electrónico no registrado");
//       } else {
//         if (await validarSiConductor(email)) {
//           MessageRequestOdoo res = await _repository!.sendEmailUser(email);
//           if (res.status) {
//             yield ResetState.sentsuccess();
//           } else {
//             //////print(res);
//             _prefs.resetPass = false;
//             yield ResetState.failure(str_no_send_try_again);
//           }
//         } else {
//           _prefs.resetPass = false;
//           yield ResetState.failure(str_register_wegoo_driver);
//         }
//       }
//     }
//   }
}
