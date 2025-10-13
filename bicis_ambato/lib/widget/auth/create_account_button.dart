import 'package:flutter/material.dart';

import '../../style/style.dart';
import '../../utils/constants_msg.dart';

//Creación del botton personalizado para register
class CreateAccountButton extends StatefulWidget {
  const CreateAccountButton({super.key});

  @override
  _CreateAccountButtonState createState() => _CreateAccountButtonState();
}

class _CreateAccountButtonState extends State<CreateAccountButton> {

  @override
  void initState() {
    super.initState();// 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: redColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          str_create_account,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: poppinsBold(
              // ScreenUtil().setSp(
              //   6,
              // ),
              15,
              whiteColor),
        ),
      ),
      onPressed: () {
        //Navigator.of(context).pushNamed('register');
        Navigator.pushReplacementNamed(context, 'register');
      },
    );
  }
}
