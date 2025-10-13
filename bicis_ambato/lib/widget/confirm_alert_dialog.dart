import 'package:flutter/material.dart';

class ConfirmAlertDialog {
  static Future<Future<bool?>> show(BuildContext context, String title,
      String content, dynamic confirmAction, dynamic cancelAction) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await confirmAction;
                    // Navigator.of(context)
                    //     .pop(true); // Indica que se aceptó la acción
                  },
                  child: const Icon(Icons.check_circle_outline_rounded),
                ),
                TextButton(
                  onPressed: () async {
                    if (cancelAction != null) {
                    await cancelAction;
                    }else{
                    Navigator.of(context)
                        .pop(false); // Indica que se aceptó la acción
                    }
                  },
                  child: const Icon(Icons.cancel_outlined),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
