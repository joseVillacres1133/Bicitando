import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/login/login_bloc.dart';
import '../data/repository.dart';
import '../style/style.dart';
import '../widget/auth/login/login_form.dart';

//Construccion de la Page de Login
class LoginScreen extends StatefulWidget {
  final Repository? _repository;
  final BuildContext? _context;

  LoginScreen(
      {super.key,
      @required Repository? repository,
      @required BuildContext? context})
      : assert(repository != null),
        _repository = repository!,
        _context = context!;

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc? _loginBloc;

  Repository get _repository => widget._repository!;
  BuildContext get _context => widget._context!;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(repository: _repository, context: _context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
          create: ((context) => _loginBloc!),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(184, 37, 182, 235), // Color.fromARGB(255, 225, 245, 253), // bottom color,
                  Color.fromARGB(184, 198, 240, 255), // Color.fromARGB(255, 225, 245, 253), // bottom color,
                  Color.fromARGB(195, 247, 251, 255),
                  //Color.fromARGB(255, 127, 196, 253), // top color

                  // Color.fromARGB(255, 158, 228, 255), // bottom color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: LoginForm(repository: _repository),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc!.close();
  }
}
