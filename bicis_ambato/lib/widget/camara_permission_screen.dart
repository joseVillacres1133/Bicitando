import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Pantalla de solicitud de permisos de cámara
/// Muestra información y luego solicita el permiso NATIVO de iOS automáticamente
/// VERSIÓN FINAL - Usa permission_handler correctamente
class CameraPermissionScreen extends StatefulWidget {
  final VoidCallback onCameraGranted;
  final VoidCallback onCameraDenied;
  final String? backgroundImage;

  const CameraPermissionScreen({
    Key? key,
    required this.onCameraGranted,
    required this.onCameraDenied,
    this.backgroundImage,
  }) : super(key: key);

  @override
  _CameraPermissionScreenState createState() => _CameraPermissionScreenState();
}

class _CameraPermissionScreenState extends State<CameraPermissionScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _permissionRequested = false;
  bool _showRetryButtons = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutBack));
    _animationController.forward();

    // CRÍTICO: Solicitar el permiso automáticamente después del primer frame
    // Esto muestra el diálogo NATIVO de iOS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_permissionRequested) {
        _permissionRequested = true;
        _requestCameraPermissionNative();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Detectar cuando el usuario vuelve de los ajustes del sistema
    if (state == AppLifecycleState.resumed && _isProcessing) {
      _checkCameraPermissionAfterSettings();
    }
  }

  /// Solicita el permiso de cámara - ESTO muestra el diálogo NATIVO de iOS
  Future<void> _requestCameraPermissionNative() async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _showRetryButtons = false;
    });

    try {
      final status = await Permission.camera.status;
      
      if (status.isGranted) {
        debugPrint('✅ Permisos de cámara ya concedidos');
        widget.onCameraGranted();
        return;
      }

      // ESTO muestra el diálogo NATIVO de iOS
      debugPrint('📱 Mostrando diálogo NATIVO de iOS para cámara...');
      final newStatus = await Permission.camera.request();
      
      if (newStatus.isGranted) {
        debugPrint('✅ Permisos de cámara concedidos');
        widget.onCameraGranted();
      } else if (newStatus.isPermanentlyDenied) {
        debugPrint('❌ Permisos de cámara permanentemente denegados');
        _showSettingsDialog();
      } else {
        // Usuario denegó o tocó fuera del diálogo
        debugPrint('⚠️ Permisos de cámara denegados o diálogo cerrado');
        _handlePermissionDenied();
      }
    } catch (e) {
      debugPrint('❌ Error al solicitar permisos de cámara: $e');
      _handlePermissionDenied();
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// Maneja el caso cuando el permiso fue denegado o el usuario tocó fuera
  void _handlePermissionDenied() {
    if (!mounted) return;
    
    setState(() {
      _showRetryButtons = true;
      _isProcessing = false;
    });
  }

  /// Verifica el permiso después de volver de los ajustes
  Future<void> _checkCameraPermissionAfterSettings() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      debugPrint('✅ Permisos concedidos desde ajustes');
      widget.onCameraGranted();
    } else {
      setState(() {
        _showRetryButtons = true;
        _isProcessing = false;
      });
    }
  }

  /// Muestra diálogo para ir a ajustes cuando el permiso está permanentemente denegado
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos de cámara requeridos'),
        content: const Text(
          'Los permisos de cámara están permanentemente denegados. '
          'Puedes habilitarlos en la configuración de tu dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onCameraDenied();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
              widget.onCameraDenied();
            },
            child: const Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoProvider = ExactAssetImage(
      isDark ? img_logo_blanco : img_logo,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: widget.backgroundImage != null
                ? Image.asset(
                    widget.backgroundImage!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade800,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
          ),

          // Capa semitransparente
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // Contenido
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image(image: logoProvider),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Icono de cámara
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Título
                        const Text(
                          'Acceso a la cámara',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Descripción
                        const Text(
                          'Necesitamos acceso a tu cámara para escanear códigos QR '
                          'de las bicicletas y verificar tu identidad.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Beneficios
                        _buildFeatureRow(
                          Icons.qr_code_scanner,
                          'Escanea códigos QR de bicicletas',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureRow(
                          Icons.verified_user,
                          'Verifica tu identidad de forma segura',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureRow(
                          Icons.lock,
                          'Tus fotos no se comparten con terceros',
                        ),
                        const SizedBox(height: 40),

                        // Estado: Procesando o Botones de reintento
                        if (_isProcessing && !_showRetryButtons)
                          // Indicador de carga
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  'Solicitando permiso...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (_showRetryButtons)
                          // Botones cuando se toca fuera o se deniega
                          Column(
                            children: [
                              // Botón: Permitir cámara
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _requestCameraPermissionNative,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Permitir cámara'),
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
                              
                              // Botón: Continuar sin cámara
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: widget.onCameraDenied,
                                  icon: const Icon(Icons.close),
                                  label: const Text('Continuar sin cámara'),
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
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}