import 'dart:convert';
import 'dart:developer';

import 'package:bicis_ambato/blocs/app/bloc.dart';
import 'package:bicis_ambato/blocs/app/theme/theme_cubit.dart';
import 'package:bicis_ambato/config/theme/app_theme.dart';
import 'package:bicis_ambato/views/document_indications_screen.dart';
import 'package:bicis_ambato/views/help_screen.dart';
import 'package:bicis_ambato/views/history_screen.dart';
import 'package:bicis_ambato/views/terms_conditions_screen.dart';
// IMPORTAR TUS NUEVAS PANTALLAS
import 'package:bicis_ambato/widget/location_permission_screen.dart';
import 'package:bicis_ambato/widget/camara_permission_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'data/auth_provider.dart';
import 'data/repository.dart';
import 'utils/constants_msg.dart';
import 'utils/sharedprefs_helper.dart';
import 'views/change_password_screen.dart';
import 'views/edit_profile_screen.dart';
import 'views/forgot_password.screen.dart';
import 'views/login_screen.dart';
import 'views/profile_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'views/splash_screen.dart';
import 'widget/auth/resetPassword_form.dart';

//  MAIN FUNCTION CORREGIDA - No bloquear el inicio
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AGREGAR ESTO: Configurar el status bar para que sea visible
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  // Inicializar solo lo esencial de forma síncrona
  final prefs = Prefs();
  await prefs.init();

  runApp(MyApp());
}

