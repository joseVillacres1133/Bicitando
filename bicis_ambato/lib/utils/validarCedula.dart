//Validar Cedula Ecuatoriana
// ignore_for_file: unused_local_variable



import '../data/auth_provider.dart';
import '../data/models/odoo/UserInfoOdoo.dart';
import 'sharedprefs_helper.dart';

bool validarCedula(String ced) {
  List<int> cedula = [];
  int suma = 0;
  int mult;
  List<int> coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  String primerosDos = ced[0] + ced[1];

  // primeros dos digitos deben ser mayor a 0 y menor o igual a 24 (numero de provincias ecuatorianas)
  if (int.parse(primerosDos) > 0 && int.parse(primerosDos) <= 24) {
    // tercer digito menor a 6
    if (int.parse(ced[2]) < 6) {
      for (int i = 0; i < 10; i++) {
        cedula.add(int.parse(ced[i]));
      }
      for (int i = 0; i < 9; i++) {
        mult = cedula[i] * coeficientes[i];
        if (mult >= 10) {
          mult = mult - 9;
        }
        suma = suma + mult;
      }

      int numVerificador = decimaSuperior(suma) - suma;
      if (numVerificador == cedula[9]) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}

bool cedulaOruc(String ced, String tipo) {
  if (tipo == "ruc") {
    if (validarRuc(ced)) {
      return true;
    } else {
      return false;
    }
  } else {
    if (validarCedula(ced)) {
      return true;
    } else {
      return false;
    }
  }
}

bool validarRuc(String ced) {
  List<int> cedula = [];
  int suma = 0;
  int mult;
  List<int> coeficientes = [4, 3, 2, 7, 6, 5, 4, 3, 2]; //RUC EMPRESA PRIVADA
  List<int> coeficientesS = [3, 2, 7, 6, 5, 4, 3, 2]; //RUC EMPRESA PUBLICA
  String primerosDos = ced[0] + ced[1];
  //////print(ced.length);
  if (ced.length == 13) {
    if (int.parse(ced[12]) >= 1) {
      // primeros dos digitos deben ser mayor a 0 y menor o igual a 24 (numero de provincias ecuatorianas)
      if (int.parse(primerosDos) > 0 && int.parse(primerosDos) <= 24) {
        for (int i = 0; i < 13; i++) {
          cedula.add(int.parse(ced[i]));
        }
        // tercer digito igual a 9
        if (int.parse(ced[2]) == 9) {
          for (int i = 0; i < 9; i++) {
            mult = cedula[i] * coeficientes[i];
            suma = suma + mult;
          }
          //////print(suma);
          var res = suma / 11;
          var res1 = suma % 11;
          //////print(res.floor());
          //////print(res1);
          var ruc = 11 - res1;
          if (ruc == cedula[9]) {
            //////print("empresa privada");
            return true;
          } else {
            return false;
          }
        } else if (int.parse(ced[2]) == 6) {
          for (int i = 0; i < 8; i++) {
            mult = cedula[i] * coeficientesS[i];
            suma = suma + mult;
          }
          //////print(suma);
          var res = suma / 11;
          var res1 = suma % 11;
          //////print(res.floor());
          //////print(res1);
          var ruc = 11 - res1;
          if (ruc == cedula[8]) {
            //////print("empresa publica");
            return true;
          } else {
            return false;
          }
        } else {
          String cedd = "";
          for (int i = 0; i < 10; i++) {
            cedd = cedd + cedula[i].toString();
          }
          var resp = validarCedula(cedd);
          if (resp) {
            return true;
          } else {
            return false;
          }
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}

int decimaSuperior(int num) {
  return (num - num % 10 + 10);
}

//Validar telefono celular y convencional
bool verificarTelefono(String telefono) {
  if (int.parse(telefono[0]) == 9 && telefono.length == 9) {
    return true;
  } else {
    return false;
  }
}

Future<bool> validarCorreoExistente(String correo) async {
  AuthProvider authProviderAlwaysAdmin;
  authProviderAlwaysAdmin = AuthProvider();
  // var emailVerificate =
  //     await authProviderAlwaysAdmin.getEmailVerificate(correo, 1);
  // if (emailVerificate != null) {
  //   if (emailVerificate["search_read"].toString().contains("ok") &&
  //       emailVerificate["active"]) {
  //     await authProviderAlwaysAdmin.signOut();
  //     return true;
  //   } else {
      
  //       await authProviderAlwaysAdmin.signOut();
  //       return true;
  //     }
  //   }
  
  return false;
}

Future<bool> validarSiConductor(String correo) async {
  Prefs prefs = Prefs();
  AuthProvider authProviderAlwaysAdmin;
  authProviderAlwaysAdmin = AuthProvider();
  // var emailVerificate =
  //     await authProviderAlwaysAdmin.getEmailVerificate(correo, 1);
  // if (emailVerificate != null) {
  //   if (emailVerificate["search_read"].toString().contains("ok") &&
  //       emailVerificate["active"]) {
  //     prefs.idUser = int.parse(emailVerificate["id"].toString());
  //     await authProviderAlwaysAdmin.signOut();
  //     return true;
  //   } else {
     
  //       await authProviderAlwaysAdmin.signOut();
  //       return false;
  //     }
    
  // }
  return false;
}

Future<bool> validarCedulaExistente(String cedula) async {
  AuthProvider authProvider =
      AuthProvider(); //AuthProvider(odooClient: OdooClient(LOCAL_BASE_URL));
  // UserInfoOdoo? result =
  //     await authProvider.searchUserByIdentifierOrIDApiIdentifier(cedula, 1);
  // if (result != null) {
  //   return result.validateCI;
  // }
  return false;
}

// Future<bool> validarTelefonoExistente(String phone) async {
//   AuthProvider authProviderAlwaysAdmin;
//   authProviderAlwaysAdmin = AuthProvider();
//   final result = await authProviderAlwaysAdmin.getPhoneVerificate("+593$phone");

//   return result;
// }
