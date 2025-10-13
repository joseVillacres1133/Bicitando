import 'package:flutter_bloc/flutter_bloc.dart';

class QrDataCubit extends Cubit<String> {
  QrDataCubit(): super('noQr');

  void setQrValue(String qrValue){
    emit(qrValue);
  }
  
}