import 'package:flutter_bloc/flutter_bloc.dart';

import 'bike_reserve_sate.dart';

class BikeReserveCubit extends Cubit<BikeReserveState> {
  BikeReserveCubit({
    bool isReserved = false,
    bool isSubmiting = false
    }) : 
  super(const BikeReserveState(isReserved: false, isSubmiting: false));


    void initState(){
    
    emit(const BikeReserveState(isReserved: false, isSubmiting: false ));
  }
    void isReserved(){
      
    emit(const BikeReserveState(isReserved: true, isSubmiting: false ));
  }
   void isSubmiting(){
    emit(const BikeReserveState(isReserved: false, isSubmiting: true));
  }

}
