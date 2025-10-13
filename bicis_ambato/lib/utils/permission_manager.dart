import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bicis_ambato/widget/location_permission_screen.dart';
import 'package:bicis_ambato/widget/camara_permission_screen.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';

/// Clase utilitaria para gestionar permisos en toda la aplicación
class PermissionManager {
  static final Prefs _prefs = Prefs();

  /// Solicitar permisos de cámara cuando sea necesario
  /// Retorna true si los permisos fueron concedidos
  static Future<bool> requestCameraPermission(
    BuildContext context, {
    bool isRequired = false,
  }) async {
    final status = await Permission.camera.status;

    // Si ya tiene permisos, retornar true
    if (status.isGranted) {
      return true;
    }

    // Si están permanentemente denegados, mostrar diálogo de configuración
    if (status.isPermanentlyDenied) {
      _showSettingsDialog(
        context,
        title: 'Permisos de cámara requeridos',
        content: 'Los permisos de cámara están permanentemente denegados. '
            'Por favor, habilítalos en la configuración de la aplicación.',
      );
      return false;
    }

    // Si no se ha preguntado antes, mostrar pantalla completa
    if (!(_prefs.cameraPermissionAsked ?? false)) {
      return await _showCameraPermissionScreen(context, isRequired);
    }

    // Si ya se preguntó antes y fue denegado, preguntar si quiere intentar de nuevo
    if (isRequired) {
      return await _showRetryDialog(context, 'cámara');
    }

    return false;
  }

  /// Solicitar permisos de ubicación cuando sea necesario
  static Future<bool> requestLocationPermission(
    BuildContext context, {
    bool isRequired = false,
  }) async {
    final status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showSettingsDialog(
        context,
        title: 'Permisos de ubicación requeridos',
        content: 'Los permisos de ubicación están permanentemente denegados. '
            'Por favor, habilítalos en la configuración de la aplicación.',
      );
      return false;
    }

    if (!(_prefs.locationPermissionAsked ?? false)) {
      return await _showLocationPermissionScreen(context);
    }

    if (isRequired) {
      return await _showRetryDialog(context, 'ubicación');
    }

    return false;
  }

  /// Verificar si tiene permisos de cámara
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Verificar si tiene permisos de ubicación
  static Future<bool> hasLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  /// Mostrar pantalla de permisos de cámara como modal
  static Future<bool> _showCameraPermissionScreen(
    BuildContext context,
    bool isRequired,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => CameraPermissionScreen(
          onCameraGranted: () => Navigator.of(context).pop(true),
          onCameraDenied: () => Navigator.of(context).pop(false),
          canSkip: !isRequired,
        ),
        fullscreenDialog: true,
      ),
    );

    _prefs.cameraPermissionAsked = true;
    return result ?? false;
  }

  /// Mostrar pantalla de permisos de ubicación como modal
  static Future<bool> _showLocationPermissionScreen(
    BuildContext context,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => LocationPermissionScreen(
          onLocationGranted: (lat, lng, city) {
            _prefs.latitud = lat;
            _prefs.longitud = lng;
            _prefs.cityOrigen = city;
            Navigator.of(context).pop(true);
          },
          onLocationDenied: () => Navigator.of(context).pop(false),
        ),
        fullscreenDialog: true,
      ),
    );

    _prefs.locationPermissionAsked = true;
    return result ?? false;
  }

  /// Mostrar diálogo de reintentar permisos
  static Future<bool> _showRetryDialog(
    BuildContext context,
    String permissionType,
  ) async {
    final retry = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permisos requeridos'),
        content: Text(
          'Esta función requiere permisos de $permissionType. '
          '¿Quieres intentar concederlos de nuevo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Intentar de nuevo'),
          ),
        ],
      ),
    );

    if (retry == true) {
      if (permissionType == 'cámara') {
        final status = await Permission.camera.request();
        return status.isGranted;
      } else if (permissionType == 'ubicación') {
        final status = await Permission.locationWhenInUse.request();
        return status.isGranted;
      }
    }

    return false;
  }

  /// Mostrar diálogo para ir a configuración
  static void _showSettingsDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  /// Función de conveniencia para usar en botones de cámara
  static Future<bool> checkCameraForPhotoCapture(BuildContext context) async {
    final hasPermission = await requestCameraPermission(
      context,
      isRequired: true,
    );

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Se necesitan permisos de cámara para tomar fotos'),
          action: SnackBarAction(
            label: 'Configuración',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }

    return hasPermission;
  }

  /// Función de conveniencia para verificar ubicación
  static Future<bool> checkLocationForMaps(BuildContext context) async {
    final hasPermission = await requestLocationPermission(
      context,
      isRequired: false,
    );

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Los permisos de ubicación ayudan a mejorar la experiencia'),
          action: SnackBarAction(
            label: 'Permitir',
            onPressed: () => requestLocationPermission(context),
          ),
        ),
      );
    }

    return hasPermission;
  }
}
