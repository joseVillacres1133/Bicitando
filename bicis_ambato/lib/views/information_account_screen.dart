import 'package:bicis_ambato/widget/header.dart';
import 'package:bicis_ambato/widget/municipio_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/style.dart';
import '../utils/constants_msg.dart';
import 'package:flutter/services.dart';

class InformationAccountScreen extends StatefulWidget {
  const InformationAccountScreen({super.key});

  @override
  _InformationAccountScreenState createState() =>
      _InformationAccountScreenState();
}

class _InformationAccountScreenState extends State<InformationAccountScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // SIEMPRE íconos claros
        statusBarBrightness: Brightness.light, // Para iOS
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(context, 'profile');
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Encabezado superior
              Header(
                nameScreen: "Eliminación de cuenta",
                route: str_rout_profile,
              ),

              // Contenedor con el contenido completo
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: beige,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildInformationContent(context),
                    ],
                  ),
                ),
              ),

              // Barra inferior del municipio
              const BarMunicipio(),
            ],
          ),
        ),
      ),
    );
  }

  // --- CONTENIDO ---
  Widget _buildInformationContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "¿Cómo eliminar tu cuenta?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Valoramos tu privacidad y te brindamos el control total de tu información personal. Si en algún momento decides cerrar tu cuenta, puedes hacerlo fácilmente siguiendo estos pasos:",
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 30),

        _buildStepCard(
          stepNumber: "1",
          title: "Enviar un correo al soporte",
          description:
              "Como primer paso se deberá enviar un correo de soporte solicitando la eliminación de la cuenta.",
          icon: Icons.email,
          color: purple,
        ),
        const SizedBox(height: 20),

        _buildStepCard(
          stepNumber: "2",
          title: "Asunto y cuerpo del correo",
          description: "",
          icon: Icons.edit_note,
          color: secondary,
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletPoint(
                "Asunto:",
                "Solicitud de eliminación de cuenta",
                isBold: true,
              ),
              const SizedBox(height: 10),
              _buildBulletPoint(
                "Cuerpo:",
                "Indicar claramente que desea eliminar su cuenta y que se eliminen todos sus datos personales asociados. Asegúrese de incluir el correo electrónico vinculado a la cuenta.",
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildStepCard(
          stepNumber: "3",
          title: "Envío del correo y espera la confirmación",
          description:
              "Recibirá una respuesta que confirme la eliminación de la cuenta. El tiempo que normalmente se demora en responder es de 1 a 2 horas en horario laboral.",
          icon: Icons.schedule,
          color: greenColor,
        ),
        const SizedBox(height: 30),

        _buildDataSection(),
        const SizedBox(height: 30),

        _buildMoreInfoButton(context),
      ],
    );
  }

  // --- REUTILIZABLES ---
  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    Widget? customContent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
          if (customContent != null) ...[
            const SizedBox(height: 15),
            customContent,
          ],
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String label, String text, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: redColor, width: 2),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: redColor, size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Datos Eliminados y Conservados",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: redColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Cuando se procesa la solicitud de eliminación, se eliminan de forma permanente los siguientes datos:",
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 15),
          _buildDataItem("Información de perfil"),
          _buildDataItem("Historial de uso y datos de autenticación"),
          _buildDataItem("Datos de apariencia del usuario"),
          _buildDataItem("Preferencias y gustos personales"),
        ],
      ),
    );
  }

  Widget _buildDataItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.delete, color: redColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInfoButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _launchURL(),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        icon: const Icon(Icons.open_in_new, size: 20),
        label: const Text(
          "Más información",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://bicitando.mivilsoft.com/eliminar-cuenta');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el enlace'),
            backgroundColor: redColor,
          ),
        );
      }
    }
  }
}