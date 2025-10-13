import 'package:bicis_ambato/style/style.dart';
import 'package:bicis_ambato/utils/constants_msg.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

// ✅ CLASE TEMPORAL: Solo para mostrar el splash y luego terminar
class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Image.asset(img_logo),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(img_logo), // Imagen de Splash

      splashTransition: SplashTransition.fadeTransition, // Tipo de transición
      pageTransitionType: PageTransitionType
          .rightToLeftWithFade, // Tipo de transición de la página siguiente

      // ✅ CAMBIO: En lugar de ir a MainPage, vamos a una pantalla temporal
      // que inmediatamente redirige al flujo principal de MyApp
      nextScreen: const _SplashNavigator(),

      duration: 500, // Duración en milisegundos
      backgroundColor: whiteColor, // Color de fondo
    );
  }
}

// ✅ NUEVA CLASE: Navegador que redirige al flujo principal
class _SplashNavigator extends StatefulWidget {
  const _SplashNavigator();

  @override
  State<_SplashNavigator> createState() => _SplashNavigatorState();
}

class _SplashNavigatorState extends State<_SplashNavigator> {
  @override
  void initState() {
    super.initState();
    // Después del splash, redirigir al flujo principal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushReplacementNamed('main'); // Ir al home (flujo principal)
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar loading mientras redirige
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(img_logo),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