// NUEVA ESTRUCTURA: Un solo MaterialApp con todas las rutas
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Prefs? _prefs;
  final Repository _repository =
      Repository(odooClient: OdooClient("https://its.mivilsoft.com"));
  AuthProvider? _repositoryAuth;
  AuthBloc? _authBloc;

  Uint8List? _bytesImage;
  loc.Location location = loc.Location();
  loc.LocationData? _locationData;

  // Variables para controlar la inicialización y flujo de permisos
  bool _isInitializing = true;
  bool _needsLocationPermission = false;
  bool _needsCameraPermission = false;
  bool _permissionsFlowCompleted = false;
  List<CameraDescription>? _cameras;

  final GlobalKey<NavigatorState>? navigatorkey = GlobalKey<NavigatorState>();
  late AppTheme appTheme;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _repositoryAuth = AuthProvider();
    _prefs = Prefs();
    _themeCubit = ThemeCubit();

    _prefs?.clearSession(); // ← para garantizar sesión limpia

    // Inicializar de forma asíncrona SIN bloquear la UI
    _initializeAppAsync();

    _authBloc = AuthBloc(
        repository: _repository,
        authProvider: _repositoryAuth!,
        context: context);
    _authBloc!.add(AppStarted());
    appTheme = AppTheme(isDarkmode: _prefs!.isDarkThemeEnabled);
  }

  // Todas las funciones de inicialización permanecen igual...
  Future<void> _initializeAppAsync() async {
    try {
      print('🚀 Iniciando inicialización asíncrona...');

      await Future.wait([
        _listAvailableCameras(),
        updateImage(),
      ]);

      await _checkPermissionStatus();

      setState(() {
        _isInitializing = false;
      });

      print('✅ Inicialización completada');
    } catch (e) {
      print('❌ Error en inicialización: $e');
      setState(() {
        _isInitializing = false;
        _permissionsFlowCompleted = true;
      });
    }
  }

  Future<void> _checkPermissionStatus() async {
    final locationStatus = await Permission.locationWhenInUse.status;
    final cameraStatus = await Permission.camera.status;

    final locationAsked = _prefs!.locationPermissionAsked ?? false;
    final cameraAsked = _prefs!.cameraPermissionAsked ?? false;

    _needsLocationPermission = !locationStatus.isGranted && !locationAsked;
    _needsCameraPermission = !cameraStatus.isGranted && !cameraAsked;

    if (!_needsLocationPermission && !_needsCameraPermission) {
      _permissionsFlowCompleted = true;

      if (locationStatus.isGranted) {
        await _getCurrentLocationSafe();
      } else {
        _setDefaultLocation();
      }
    }

    print(
        '🔍 Estado permisos - Ubicación: $_needsLocationPermission, Cámara: $_needsCameraPermission');
  }

  Future<Uint8List> cargarImagen(String ruta) async {
    ByteData data = await rootBundle.load(ruta);
    return data.buffer.asUint8List();
  }

  Future<void> updateImage() async {
    try {
      if (_prefs!.requireUserPhoto != str_false) {
        String imgOcupar = _prefs!.requireUserPhoto.toString();
        _bytesImage = const Base64Decoder().convert(imgOcupar);
      } else {
        _bytesImage = await cargarImagen('assets/user.png');
      }
    } catch (e) {
      print('❌ Error cargando imagen: $e');
    }
  }

  Future<void> _getCurrentLocationSafe() async {
    try {
      print('📍 Obteniendo ubicación actual...');

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      );

      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
                position.latitude, position.longitude)
            .timeout(const Duration(seconds: 5));

        _prefs!.latitud = position.latitude.toString();
        _prefs!.longitud = position.longitude.toString();
        _prefs!.cityOrigen = placemarks.isNotEmpty
            ? (placemarks.first.locality ?? 'Ciudad desconocida')
            : 'Ciudad desconocida';

        print('✅ Ubicación obtenida: ${_prefs!.cityOrigen}');
      }
    } catch (e) {
      print('❌ Error obteniendo ubicación: $e');
      _setDefaultLocation();
    }
  }

  // CALLBACKS PARA LAS PANTALLAS DE PERMISOS
  void _onLocationPermissionGranted(String lat, String lng, String city) {
    print('✅ Permisos de ubicación concedidos');
    _prefs!.latitud = lat;
    _prefs!.longitud = lng;
    _prefs!.cityOrigen = city;
    _prefs!.locationPermissionAsked = true;

    setState(() {
      _needsLocationPermission = false;
    });

    _checkIfPermissionsCompleted();
  }

  void _onLocationPermissionDenied() {
    print('❌ Permisos de ubicación denegados - usando ubicación por defecto');
    _setDefaultLocation();
    _prefs!.locationPermissionAsked = true;

    setState(() {
      _needsLocationPermission = false;
    });

    _checkIfPermissionsCompleted();
  }

  void _onCameraPermissionGranted() {
    print('✅ Permisos de cámara concedidos');
    _prefs!.cameraPermissionAsked = true;

    setState(() {
      _needsCameraPermission = false;
    });

    _checkIfPermissionsCompleted();
  }

  void _onCameraPermissionDenied() {
    print('❌ Permisos de cámara denegados');
    _prefs!.cameraPermissionAsked = true;

    setState(() {
      _needsCameraPermission = false;
    });

    _checkIfPermissionsCompleted();
  }

  void _checkIfPermissionsCompleted() {
    if (!_needsLocationPermission && !_needsCameraPermission) {
      setState(() {
        _permissionsFlowCompleted = true;
      });
      print('🎉 Flujo de permisos completado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _themeCubit),
        BlocProvider(create: (_) => _authBloc!),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        bloc: _themeCubit,
        builder: (context, isDarkMode) {
          _themeCubit.emit(_prefs!.isDarkThemeEnabled);

          return MaterialApp(
            
            title: 'Ambato en bici',
            navigatorKey: navigatorkey,
            theme: appTheme.getThemeData(isDarkMode),
            debugShowCheckedModeBanner: false,

            // ✅ TODAS LAS RUTAS EN UN SOLO LUGAR
            routes: {
              'main': (ctx) => _buildCurrentScreen(), // Ruta principal
              'login': (ctx) =>
                  LoginScreen(repository: _repository, context: ctx),
              'history': (ctx) =>
                  HistoryScreen(repository: _repository, context: ctx),
              'terms': (ctx) =>
                  TermsConditionsScreen(repository: _repository, context: ctx),
              'help': (ctx) =>
                  HelpScreen(repository: _repository, context: ctx),
              'home': (ctx) => HomeScreen(
                    functionUpdate: updateImage,
                    repository: _repository,
                    longitud: double.tryParse(_prefs!.longitud ?? '') ?? 0.0,
                    latitud: double.tryParse(_prefs!.latitud ?? '') ?? 0.0,
                  ),
              'register': (ctx) => RegisterScreen(repository: _repository),
              'resetPass': (ctx) => ResetPasswordForm(
                    email: _prefs!.email,
                    oldPass: _prefs!.secret,
                  ),
              'sentReset': (ctx) =>
                  ForgotPasswordScreen(repository: _repository, context: ctx),
              'profile': (ctx) => ProfileScreen(
                  repository: _repositoryAuth, bytesImage: _bytesImage),
              'edit-profile': (ctx) => EditProfileScreen(
                  repository: _repositoryAuth,
                  context: ctx,
                  bytesImage: _bytesImage),
              'change-psswd': (ctx) => const ChangePasswordScreen(),
              'upload-file': (ctx) =>
                  DocumentIndicationsScreen(repository: _repositoryAuth),
            },

            // ✅ MOSTRAR EL SPLASH SCREEN PRIMERO
            home: const SplashScreen(),
          );
        },
      ),
    );
  }

  // NUEVA FUNCIÓN: Construir la pantalla actual según el estado
  Widget _buildCurrentScreen() {
    // 1. Mostrar pantalla de carga durante inicialización
    if (_isInitializing) {
      return _buildLoadingScreen();
    }

    // 2. Mostrar pantallas de permisos si es necesario
    if (!_permissionsFlowCompleted) {
      if (_needsLocationPermission) {
        return LocationPermissionScreen(
          onLocationGranted: _onLocationPermissionGranted,
          onLocationDenied: _onLocationPermissionDenied,
        );
      }

      if (_needsCameraPermission) {
        return CameraPermissionScreen(
          onCameraGranted: _onCameraPermissionGranted,
          onCameraDenied: _onCameraPermissionDenied,
          canSkip: true,
        );
      }
    }

    // 3. Una vez completados los permisos, mostrar la app normal
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (ctx, state) {
        if (state is Authenticated) {
          return HomeScreen(
            repository: _repository,
            latitud: double.tryParse(_prefs!.latitud ?? '') ?? 0.0,
            longitud: double.tryParse(_prefs!.longitud ?? '') ?? 0.0,
          );
        } else if (state is Unauthenticated) {
          return LoginScreen(repository: _repository, context: ctx);
        } else {
          return RegisterScreen(repository: _repository);
        }
      },
    );
  }

  // Valores por defecto si no hay permisos
  void _setDefaultLocation() {
    _prefs!.latitud = "-1.2544";
    _prefs!.longitud = "-78.6267";
    _prefs!.cityOrigen = "Ambato";
    print(
        '📍 Usando ubicación aproximada de Ambato: lat=-1.2544, lng=-78.6267');
  }

  // Pantalla de carga mientras inicializa
  Widget _buildLoadingScreen() {
    final bikeProvider = ExactAssetImage(img_bike);

    return Scaffold(
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image(
                  image: bikeProvider,
                  width: 200,
                ),
              ),
              SizedBox(height: 32),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Inicializando Bicitando...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Por favor espere',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _listAvailableCameras() async {
    try {
      _cameras = await availableCameras();
      print('📸 Cámaras encontradas: ${_cameras?.length}');
    } catch (e) {
      print('❌ Error listando cámaras: $e');
    }
  }

  Future<bool> requestCameraPermissionWhenNeeded() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      print('✅ Cámara ya disponible');
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showCameraSettingsDialog();
      return false;
    }

    if (!(_prefs!.cameraPermissionAsked ?? false)) {
      return await _showCameraPermissionScreenModal();
    }

    return false;
  }

  Future<bool> _showCameraPermissionScreenModal() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => CameraPermissionScreen(
          onCameraGranted: () {
            Navigator.of(context).pop(true);
          },
          onCameraDenied: () {
            Navigator.of(context).pop(false);
          },
          canSkip: false,
        ),
      ),
    );

    _prefs!.cameraPermissionAsked = true;
    return result ?? false;
  }

  void _showCameraSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permisos de cámara requeridos'),
        content: Text('Los permisos de cámara están permanentemente denegados. '
            'Por favor, habilítalos en la configuración de la aplicación.'),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      print('🧹 App cerrándose. Limpiando sesión...');
      _prefs?.sessionId = '';
      _prefs?.idUser = 0;
      _prefs?.idUserPartner = 0;
    }
  }

  @override
  void dispose() {
    _authBloc?.close();
    _themeCubit.close();
    super.dispose();
  }
}
