import 'package:bloc/bloc.dart';

class DeleteCounterCubbit extends Cubit<int> {
  DeleteCounterCubbit():super(5);

  setCounterValue(int value){
    emit(value);
  }
  
}