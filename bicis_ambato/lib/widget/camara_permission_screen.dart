import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionScreen extends StatefulWidget {
  final VoidCallback onCameraGranted;
  final VoidCallback onCameraDenied;
  final String? backgroundImage;
  final bool canSkip;

  const CameraPermissionScreen({
    Key? key,
    required this.onCameraGranted,
    required this.onCameraDenied,
    this.backgroundImage,
    this.canSkip = true,
  }) : super(key: key);

  @override
  _CameraPermissionScreenState createState() => _CameraPermissionScreenState();
}

class _CameraPermissionScreenState extends State<CameraPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutBack));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    setState(() => _isLoading = true);
    try {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        widget.onCameraGranted();
        return;
      }
      final newStatus = await Permission.camera.request();
      if (newStatus.isGranted) {
        widget.onCameraGranted();
      } else if (newStatus.isPermanentlyDenied) {
        _showSettingsDialog();
      } else {
        widget.onCameraDenied();
      }
    } catch (e) {
      debugPrint('Error solicitando permisos de cámara: $e');
      widget.onCameraDenied();
    }
    setState(() => _isLoading = false);
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permisos de cámara requeridos'),
        content: Text(
          'Los permisos de cámara están permanentemente denegados. '
          'Puedes habilitarlos en la configuración de la aplicación.',
        ),
        actions: [
          if (widget.canSkip)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onCameraDenied();
              },
              child: Text('Continuar sin cámara'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
              widget.onCameraDenied();
            },
            child: Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1) Detectamos claro/oscuro
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 2) Elegimos el logo
    final logoProvider = ExactAssetImage(
      isDark ? img_logo_blanco : img_logo,
    );

    return Scaffold(
      body: Stack(
        children: [
          // fondo: imagen o degradado
          Positioned.fill(
            child: widget.backgroundImage != null
                ? Image.asset(widget.backgroundImage!, fit: BoxFit.cover)
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.withOpacity(0.8),
                          Colors.blue.shade700,
                        ],
                      ),
                    ),
                  ),
          ),

          // Logo en la esquina superior
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image(
                image: logoProvider,
                width: 100,
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
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
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 80,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            SizedBox(height: 32),
                            Text(
                              '📸 Cámara',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Necesitamos acceso a tu cámara para tomar fotos de documentos y verificar tu identidad de forma segura.',
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
                                      'Tus fotos se procesan de forma segura y no se comparten con terceros.',
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
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                                SizedBox(height: 16),
                                Text('Configurando permisos...',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )
                          else ...[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _requestCameraPermission,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue.shade700,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                                child: Text('Permitir acceso a cámara',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            if (widget.canSkip) ...[
                              SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: widget.onCameraDenied,
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Colors.white.withOpacity(0.8),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: Text(
                                    'Ahora no (podrás activarlo después)',
                                    style: TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                          ],
                          SizedBox(height: 32),
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
