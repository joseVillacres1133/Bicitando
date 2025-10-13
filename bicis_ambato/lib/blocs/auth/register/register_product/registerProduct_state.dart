import 'package:meta/meta.dart';

//Estados que posee el RegisterForm
@immutable
class RegisterProductState {
  //se agrega ?
  final bool? isNameValid; //La estructura del Nombre es correcta
  final bool? isDireccionValid; //La estructura de la Dirección es correcta
  final bool? isPhoneValid; //La estructura del Telefono es correcta
  final bool? isDescripcionValid; //La estructura del Telefono es correcta
  final bool? isCedulaValid; //La estructura del Telefono es correcta
  final bool? isNumeroValid; //Alto
  final bool? isEmailValid;
  final bool? isAnchoValid;
  final bool? isPesoValid;
  final bool? isLargoValid;
  final bool? isPrecioValid;
  final bool? isSubmitting;
  final bool? isSuccess;
  final bool? isFailure;
  final String? error;

  //se agrega !
  bool get isFormValid =>
      isNameValid! &&
      isDireccionValid! &&
      isPhoneValid! &&
      isDescripcionValid! &&
      isCedulaValid! &&
      isNumeroValid! &&
      isEmailValid! &&
      isAnchoValid! &&
      isPesoValid! &&
      isLargoValid! &&
      isPrecioValid!;

  RegisterProductState(
      {@required this.isNameValid,
      @required this.isDireccionValid,
      @required this.isPhoneValid,
      @required this.isDescripcionValid,
      @required this.isCedulaValid,
      @required this.isNumeroValid,
      @required this.isEmailValid,
      @required this.isAnchoValid,
      @required this.isPesoValid,
      @required this.isLargoValid,
      @required this.isPrecioValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      this.error});

  factory RegisterProductState.empty() {
    return RegisterProductState(
      isNameValid: true,
      isDireccionValid: true,
      isPhoneValid: true,
      isDescripcionValid: true,
      isCedulaValid: true,
      isNumeroValid: true,
      isEmailValid: true,
      isAnchoValid: true,
      isPesoValid: true,
      isLargoValid: true,
      isPrecioValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterProductState.loading() {
    return RegisterProductState(
      isNameValid: true,
      isDireccionValid: true,
      isPhoneValid: true,
      isDescripcionValid: true,
      isCedulaValid: true,
      isNumeroValid: true,
      isEmailValid: true,
      isAnchoValid: true,
      isPesoValid: true,
      isLargoValid: true,
      isPrecioValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterProductState.failure(String error) {
    return RegisterProductState(
      isNameValid: true,
      isDireccionValid: true,
      isPhoneValid: true,
      isDescripcionValid: true,
      isCedulaValid: true,
      isNumeroValid: true,
      isEmailValid: true,
      isAnchoValid: true,
      isPesoValid: true,
      isLargoValid: true,
      isPrecioValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      error: error,
    );
  }

  factory RegisterProductState.success() {
    return RegisterProductState(
      isNameValid: true,
      isDireccionValid: true,
      isPhoneValid: true,
      isDescripcionValid: true,
      isCedulaValid: true,
      isNumeroValid: true,
      isEmailValid: true,
      isAnchoValid: true,
      isPesoValid: true,
      isLargoValid: true,
      isPrecioValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  RegisterProductState update({
    bool? isNameValid,
    bool? isDireccionValid,
    bool? isPhoneValid,
    bool? isDescripcionValid,
    bool? isCedulaValid,
    bool? isNumeroValid,
    bool? isEmailValid,
    bool? isAnchoValid,
    bool? isPesoValid,
    bool? isLargoValid,
    bool? isPrecioValid,
  }) {
    return copyWith(
      isNameValid: isNameValid,
      isDireccionValid: isDireccionValid,
      isPhoneValid: isPhoneValid,
      isDescripcionValid: isDescripcionValid,
      isCedulaValid: isCedulaValid,
      isNumeroValid: isNumeroValid,
      isEmailValid: isEmailValid,
      isAnchoValid: isAnchoValid,
      isPesoValid: isPesoValid,
      isLargoValid: isLargoValid,
      isPrecioValid: isPrecioValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterProductState copyWith({
    bool? isNameValid,
    bool? isDireccionValid,
    bool? isPhoneValid,
    bool? isDescripcionValid,
    bool? isCedulaValid,
    bool? isNumeroValid,
    bool? isEmailValid,
    bool? isAnchoValid,
    bool? isPesoValid,
    bool? isLargoValid,
    bool? isPrecioValid,
    bool? isSubmitEnabled,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return RegisterProductState(
      isNameValid: isNameValid ?? this.isNameValid,
      isDireccionValid: isDireccionValid ?? this.isDireccionValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isDescripcionValid: isDescripcionValid ?? this.isDescripcionValid,
      isCedulaValid: isCedulaValid ?? this.isCedulaValid,
      isNumeroValid: isNumeroValid ?? this.isNumeroValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isAnchoValid: isAnchoValid ?? this.isAnchoValid,
      isPesoValid: isPesoValid ?? this.isPesoValid,
      isLargoValid: isLargoValid ?? this.isLargoValid,
      isPrecioValid: isPrecioValid ?? this.isPrecioValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      // isBirthDay: isBirthDay ?? this.isBirthDay,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterProductState {
      isNameValid: $isNameValid,
      isPhoneValid: $isPhoneValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
