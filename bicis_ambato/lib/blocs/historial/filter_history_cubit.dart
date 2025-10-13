import 'package:bicis_ambato/blocs/historial/filter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterTravelCubit extends Cubit<FilterState> {

  FilterTravelCubit(
    {String date = '',
    int stateTravel = 0}
  ): super(FilterState(date, stateTravel));

  void setFilterState(String date,int stateTravel){
    emit(FilterState( date, stateTravel));
  }

  
}