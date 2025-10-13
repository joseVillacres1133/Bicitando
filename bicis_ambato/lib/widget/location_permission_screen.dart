import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    setState(() => _isLoading = true);
    try {
      final status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        await _getCurrentLocationAndFinish();
      } else {
        final newStatus = await Permission.locationWhenInUse.request();
        if (newStatus.isGranted) {
          await _getCurrentLocationAndFinish();
        } else if (newStatus.isPermanentlyDenied) {
          _showSettingsDialog();
        } else {
          _setDefaultLocationAndFinish();
        }
      }
    } catch (e) {
      debugPrint('Error solicitando permisos de ubicación: $e');
      _setDefaultLocationAndFinish();
    }
    setState(() => _isLoading = false);
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
          ? (placemarks.first.locality ?? 'Ciudad desconocida')
          : 'Ciudad desconocida';

      widget.onLocationGranted(
        position.latitude.toString(),
        position.longitude.toString(),
        city,
      );
    } catch (e) {
      debugPrint('Error obteniendo ubicación: $e');
      _setDefaultLocationAndFinish();
    }
  }

  void _setDefaultLocationAndFinish() {
    widget.onLocationGranted("-1.2544", "-78.6267", "Ambato");
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos requeridos'),
        content: const Text(
          'Para una mejor experiencia, habilita los permisos de ubicación en la configuración.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _setDefaultLocationAndFinish();
            },
            child: const Text('Usar ubicación aproximada'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
              _setDefaultLocationAndFinish();
            },
            child: const Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1) Detectamos el modo claro/oscuro
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 2) Elegimos el logo correspondiente
    final logoProvider = ExactAssetImage(
      isDark ? img_logo_blanco : img_logo,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Fondo: imagen o degradado
          Positioned.fill(
            child: widget.backgroundImage != null
                ? Image.asset(widget.backgroundImage!, fit: BoxFit.cover)
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.8),
                          Theme.of(context).primaryColor,
                        ],
                      ),
                    ),
                  ),
          ),

          // Logo en la parte superior
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image(
                image: logoProvider,
                width: 100,
              ),
            ),
          ),

          // Contenido principal animado
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                size: 80,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              '📍 Ubicación',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Necesitamos tu ubicación para mostrarte las paradas de bicicletas más cercanas y ofrecerte la mejor experiencia.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    height: 1.5,
                                  ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.security,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Tu ubicación se procesa de forma segura y no se comparten con terceros.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_isLoading)
                            Column(
                              children: const [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Obteniendo tu ubicación...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          else ...[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _requestLocationPermission,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                child: const Text(
                                  'Permitir acceso a ubicación',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: widget.onLocationDenied,
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.white.withOpacity(0.8),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  'Usar ubicación aproximada (Ambato)',
                                  style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
