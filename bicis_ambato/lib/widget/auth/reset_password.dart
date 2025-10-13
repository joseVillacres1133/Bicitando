// ignore_for_file: library_private_types_in_public_api

import 'package:bicis_ambato/style/style.dart';
import 'package:flutter/material.dart';


import '../../utils/constants_msg.dart';

//Creación del botton personalizado para reset
class ResetPasswordButton extends StatefulWidget {
  final String? email;
  const ResetPasswordButton({Key? key, this.email}) : super(key: key);

  @override
  _ResetPasswordButtonState createState() => _ResetPasswordButtonState();
}

class _ResetPasswordButtonState extends State<ResetPasswordButton> {
  
  //String? get str_forget_pwd => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(clipBehavior: Clip.none,
            onPressed: () {
                      Navigator.pushReplacementNamed(context, "sentReset");
            },
            child: Text(str_forget_pwd, style: TextStyle(color: secondary,fontSize: 15),),
            
          ),
        
        ],
      ),
      onTap: () {
      },
    );
  }
}
