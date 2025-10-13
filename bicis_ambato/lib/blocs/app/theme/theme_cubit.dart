//import 'package:bicis_ambato/blocs/app/theme/theme_state.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool>{
  Prefs prefs = Prefs();
  ThemeCubit():super(false);

 void setThemeValue(bool isDarkMode){
    prefs.isDarkThemeEnabled = isDarkMode;
    emit(isDarkMode);
  }


//   ThemeCubit({
//     bool darkMode = false
//     }) : 
//   super(ThemeState(isDarkMode: darkMode));

// void setThemeValue(bool value){
//     emit(ThemeState(isDarkMode: value));
//   }
//   void tooglTheme(){
//     emit(ThemeState(isDarkMode: !state.isDarkMode));
//   }
//   void setDarkMode(){
//     emit(ThemeState(isDarkMode: state.isDarkMode));
//   }
//   void lightMode(){
//     emit(ThemeState(isDarkMode: !state.isDarkMode));
//   }


}
