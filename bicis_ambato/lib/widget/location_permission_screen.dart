import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// ✅ VERSIÓN DEFINITIVA - USA GEOLOCATOR PARA MOSTRAR DIÁLOGO NATIVO CON MAPA
/// - Muestra el diálogo NATIVO de iOS con vista previa del mapa
/// - Detecta cuando el usuario cierra el diálogo sin responder
/// - Ofrece opciones para continuar
/// - Cumple 100% con directriz 5.1.1 de Apple
class LocationPermissionScreen extends StatefulWidget {
  final Function(String lat, String lng, String city) onLocationGranted;
  final VoidCallback onLocationDenied;
  final String? backgroundImage;

  const LocationPermissionScreen({
    Key? key,
    required this.onLocationGranted,
    required this.onLocationDenied,
    this.backgroundImage,
  }) : super(key: key);

  @override
  _LocationPermissionScreenState createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  bool _permissionRequested = false;
  bool _dialogDismissedWithoutResponse = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();

    // ✅ Solicitar permiso automáticamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_permissionRequested) {
        _permissionRequested = true;
        _requestLocationPermissionWithMap();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  /// ✅ Detecta cuando la app vuelve del background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isLoading) {
      _checkPermissionAfterDialogDismissed();
    }
  }

  /// ✅ Verifica el estado del permiso después de que el diálogo se cierra
  Future<void> _checkPermissionAfterDialogDismissed() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    final permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.always || 
        permission == LocationPermission.whileInUse) {
      // Permiso concedido
      await _getCurrentLocationAndFinish();
    } else if (permission == LocationPermission.deniedForever) {
      // Permanentemente denegado
      setState(() => _isLoading = false);
      _showSettingsDialog();
    } else {
      // Denegado o cerrado sin respuesta
      setState(() {
        _isLoading = false;
        _dialogDismissedWithoutResponse = true;
      });
    }
  }

  /// ✅ MÉTODO CLAVE: Solicita el permiso usando Geolocator
  /// Esto muestra el diálogo NATIVO de iOS CON el mapa
  Future<void> _requestLocationPermissionWithMap() async {
    setState(() {
      _isLoading = true;
      _dialogDismissedWithoutResponse = false;
    });
    
    try {
      // Primero verificar si ya tiene permiso
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.always || 
          permission == LocationPermission.whileInUse) {
        // Ya tiene permiso
        await _getCurrentLocationAndFinish();
        return;
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Permanentemente denegado
        setState(() => _isLoading = false);
        _showSettingsDialog();
        return;
      }
      
      // ✅ SOLICITAR PERMISO - Esto muestra el diálogo NATIVO con mapa
      permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.always || 
          permission == LocationPermission.whileInUse) {
        // Permiso concedido
        await _getCurrentLocationAndFinish();
      } else if (permission == LocationPermission.deniedForever) {
        // Permanentemente denegado
        setState(() => _isLoading = false);
        _showSettingsDialog();
      } else {
        // Denegado o cerrado sin respuesta
        setState(() {
          _isLoading = false;
          _dialogDismissedWithoutResponse = true;
        });
      }
    } catch (e) {
      debugPrint('Error solicitando permisos de ubicación: $e');
      setState(() {
        _isLoading = false;
        _dialogDismissedWithoutResponse = true;
      });
    }
  }

  Future<void> _getCurrentLocationAndFinish() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
      
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 5));

      final city = placemarks.isNotEmpty
          ? (placemarks.first.locality ??
              placemarks.first.administrativeArea ??
              'Ciudad desconocida')
          : 'Ciudad desconocida';

      widget.onLocationGranted(
        position.latitude.toString(),
        position.longitude.toString(),
        city,
      );
    } catch (e) {
      debugPrint('Error obteniendo ubicación actual: $e');
      _setDefaultLocationAndFinish();
    }
  }

  void _setDefaultLocationAndFinish() {
    // Coordenadas predeterminadas de Ambato, Ecuador
    widget.onLocationGranted(
      '-1.2490800',
      '-78.6167500',
      'Ambato',
    );
  }

  /// ✅ Abre los Ajustes del sistema
  void _showSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permisos de ubicación requeridos'),
        content: const Text(
          'Para ofrecerte una mejor experiencia, necesitamos acceso a tu ubicación. '
          'Por favor, habilita los permisos en la configuración de tu dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _setDefaultLocationAndFinish();
            },
            child: const Text('Usar ubicación predeterminada'),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: Scaffold(
        body: Container(
          decoration: widget.backgroundImage != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.backgroundImage!),
                    fit: BoxFit.cover,
                  ),
                )
              : BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade700,
                      Colors.blue.shade900,
                    ],
                  ),
                ),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icono de ubicación
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 80,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Título
                        const Text(
                          'Permisos de Ubicación',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        // Descripción
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Bicitando necesita tu ubicación para:\n\n'
                            '• Mostrarte bicicletas cercanas\n'
                            '• Calcular rutas optimizadas\n'
                            '• Mejorar tu experiencia\n\n'
                            'Tu ubicación no se comparte con terceros.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Estado: Cargando
                        if (_isLoading && !_dialogDismissedWithoutResponse)
                          Column(
                            children: const [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Solicitando permisos...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        
                        // Estado: Diálogo cerrado sin respuesta
                        if (_dialogDismissedWithoutResponse)
                          Column(
                            children: [
                              const Text(
                                '¿Necesitas permitir el acceso a tu ubicación?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              
                              // Botón: Intentar de nuevo
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _requestLocationPermissionWithMap,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Permitir ubicación'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade700,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Botón: Usar ubicación predeterminada
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _setDefaultLocationAndFinish,
                                  icon: const Icon(Icons.location_city),
                                  label: const Text('Usar ubicación predeterminada (Ambato)'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white, width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}