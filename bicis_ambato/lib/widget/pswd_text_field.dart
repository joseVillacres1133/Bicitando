import 'package:flutter/material.dart';

import '../style/style.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  final Icon icon;
  final String hintText;
  final TextEditingController? controller;
  final bool isValid;
  final String errorMessage;
  final TextInputType? keyboardType;
  final bool passwordVisible;

  const PasswordTextFieldWidget(
      {Key? key,
      required this.icon,
      required this.hintText,
      this.controller,
      required this.isValid,
      required this.errorMessage,
      this.keyboardType,
      required this.passwordVisible})
      : super(key: key);

  @override
  _PasswordTextFieldWidgetState createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible =
        widget.passwordVisible; // Inicialmente la contraseña está oculta
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            margin:
                const EdgeInsets.symmetric( horizontal: 5.00),
            decoration: BoxDecoration(
              //color: Colors.grey[100], // Color de fondo gris
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
            ),
            child: Row(
              children: <Widget>[
                widget.icon,
                const SizedBox(
                    width: 10.0), // Espacio entre el icono y el TextFormField
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    decoration: InputDecoration(
                      //hintText: widget.hintText,
                      label: Text(widget.hintText),
                      // border: InputBorder
                      //     .none, // Sin borde alrededor del TextFormField
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      if (!widget.isValid) {
                        //return errorMessage;
                      }
                    },
                    obscureText: _passwordVisible,
                  ),
                ),
                IconButton(
                    color: secondary, // Color del icono
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible!
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ))
              ],
            ),
          ),
          if (!widget.isValid &&
              widget.errorMessage !=
                  null) // Mostrar mensaje de error solo si no es válido y hay un mensaje de error
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 1.0),
              child: Text(
                widget.errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                ),
              ),
            ),
        ]);
  }
}
