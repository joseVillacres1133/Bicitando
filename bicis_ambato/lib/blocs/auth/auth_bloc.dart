import 'package:flutter/cupertino.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:bloc/bloc.dart';

import '../../data/auth_provider.dart';
import '../../data/repository.dart';
import '../../utils/sharedprefs_helper.dart';
import './bloc.dart';

//Logica de la clase
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final Repository? _repository;
  late final AuthProvider _authProvider;
  final _prefs = Prefs();

  final BuildContext _context;

  AuthBloc(
      {@required Repository? repository,
      @required AuthProvider? authProvider,
      @required BuildContext? context})
      : assert(repository != null),
        _repository = repository!,
        _authProvider = authProvider!,
        _context = context!,
        super(Uninitialized()) {
    // on<AppStarted>((event, emit) {
    //   //Inicia aplicacion
    //   Uninitialized(); //Estado No Inicializado por defecto

    //   final requireAuthentication = _prefs.requireAuthentication;
    //   final String user;
    //   //Verifica los sharedprefernces para mandar el estado de la aplicación
    //   if (requireAuthentication) {
    //     _prefs.userName = "A";
    //     emit(Unauthenticated());
    //   } else {
    //     user = _prefs.userName;
    //     emit(Authenticated(user.toString()));
    //   }
    // });
    on<AppStarted>((event, emit) async {
      final session = _prefs.sessionId;

      if (session == null || session.isEmpty || _prefs.requireAuthentication) {
        emit(Unauthenticated());
        return;
      }

      try {
        final expired =
            await _authProvider.checkSessionExpired(); // método ya lo tienes
        if (expired) {
          await _prefs.clearSession();
          emit(Unauthenticated());
        } else {
          emit(Authenticated(_prefs.userName));
        }
      } catch (_) {
        await _prefs.clearSession();
        emit(Unauthenticated());
      }
    });

    on<LoggedIn>((event, emit) {
      //Ingreso aplicacion
      Uninitialized();
      _prefs.requireAuthentication = false;
      emit(Authenticated(_prefs.userName));
    });
    on<LoggedOut>((event, emit) {
      _repository!.signOut();
      _prefs.clearSession(); // borra sessionId, idUser, etc.
      _prefs.requireAuthentication = true;
      Uninitialized();
      //Navigator.pushReplacementNamed(_context, 'profile');
      //emit(Unauthenticated());
    });
  }

  @override
  AuthState get initialState => Uninitialized();
  @override
  void dispose() {}
}
