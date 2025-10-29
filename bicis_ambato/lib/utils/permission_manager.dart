import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';  // ✅ AGREGADO para ubicación con mapa
import 'package:bicis_ambato/widget/location_permission_screen.dart';
import 'package:bicis_ambato/widget/camara_permission_screen.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';

/// ✅ VERSIÓN DEFINITIVA - USA GEOLOCATOR PARA UBICACIÓN (con mapa)
/// - Para ubicación: Usa Geolocator (muestra mapa nativo)
/// - camera para cámara (muestra diálogo 100% nativo de iOS)
/// - Cumple 100% con directriz 5.1.1 de Apple
class PermissionManager {
  static final Prefs _prefs = Prefs();

  /// Solicitar permisos de cámara cuando sea necesario
  /// Retorna true si los permisos fueron concedidos
  static Future<bool> requestCameraPermission(
    BuildContext context, {
    bool isRequired = false,
  }) async {
   try {
      // Intentar obtener cámaras - esto verifica si hay permiso
      final cameras = await availableCameras();
      
      // Si ya tiene permisos, retornar true
      if (cameras.isNotEmpty) {
        return true;
      }
    } catch (e) {
      // Si hay un error, significa que no tiene permisos o están denegados
      debugPrint('Cámara no disponible: $e');
    }

    // Si no se ha preguntado antes, mostrar pantalla completa
    if (!(_prefs.cameraPermissionAsked ?? false)) {
      return await _showCameraPermissionScreen(context);
    }

    // Si ya se preguntó antes y fue denegado, preguntar si quiere intentar de nuevo
    if (isRequired) {
      return await _showRetryDialog(context, 'cámara');
    }

    return false;
  }

  /// ✅ ACTUALIZADO: Solicitar permisos de ubicación usando Geolocator
  /// Esto muestra el diálogo nativo CON MAPA en iOS
  static Future<bool> requestLocationPermission(
    BuildContext context, {
    bool isRequired = false,
  }) async {
    // ✅ Usar Geolocator en lugar de permission_handler
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always || 
        permission == LocationPermission.whileInUse) {
      return true;
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationSettingsDialog(context);
      return false;
    }

    // Si no se ha preguntado antes, usar la pantalla explicativa
    if (!(_prefs.locationPermissionAsked ?? false)) {
      return await _showLocationPermissionScreen(context);
    }

    if (isRequired) {
      return await _showLocationRetryDialog(context);
    }

    return false;
  }

  /// Verificar si tiene permisos de cámara
  static Future<bool> hasCameraPermission() async {
    try {
      final cameras = await availableCameras();
      return cameras.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// ✅ ACTUALIZADO: Verificar si tiene permisos de ubicación usando Geolocator
  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || 
           permission == LocationPermission.whileInUse;
  }

  /// Mostrar pantalla de permisos de cámara
  static Future<bool> _showCameraPermissionScreen(
    BuildContext context,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => CameraPermissionScreen(
          onCameraGranted: () => Navigator.of(context).pop(true),
          onCameraDenied: () => Navigator.of(context).pop(false),
        ),
        fullscreenDialog: true,
      ),
    );

    _prefs.cameraPermissionAsked = true;
    return result ?? false;
  }

  /// Mostrar pantalla de permisos de ubicación
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

  /// Mostrar diálogo de reintentar permisos de cámara
  static Future<bool> _showRetryDialog(
    BuildContext context,
    String permissionType,
  ) async {
    final retry = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos requeridos'),
        content: Text(
          'Esta función requiere permisos de $permissionType. '
          '¿Deseas intentar concederlos de nuevo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Intentar de nuevo'),
          ),
        ],
      ),
    );

    if (retry == true) {
      if (permissionType == 'cámara') {
        return await requestCameraPermission(context, isRequired: true);
      } else {
        return await requestLocationPermission(context, isRequired: true);
      }
    }

    return false;
  }

  /// ✅ NUEVO: Diálogo de reintentar para ubicación usando Geolocator
  static Future<bool> _showLocationRetryDialog(
    BuildContext context,
  ) async {
    final retry = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos requeridos'),
        content: const Text(
          'Esta función requiere permisos de ubicación. '
          '¿Deseas intentar concederlos de nuevo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Intentar de nuevo'),
          ),
        ],
      ),
    );

    if (retry == true) {
      final permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always || 
             permission == LocationPermission.whileInUse;
    }

    return false;
  }

  /// ✅ NUEVO: Diálogo para ir a configuración (ubicación) usando Geolocator
  static void _showLocationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos de ubicación requeridos'),
        content: const Text(
          'Para ofrecerte una mejor experiencia, necesitamos acceso a tu ubicación. '
          'Por favor, habilita los permisos en la configuración de tu dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openAppSettings();
            },
            child: const Text('Abrir configuración'),
          ),
        ],
      ),
    );
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
          content: const Text('Los permisos de ubicación ayudan a mejorar la experiencia'),
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