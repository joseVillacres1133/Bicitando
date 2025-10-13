import 'package:bicis_ambato/blocs/home_initial/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//Estados de la Pagina de Inicio de la aplicacion
@immutable
abstract class HomeState extends Equatable {
  const HomeState([List props = const []]) : super(); //super(props); const
}

class HomeEmptyState extends HomeState {
  @override
  String toString() => 'HomeInitialEmpty';

  @override
  List<Object?> get props => ['HomeInitialEmpty'];
}

class HomeReservedState extends HomeState {
  final isStopWatchCardEnable = true;
  final isQrButtonActive = false;
  @override
  String toString() => 'HomeReservedState';

  @override
  List<Object?> get props => [isStopWatchCardEnable, isQrButtonActive];
}

@immutable
class HomeStateReserved {
  final bool isStopWatchCardEnable;
  final bool isQrButtonActive;
  final bool isSubmitting;
  final bool isSucces;
  final bool isFailure;
   final String massage;

  const HomeStateReserved({
    required this.isStopWatchCardEnable,
    required this.isQrButtonActive,
    required this.isSubmitting,
    required this.isSucces,
    required this.isFailure,
    required this.massage,
  });

  factory HomeStateReserved.empty() {
    return const HomeStateReserved(
        isStopWatchCardEnable: false,
        isQrButtonActive: true,
        isSubmitting: false,
        isSucces: false,
        isFailure: false,
        massage: '');
  }

  factory HomeStateReserved.reserved() {
    return const HomeStateReserved(
        isStopWatchCardEnable: true,
        isQrButtonActive: false,
        isSubmitting: false,
        isSucces: false,
        isFailure: false,
        massage: '');
  }
  factory HomeStateReserved.noReserved() {
    return const HomeStateReserved(
        isStopWatchCardEnable: false,
        isQrButtonActive: true,
        isSubmitting: false,
        isSucces: false,
        isFailure: false,
        massage: '');
  }

  factory HomeStateReserved.failure(String messageRequest) {
    return HomeStateReserved(
        isStopWatchCardEnable: false,
        isQrButtonActive: false,
        isSubmitting: true,
        isSucces: false,
        isFailure: true,
        massage: messageRequest);
  }
}

// class HomeInitialDataState extends HomeState {
//   @override
//   String toString() => "HomeInitialDataState";

//   @override
//   List<Object?> get props => ["HomeInitialDataState"];
// }

// class HomeMessageState extends HomeState {
//   @override
//   String toString() => 'HomeMessageState';

//   @override
//   List<Object?> get props => ['HomeMessageState'];
// }

// class HomeMessageRState extends HomeState {
//   @override
//   String toString() => 'HomeMessageRState';

//   @override
//   List<Object?> get props => ['HomeMessageRState'];
// }
