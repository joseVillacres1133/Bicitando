import 'package:meta/meta.dart';

//Estados que posee el RegisterForm
@immutable
class ResetState {
  //se agrega ?
  final bool isEmailValid; //La estructura del Email es correcta
  final bool isPasswordValid; //La estructura del Password es correcta
  final bool isConfirmPasswordValid; //La estructura del ConfirmPass es correcta

  final bool? isSubmitting;
  //final bool? isBirthDay;
  final bool? isSuccess;
  final bool? isSendSuccess;
  final bool? isFailure;
  final String? error;

  //se agrega !
  bool get isFormValid =>
      isEmailValid && isPasswordValid && isConfirmPasswordValid; //&&
  //isBirthDay &&
  //isFingerprintCodeValid;

  const ResetState(
      {required this.isEmailValid,
      required this.isPasswordValid,
      required this.isConfirmPasswordValid,
      // @required this.isBirthDay,
      //@required this.isFingerprintCodeValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isSendSuccess,
      @required this.isFailure,
      this.error});

  factory ResetState.empty() {
    return const ResetState(
      isEmailValid: false,
      //isFingerprintCodeValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      // isBirthDay: true,
      isSubmitting: false,
      isSuccess: false,
      isSendSuccess: false,
      isFailure: false,
    );
  }

  factory ResetState.loading() {
    return const ResetState(
      isEmailValid: true,
      //isFingerprintCodeValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      //isBirthDay: true,
      isSubmitting: true,

      isSuccess: false,
      isSendSuccess: false,
      isFailure: false,
    );
  }

  factory ResetState.failure(String error) {
    return ResetState(
      isEmailValid: true,
      //isFingerprintCodeValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      // isBirthDay: true,
      isSubmitting: false,
      isSuccess: false,
      isSendSuccess: false,
      isFailure: true,
      error: error,
    );
  }

  factory ResetState.success() {
    return const ResetState(
      isEmailValid: true,
      //isFingerprintCodeValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      //  isBirthDay: true,
      isSubmitting: false,
      isSuccess: true,
      isSendSuccess: false,
      isFailure: false,
    );
  }

  factory ResetState.sentsuccess() {
    return const ResetState(
      isEmailValid: true,
      //isFingerprintCodeValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      //  isBirthDay: true,
      isSubmitting: false,
      isSuccess: false,
      isSendSuccess: true,
      isFailure: false,
    );
  }

  ResetState update({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    //bool isBirthDay,
    //bool isFingerprintCodeValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      //isFingerprintCodeValid: isFingerprintCodeValid,
      //isBirthDay : isBirthDay,
      isSubmitting: false,
      isSuccess: false,
      isSendSuccess: false,
      isFailure: false,
    );
  }

  ResetState copyWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    //bool? isFingerprintCodeValid,
    bool? isSubmitEnabled,
    // bool? isBirthDay,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isSendSuccess,
    bool? isFailure,
  }) {
    return ResetState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      //isFingerprintCodeValid: isFingerprintCodeValid ?? this.isFingerprintCodeValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isSendSuccess: isSendSuccess ?? this.isSendSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''ResetState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isConfirmPasswordValid: $isConfirmPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
