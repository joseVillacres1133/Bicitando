import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final Icon icon;
  final String hintText;
  final TextEditingController? controller;
  final bool isValid;
  final String errorMessage;
  final TextInputType? keyboardType;

  const TextFieldWidget(
      {super.key,
      required this.icon,
      required this.hintText,
      this.controller,
      required this.isValid,
      required this.errorMessage,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        margin: const EdgeInsets.symmetric( horizontal: 5.00),
        decoration: BoxDecoration(
          //color: Colors.grey[100], // Color de fondo gris
          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        ), 
        child: 
      Row(
        children: <Widget>[
          icon,
          const SizedBox(
              width: 10.0), // Espacio entre el icono y el TextFormField
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                //hintText: hintText,
                label:Text(hintText),
                // border: InputBorder
                //     .none, // Sin borde alrededor del TextFormField
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) {
                if (!isValid) {
                  //return errorMessage;
                }
              },
            ),
          ),
        ],
      ),
        ),if (!isValid && errorMessage != null) // Mostrar mensaje de error solo si no es válido y hay un mensaje de error
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 1.0),
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12.0,
          ),
        ),
      ),
    ]
    );
  }


}
