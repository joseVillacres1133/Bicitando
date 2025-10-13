import 'package:bloc/bloc.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

import '../../../data/repository.dart';
import '../../../utils/constants_msg.dart';
import '../../../utils/sharedprefs_helper.dart';
import '../../../utils/validarCedula.dart';
import '../../../utils/validators.dart';
import './bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Repository? _repository;
  final Prefs _prefs = Prefs();

  RegisterBloc({required Repository repository})
      : assert(repository != null),
        _repository = repository,
        super(RegisterState.empty()) {
    on<NameChanged>((event, emit) =>
        emit(state.update(isNameValid: Validators.isValidName(event.name!))));
    on<CedulaChanged>((event, emit) => emit(state.update(
        isCedulaValid: event.cedula!.isNotEmpty
            ? Validators.isValidCedula(event.cedula!)
            : Validators.isValidRuc(event.passport!))));
    // on<DireccionChanged>((event, emit) => emit(state.update(
    //
    // on<PhoneChanged>((event, emit) => emit(
    //     state.update(isPhoneValid: Validators.isValidPhone(event.phone!))));
    on<EmailChanged>((event, emit) => emit(
        state.update(isEmailValid: Validators.isValidEmail(event.email!))));
    on<PasswordChanged>((event, emit) => emit(state.update(
        isPasswordValid: Validators.isValidPassword(event.password!))));
    on<ConfirmPasswordChanged>((event, emit) => emit(state.update(
        isConfirmPasswordValid: event.password == event.confirmPassword)));
    // on<TermsAndConditiosnChange>((event, emit) => emit(state.update(
    //     isConfirmPasswordValid: event.isChecked )));
    on<ButtonSubmitPressed>((event, emit) {
      if (state.isNameValid &&
          state.isEmailValid &&
          state.isPasswordValid &&
          state.isConfirmPasswordValid) {
        emit(state.update(isSubmitting: true));
      }
    });
    on<Submitted>((event, emit) async {
      var isDeviceConnected = await DataConnectionChecker().hasConnection;
      if (_prefs.requireOffline || !isDeviceConnected) {
        RegisterState.failure(str_without_connect);
      } else {
        // //Future<bool> cedulaExistenteOdoo = validarCedulaExistente(event.user.cedula!);
        // if (await validarCorreoExistente(event.user.login)  ||
        //     await cedulaExistenteOdoo) {
        //       // await cedulaExistenteOdoo ?
        //       //     RegisterState.failure(str_ci_register)
        //       //     : RegisterState.failure(str_phone_register);
        //       // await cedulaExistenteOdoo
        //       //     ? RegisterState.failure(str_ci_register)
        //       //     : RegisterState.failure(str_mail_register);
        // } else {

        try {
          var data = await _repository!.signUp(event.user);

          if (data == 'ok') {
            emit(RegisterState.success());
          } else if (data == 'is already') {
            emit(RegisterState.failure(str_user_register));
          } else if (data == 'is already id') {
            emit(RegisterState.failure(str_user_register_id));
          } else if (data == 'wrong') {
            emit(RegisterState.failure(str_try_again));
          } else {
            emit(RegisterState.failure(str_cannot_register));
          }

          // data=='ok'
          //       ? emit(RegisterState.success())
          //       : emit(RegisterState.failure(
          //           str_user_register)); //el yield permite mandar a los estados configurados de cada clase
          //   //: emit(RegisterState.failure(str_cannot_register));
        } catch (_) {
          emit(state.update(isFailure: true, error: str_error_register));
          //RegisterState.failure(str_error_register);
          //emit()
        }
        // if (!cedulaOruc(event.user.cedula, event.user.type_identifier)) {
        //   if (event.user.type_identifier == "ruc") {
        //     !cedulaOruc(event.user.cedula, event.user.type_identifier)
        //         ? RegisterState.failure(
        //             str_ruc_invalid) //Despues de ingresar la cedula, la verifica si es una cedula ecuatoriana valida
        //         : RegisterState.failure(str_phone_invalid);
        //   } else {
        // !cedulaOruc(event.user.cedula!, 'cedula')
        //     ? RegisterState.failure(
        //         str_ci_invalid) //Despues de ingresar la cedula, la verifica si es una cedula ecuatoriana valida
        //     : RegisterState.failure(
        //         str_phone_invalid); //Despues de ingresar el numero de telefono, se verifica sin es Nº Celular correcto o Nº Telefono Ecuatoriano correcto
      }
    });
    on<ErrorSignup>((event, emit) async {});
  }
}
