import 'package:meta/meta.dart';

//Estados que posee el RegisterForm
@immutable
class RegisterState {
  final bool isNameValid; //La estructura del Nombre es correcta
  final bool isCedulaValid; //La estructura de la Cedula es correcta
  //final bool isDireccionValid; //La estructura de la Dirección es correcta
  //final bool isPhoneValid; //La estructura del Telefono es correcta
  final bool isEmailValid; //La estructura del Email es correcta
  final bool isPasswordValid; //La estructura del Password es correcta
  final bool isConfirmPasswordValid; //La estructura del ConfirmPass es correcta
  //final bool? isFingerprintCodeValid; //La estructura del DNI(Codigo Dactilar C.I.) es correcta
  final bool? isSubmitting;
  //final bool? isBirthDay;
  final bool? isSuccess;
  final bool? isFailure;
  final String? error;

  bool get isFormValid =>
      isNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid;

  const RegisterState(
      {required this.isNameValid,
      required this.isCedulaValid,
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isConfirmPasswordValid,
      // @required this.isBirthDay,
      //@required this.isFingerprintCodeValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      this.error});

  factory RegisterState.empty() {
    return const RegisterState(
      isNameValid: true,
      isCedulaValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.loading() {
    return const RegisterState(
      isNameValid: true,
      isCedulaValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure(String error) {
    return RegisterState(
      isNameValid: true,
      isCedulaValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      error: error,
    );
  }

  factory RegisterState.success() {
    return const RegisterState(
      isNameValid: true,
      isCedulaValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  RegisterState update(
      {bool? isNameValid,
      bool? isCedulaValid,
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isConfirmPasswordValid,
      bool? isSubmitting,
      bool? isFailure,
      String? error}) {
    return copyWith(
        isNameValid: isNameValid,
        isCedulaValid: isCedulaValid,
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isConfirmPasswordValid: isConfirmPasswordValid,
        isSubmitting: isSubmitting,
        isSuccess: false,
        isFailure: isFailure,
        error: error);
  }

  //se agrega ?
  RegisterState copyWith({
    bool? isNameValid,
    bool? isCedulaValid,
    bool? isDireccionValid,
    bool? isPhoneValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isSubmitEnabled,
    // bool? isBirthDay,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? error,
  }) {
    return RegisterState(
        isNameValid: isNameValid ?? this.isNameValid,
        isCedulaValid: isCedulaValid ?? this.isCedulaValid,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isConfirmPasswordValid:
            isConfirmPasswordValid ?? this.isConfirmPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        error: error ?? this.error);
  }

  @override
  String toString() {
    return '''RegisterState {
      isNameValid: $isNameValid,
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isConfirmPasswordValid: $isConfirmPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
