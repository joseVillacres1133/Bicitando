// import 'package:flutter/material.dart';
// import 'package:share_whatsapp/share_whatsapp.dart';

// class DocumentVerificationScreen extends StatefulWidget {
//     final XFile frontImage;
//   final XFile backImage;

//     const DocumentVerificationScreen({
//     Key? key,
//     required this.frontImage,
//     required this.backImage,
//   }) : super(key: key);

//     @override
//   Widget build(BuildContext context) {
//     return ;
//   }
  
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return Scaffold();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({Key? key}) : super(key: key);

  @override
  _DocumentVerificationScreenState createState() => _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState extends State<DocumentVerificationScreen> {
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickDocumentImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _sendImageToServer() async {
    setState(() {
      _isLoading = true;
    });

    // Simula el envío al servidor (reemplaza por tu lógica real)
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Muestra feedback al usuario (ajusta según tu flujo real)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Documento enviado correctamente.')),
    );

    // Navega o cambia de estado si es necesario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verificación de Documento")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _selectedImage == null
                      ? Text('No hay imagen seleccionada')
                      : Image.file(File(_selectedImage!.path), width: 220, height: 320, fit: BoxFit.cover),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedImage != null) ...[
                        ElevatedButton.icon(
                          onPressed: _sendImageToServer,
                          icon: Icon(Icons.check),
                          label: Text('Confirmar'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          icon: Icon(Icons.refresh),
                          label: Text('Cambiar'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: _selectedImage == null
          ? FloatingActionButton(
              onPressed: _pickDocumentImage,
              child: Icon(Icons.camera_alt),
              tooltip: "Tomar foto",
            )
          : null,
    );
  }
}
