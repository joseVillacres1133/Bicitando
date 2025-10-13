import 'package:meta/meta.dart';

//Estados del fingerprint (exitoso, fallido)
@immutable
class FingerprintState {
  final bool? isSuccess;
  final bool? isFailure;
  final String? mens;

  FingerprintState(
      {@required this.isSuccess,
      @required this.isFailure,
      @required this.mens});

  factory FingerprintState.initial() {
    return FingerprintState(isSuccess: false, isFailure: false, mens: '');
  }

  FingerprintState update({bool? isSuccess, bool? isFailure, String? mens}) {
    return copyWith(isSuccess: isSuccess!, isFailure: isFailure!, mens: mens!);
  }

  FingerprintState copyWith({bool? isSuccess, bool? isFailure, String? mens}) {
    return FingerprintState(
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        mens: mens ?? this.mens);
  }

  @override
  String toString() {
    return ''' FingerprintState {
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      mens: $mens
    }
    ''';
  }
}
