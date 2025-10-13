import 'dart:io';

import 'package:bicis_ambato/blocs/auth/changePass/change_pswd_event.dart';
import 'package:bicis_ambato/blocs/auth/changePass/change_pswd_state.dart';
import 'package:bicis_ambato/data/auth_provider.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../../utils/validators.dart';

class ChangePswdBloc extends Bloc<ChangePswdEvent, ChangePswdState> {
  final Prefs prefs = Prefs();
  ChangePswdBloc() : super(ChangePswdState.empty()) {
    on<OldPasswordChanged>(
      (event, emit) {
        bool isValid = Validators.isValidPassword(event.oldPassword!);
        emit(state.update(isOldPasswordValid: isValid));
      },
    );
    on<NewPasswordChanged>(
      (event, emit) {
        bool isValid = Validators.isValidPassword(event.newPassword!);
        emit(state.update(isNewPasswordValid: isValid));
      },
    );
    on<ConfirmPasswordChanged>(
      (event, emit) {
        bool isValid = event.password == event.confirmPassword;
        emit(state.update(isConfirmPasswordValid: isValid));
      },
    );
    on<Submitted>(
      (event, emit) async {
        try {
          AuthProvider authProvider = AuthProvider();
          if (event.oldPassword == event.secret) {
            bool isSuccess = await authProvider.changePassword(
                event.oldPassword, event.newPassword);
            if (isSuccess) {
              prefs.secret = event.newPassword;
              emit(ChangePswdState.success());
            } else {
              emit(ChangePswdState.failure('No se pudo realizar la acción'));
            }
          }
        } on OdooException {
          emit(ChangePswdState.failure('No se pudo realizar la acción'));
        } on SocketException {
          emit(ChangePswdState.failure(
              'No se pudo realizar la acción intenta más tarde'));
        } on Exception {
          emit(ChangePswdState.failure('No se pudo realizar la acción'));
        }
      },
    );
  }
}
