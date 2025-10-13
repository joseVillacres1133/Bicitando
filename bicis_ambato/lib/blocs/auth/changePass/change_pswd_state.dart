import 'package:meta/meta.dart';

@immutable
class ChangePswdState {
  final bool isOldPasswordValid; //La estructura del Password es correcta
  final bool isNewPasswordValid; //La estructura del Password es correcta
  final bool isConfirmPasswordValid; //La estructura del ConfirmPass es correcta
  final bool? isSuccess;
  final bool? isFailure;
  final String? error;

  bool get isFormValid =>
      isOldPasswordValid && isNewPasswordValid && isConfirmPasswordValid;

  const ChangePswdState(
      {required this.isOldPasswordValid,
      required this.isNewPasswordValid,
      required this.isConfirmPasswordValid,
      @required this.isSuccess,
      @required this.isFailure,
      this.error});

  factory ChangePswdState.empty() {
    return const ChangePswdState(
      isOldPasswordValid: true,
      isNewPasswordValid: true,
      isConfirmPasswordValid: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ChangePswdState.failure(String error) {
    return ChangePswdState(
      isOldPasswordValid: true,
      isNewPasswordValid: true,
      isConfirmPasswordValid: true,
      isSuccess: false,
      isFailure: true,
      error: error,
    );
  }

  factory ChangePswdState.success() {
    return const ChangePswdState(
      isOldPasswordValid: true,
      isNewPasswordValid: true,
      isConfirmPasswordValid: true,
      isSuccess: true,
      isFailure: false,
    );
  }

  ChangePswdState update(
      {bool? isOldPasswordValid,
      bool? isNewPasswordValid,
      bool? isConfirmPasswordValid,
      bool? isSuccess,
      bool? isFailure,
      String? error}) {
    return copyWith(
        isOldPasswordValid: isOldPasswordValid,
        isNewPasswordValid: isNewPasswordValid,
        isConfirmPasswordValid: isConfirmPasswordValid,
        isSuccess: false,
        isFailure: isFailure,
        error: error);
  }

  ChangePswdState copyWith(
      {bool? isOldPasswordValid,
      bool? isNewPasswordValid,
      bool? isConfirmPasswordValid,
      bool? isSuccess,
      bool? isFailure,
      String? error}) {
    return ChangePswdState(
        isOldPasswordValid: isOldPasswordValid ?? this.isOldPasswordValid,
        isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
        isConfirmPasswordValid:
            isConfirmPasswordValid ?? this.isConfirmPasswordValid,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  @override
  String toString() {
    return '''ChangePswdState {
      isOldPasswordValid: $isOldPasswordValid,
      isNewPasswordValid: $isNewPasswordValid,
      isConfirmPasswordValid: $isConfirmPasswordValid,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    } ''';
  }
}
