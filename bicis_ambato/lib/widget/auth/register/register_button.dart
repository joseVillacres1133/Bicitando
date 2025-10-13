import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/register/bloc.dart';
import '../../../style/style.dart';
import '../../../utils/constants_msg.dart';

//Construcción del botton personalizado del Register
class RegisterButton extends StatefulWidget {
  final VoidCallback? _onPressed;
  //final User _user;
  //final UserOffline _userOffline;

  const RegisterButton({
    Key? key,
    required VoidCallback onPressed,
    //required User user,
    //required UserOffline userOffline
  })  : _onPressed = onPressed,
        //  _user = user,
        // _userOffline = userOffline,
        super(key: key);

  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

late RegisterBloc _registerBloc;

class _RegisterButtonState extends State<RegisterButton> {
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: MaterialButton(
      color: redColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () => {
        //_registerBloc.add(Submitted(widget._user, widget._userOffline)),
        widget._onPressed
      },
            child: Center(

      child:Text(
        str_create_account,
        textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: poppinsBold(
              // ScreenUtil().setSp(
              //   6,
              // ),
              18, 
              whiteColor),
        ),
      ),
      ),
    );
  }
}
