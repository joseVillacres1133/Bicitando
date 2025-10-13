import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPrePermission extends StatelessWidget {
  final VoidCallback onGranted;
  final VoidCallback onDenied;
  final String? title;
  final String? content;

  const CameraPrePermission({
    Key? key,
    required this.onGranted,
    required this.onDenied,
    this.title,
    this.content,
  }) : super(key: key);

  Future<void> _requestPermission(BuildContext ctx) async {
    // 1) Cierra el diálogo personalizado
    Navigator.of(ctx).pop();

    try {
      // 2) Verificar estado actual del permiso
      final currentStatus = await Permission.camera.status;
      
      if (currentStatus.isGranted) {
        onGranted();
        return;
      }

      // 3) (aparece el diálogo nativo)
      print('📱 Mostrando diálogo nativo de Android para cámara...');
      final status = await Permission.camera.request();

      if (status.isGranted) {
        print('Permisos de cámara concedidos');
        onGranted();
      } else if (status.isDenied) {
        print('Permisos de cámara denegados');
        onDenied();
      } else if (status.isPermanentlyDenied) {
        // Mostrar diálogo para ir a configuración
        _showSettingsDialog(ctx);
      }
    } catch (e) {
      print('Error en _requestPermission cámara: $e');
      onDenied();
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permisos de cámara requeridos'),
        content: Text(
            'Los permisos de cámara han sido permanentemente denegados. '
            'Por favor, habilítalos en la configuración de la aplicación para poder tomar fotos.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDenied();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
              onDenied(); // Por si no cambia los permisos
            },
            child: Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Permite acceso a tu cámara'),
      content: Text(
        content ?? 
        'Bicitando necesita acceso a tu cámara para tomar fotos de documentos '
        'y verificar tu identidad. Las fotos se procesan de forma segura.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDenied();
          },
          child: Text('No, gracias'),
        ),
        ElevatedButton(
          onPressed: () => _requestPermission(context),
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}