import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Pantalla que muestra una imagen de fondo a pantalla completa
/// y, tras el primer frame, lanza el diálogo de permiso de ubicación.
class FullScreenPermissionPage extends StatefulWidget {
  final String backgroundImage;

  const FullScreenPermissionPage({
    Key? key,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  _FullScreenPermissionPageState createState() =>
      _FullScreenPermissionPageState();
}

class _FullScreenPermissionPageState extends State<FullScreenPermissionPage> {
  bool _permissionDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_permissionDialogShown) {
        _permissionDialogShown = true;
        _showLocationPrePermission();
      }
    });
  }

  Future<void> _showLocationPrePermission() async {
    final accepted = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Permite acceso a tu ubicación'),
            content: Text(
              'Esta aplicación necesita tu ubicación en primer plano para mostrarte mapas y rutas personalizadas. '
              'No compartimos tus datos con terceros.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No, gracias'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Aceptar'),
              ),
            ],
          ),
        ) ??
        false;

    if (accepted) {
      await _requestLocationPermission();
      // Aquí puedes navegar a la siguiente pantalla o iniciar la funcionalidad
    } else {
      // Usuario denegó: puedes mostrar mensaje o cerrar
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      // Permiso concedido: continúa
    } else {
      // Permiso denegado: maneja el caso
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          widget.backgroundImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
