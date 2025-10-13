//Clase para validar la estructura de cada variable del modelo User
// ignore_for_file: unused_field

class Validators {
  //RegExp permite delimitar que caracters podemos utilizar en cada texto que se escribe
  //Para verificar si la expresion regular es correcta
  //Ingresa aqui: https://regex101.com/

  static final RegExp _emailRegExp = RegExp(
    // r'^[a-zA-Z0-9.!#$%&’*+\=?^_`{|}~-]+@[a-zA-Z0-9]+(?:\.[com | net]{3})$',
    r'^[a-zA-Z0-9!#$%&’*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&’*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$',
  );
  static final RegExp _decimalRegExp = RegExp(
    r'^([0-9]{1,})+(\.[0-9]{1,})$',
  );

  static final RegExp _enteroRegExp = RegExp(
    r'^([0-9]{1,})$',
  );
  static final RegExp _fingerprintCodeRegExp = RegExp(
    r'^([A-Z]{1})+([0-9]{4})+([A-Z]{1})+([0-9]{4})$',
  );

  static final RegExp _cedulaRegExp = RegExp(
    r'^[0-9]{10}$',
  );

  static final RegExp _rucRegExp = RegExp(
    r'^[0-9]{13}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^[0-9]{10}$',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*[A-Z])(?=.*\d)(?=.*[+!@#\$%^&*])[A-Za-z\-*_\=?!+@#$\/(){}=.,;:\d]{8,}$',
    //'^(?=.*[A-Za-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#\$%^&*])[A-Za-z\\-*_=?!@#\$%^&*(){}=.,;:\\d]{8,}$'
  );

  static isValidEmail(String email) {
    //hasMatch para aplicar la RegExp construida
    bool value = _emailRegExp.hasMatch(email);
    return value;
  }

  static isValidDecimal(String decimal) {
    //hasMatch para aplicar la RegExp construida
    if (double.parse(decimal) > 0.0 && double.parse(decimal) <= 99.99) {
      return true;
    }
    return false;
    /*if (_decimalRegExp.hasMatch(decimal)) {
     
      return true;
    } else {
      return false; //_enteroRegExp.hasMatch(decimal);
    }*/
  }

  static isValidDecimalPre(String decimal) {
    //hasMatch para aplicar la RegExp construida
    if (double.parse(decimal) > 0.0 && double.parse(decimal) <= 9999.99) {
      return true;
    }
    return false;
    /*if (_decimalRegExp.hasMatch(decimal)) {
     
      return true;
    } else {
      return false; //_enteroRegExp.hasMatch(decimal);
    }*/
  }

  static isValidCedula(String cedula) {
    return _cedulaRegExp.hasMatch(cedula);
  }

  static isValidDocumento(String cedula) {
    if (_cedulaRegExp.hasMatch(cedula)) {
      return true;
    } else if (_rucRegExp.hasMatch(cedula)) {
      return true;
    } else {
      return false;
    }
  }

  static isValidRuc(String cedula) {
    return _rucRegExp.hasMatch(cedula);
  }

  static isValidPhone(String phone) {
    if (_phoneRegExp.hasMatch(phone)) {
      if (int.parse(phone[0]) == 0 && phone.length == 10) {
        if (int.parse(phone[1]) == 9 && phone.length == 10) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
    return false;
  }

  static isValidName(String name) {
    return name.length >= 5 ? true : false;
  }

  static isValidPassword(String password) {
      if (password.length >= 8) {
      return true;
    } else {
      //return _passwordRegExp.hasMatch(password);
      return false;
    }
    //var result = _passwordRegExp.hasMatch(password);
    //print(result);
    //return _passwordRegExp.hasMatch(password);
  }

  /*static isValidPasswordL(String password) {
    if (password.length == 5) {
      return true;
    } else {
      return _passwordRegExp.hasMatch(password);
    }
  }*/

  static isValidFingerprintCode(String fingerprintCode) {
    return _fingerprintCodeRegExp.hasMatch(fingerprintCode);
  }

  static isValidPasswordConfirmOldChangeValue(
      String oldPassword, String secret) {
    return secret.toString() == oldPassword.toString();
  }

  static isValidPasswordConfirmOldChange(String oldPassword, String secret) {
    return secret.toString().contains(oldPassword);
  }
}
