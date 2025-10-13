import 'package:flutter/material.dart';

class MessageDialog {
  static void show(BuildContext context, String title, String message,Function aceptMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {  
                aceptMessage();
                Navigator.of(context).pop(); // Cierra el AlertDialog
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
