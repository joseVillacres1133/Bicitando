import 'package:equatable/equatable.dart';

class BikeReserveState extends Equatable {
  final bool isReserved;
  final bool isSubmiting;

  const BikeReserveState( {required this.isReserved,required this.isSubmiting});

  @override
  List<Object?> get props => [isReserved, isSubmiting];


}
