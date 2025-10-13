import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final String filterDate;
  final int filterStateTravel;

  const FilterState(this.filterDate,this.filterStateTravel);
  @override
  List<Object?> get props => [filterDate,filterStateTravel];
  
  List<String?> get date => [filterDate];
  List<int?> get stateTravel => [filterStateTravel];
  
 
}