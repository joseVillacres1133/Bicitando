import 'dart:io';
import 'dart:typed_data';

import 'package:bicis_ambato/data/auth_provider.dart';
import 'package:bicis_ambato/utils/sharedprefs_helper.dart';
import 'package:bicis_ambato/views/document_verification_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DocumentIndicationsScreen extends StatefulWidget {
  AuthProvider? repository;

  DocumentIndicationsScreen({super.key, this.repository})
      : assert(repository != null);

  @override
  _DocumentIndicationsScreenState createState() =>
      _DocumentIndicationsScreenState();
}

class _DocumentIndicationsScreenState extends State<DocumentIndicationsScreen> {
  final _prefs = Prefs();
  late final List<CameraDescription> cameras;

  final List<Map<String, dynamic>> _steps = [
    {
      "title": "Prepara tu documento",
      "instructions": "Colócalo sobre una superficie plana y bien iluminada",
      "icon": Icons.lightbulb_outline,
      "path": "assets/images/document_guide01.png"
    },
    {
      "title": "Encuadre del documento",
      "instructions": "Asegúrate que todas las esquinas sean visibles",
      "icon": Icons.crop_free,
      "path": "assets/images/document_guide02.png"
    },
    {
      "title": "Toma foto del ANVERSO",
      "instructions": "Alinea el documento con el marco en pantalla",
      "icon": Icons.camera_alt,
      "isPhotoStep": false,
      "path": "assets/images/anverso.png"
    },
    {
      "title": "Toma foto del ANVERSO",
      "instructions": "Toma foto del ANVERSO",
      "icon": Icons.camera_alt,
      "isPhotoStep": true,
      "path": "assets/document_guide.png"
    },
    {
      "title": "Toma foto del REVERSO",
      "instructions": "Voltea el documento y repite el proceso",
      "icon": Icons.camera_alt,
      "isPhotoStep": false,
      "path": "assets/images/reverso.png"
    },
    {
      "title": "Toma foto del REVERSO",
      "instructions": "Toma foto del REVERSO",
      "icon": Icons.camera_alt,
      "isPhotoStep": true,
      "path": "assets/document_guide.png"
    },
  ];

  int _currentStep = 0;
  XFile? _frontImage;
  XFile? _backImage;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final image = await _cameraController.takePicture();
      final XFile cropped =
          await cropCapturedImageToXFile(image, 100, 200, 300, 300);
      setState(() {
        if (_currentStep == 3) {
          _frontImage = cropped;
        } else {
          _backImage = cropped;
        }
        if (_currentStep == 5) {
          _goToNextStep();
        } else {
          _currentStep++;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al capturar foto: $e')),
      );
    }
  }

  Future<XFile> cropCapturedImageToXFile(
      XFile xfile, int left, int top, int width, int height) async {
    // Leer bytes de la imagen
    Uint8List imageBytes = await xfile.readAsBytes();

    // Decodificar imagen con paquete `image`
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null)
      throw Exception("No se pudo decodificar la imagen");

    // Recortar
    img.Image croppedImage = img.copyCrop(originalImage,
        x: left, y: top, width: width, height: height);

    // Codificar imagen recortada como JPEG
    List<int> jpg = img.encodeJpg(croppedImage);

    // Guardar en archivo temporal
    final tempDir = await getTemporaryDirectory();
    final fileName = path.basenameWithoutExtension(xfile.path) + "_cropped.jpg";
    final croppedFile = File(path.join(tempDir.path, fileName));
    await croppedFile.writeAsBytes(jpg);

    // Convertir a XFile
    return XFile(croppedFile.path);
  }

  void _goToNextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _showCompletionScreen();
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _showCompletionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentVerificationCompleteScreen(
          frontImage: _frontImage!,
          backImage: _backImage!,
          repository: widget.repository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = _steps[_currentStep];

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                'Verificación de Identidad (${_currentStep + 1}/${_steps.length})'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed("edit-profile");
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Perfil"),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildStepContent(currentStepData),
                ),
              ),
              _buildNavigationButtons(currentStepData),
            ],
          ),
        ));
  }

  Widget _buildStepContent(Map<String, dynamic> stepData) {
    if (stepData["isPhotoStep"] == true) {
      return _buildCameraPreview();
    } else {
      return _buildInstructionStep(stepData);
    }
  }

  Widget _buildInstructionStep(Map<String, dynamic> stepData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(stepData["icon"], size: 80, color: Colors.blue),
        const SizedBox(height: 30),
        Text(
          stepData["title"],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          stepData["instructions"],
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Center(
          child: DottedBorder(
            color: Colors.blue,
            strokeWidth: 3,
            dashPattern: [6, 4], // 6px línea, 4px espacio
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: Container(
              height: 180,
              width: 280,
              alignment: Alignment.center,
              child: Image.asset(stepData["path"], width: 250),
            ),
          ),
        ),
        // Tu imagen de ejemplo
      ],
    );
  }

  Widget _buildCameraPreview() {
    if (!_cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CameraPreview(_cameraController),
        _buildDocumentFrame(),
        Positioned(
          bottom: 30,
          child: Text(
            _steps[_currentStep]["instructions"],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              shadows: [Shadow(color: Colors.black, blurRadius: 10)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentFrame() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.55,
    );
  }

  Widget _buildNavigationButtons(Map<String, dynamic> stepData) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            ElevatedButton(
              onPressed: _goToPreviousStep,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Atrás'),
            ),
          ElevatedButton(
            onPressed:
                stepData["isPhotoStep"] == true ? _takePhoto : _goToNextStep,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(stepData["isPhotoStep"] == true
                ? 'Capturar Foto'
                : 'Continuar'),
          ),
        ],
      ),
    );
  }
}

// ------------------- PANTALLA FINAL -------------------
class DocumentVerificationCompleteScreen extends StatelessWidget {
  final XFile frontImage;
  final XFile backImage;
  final AuthProvider? repository;

  DocumentVerificationCompleteScreen({
    super.key,
    required this.frontImage,
    required this.backImage,
    this.repository,
  });

  final prefs = Prefs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación Completa')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              '¡Documentación Completada!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Revisa que las fotos sean claras antes de enviar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildImagePreviews(),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _submitDocuments(context),
              icon: const Icon(Icons.cloud_upload),
              label: const Text('ENVIAR DOCUMENTOS'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviews() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildImagePreview('ANVERSO', frontImage),
        _buildImagePreview('REVERSO', backImage),
      ],
    );
  }

  Widget _buildImagePreview(String label, XFile imageFile) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FutureBuilder(
            future: imageFile.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  void _submitDocuments(BuildContext context) async {
    // Mostrar indicador de carga
    frontImage;
    backImage;

    List<XFile> images = [];
    images.add(frontImage);
    images.add(backImage);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Simular envío (reemplazar con tu lógica real)
    await repository!
        .sendImagesValidation(images, prefs.idUserPartner)
        .then((value) {
      if (value != null) {
        // Navegar a pantalla de éxito
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VerificationSuccessScreen()),
        );
      }
    });
  }
}

// ------------------- PANTALLA DE ÉXITO -------------------
class VerificationSuccessScreen extends StatelessWidget {
  final _prefs = Prefs();
  VerificationSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, size: 100, color: Colors.green),
              const SizedBox(height: 30),
              const Text(
                '¡Documentos enviados con éxito!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Hemos recibido tus documentos correctamente. '
                'Te notificaremos cuando se complete la verificación.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _prefs.verifiedUser = "waiting";
                  Navigator.pushReplacementNamed(context, "profile");
                },
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
