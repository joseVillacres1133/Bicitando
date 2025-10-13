import 'package:meta/meta.dart';

//Estados que posee el ResetPasswordForm
@immutable
class ValidateSMSState {
  //se agrega ?
  final bool? isCodeValidate; //La estructura del Email es correcta
  final bool? isSubmitting;
  final bool? isSuccess;
  final bool? isFailure;
  final String? error;

  bool get isFormValid => isCodeValidate!;

  ValidateSMSState(
      {@required this.isCodeValidate,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      this.error});

  factory ValidateSMSState.empty() {
    return ValidateSMSState(
      isCodeValidate: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ValidateSMSState.loading() {
    return ValidateSMSState(
      isCodeValidate: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ValidateSMSState.failure(String error) {
    return ValidateSMSState(
      isCodeValidate: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      error: error,
    );
  }

  factory ValidateSMSState.success() {
    return ValidateSMSState(
      isCodeValidate: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  ValidateSMSState update({
    bool? isCodeValidate,
  }) {
    return copyWith(
      isCodeValidate: isCodeValidate!,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  ValidateSMSState copyWith({
    bool? isCodeValidate,
    bool? isSubmitEnabled,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return ValidateSMSState(
      isCodeValidate: isCodeValidate ?? this.isCodeValidate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''ValidateSMSState {
      isCodeValidate: $isCodeValidate,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,odoo
      isFailure: $isFailure,
    }''';
  }
}
