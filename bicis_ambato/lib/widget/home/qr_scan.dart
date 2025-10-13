import 'dart:io';
import 'package:bicis_ambato/data/models/odoo/StopsAVehicle.dart';
import 'package:bicis_ambato/style/style.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRViewScan extends StatefulWidget {
  final GeoStation geoStation;
  const QRViewScan(this.geoStation, {Key? key}) : super(key: key);

  @override
  State<QRViewScan> createState() => _QRViewScanState();
}

class _QRViewScanState extends State<QRViewScan> {
  final MobileScannerController _controller = MobileScannerController();
  BarcodeCapture? _capture;
  late final GeoStation geoStation;

  @override
  void initState() {
    super.initState();
    geoStation = widget.geoStation;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) _controller.stop();
    _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200
        : 300;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              overlayBuilder: (context, constraints) => _ScannerOverlay(
                borderColor: whiteColor,
                borderRadius: 5,
                borderLength: 20,
                borderWidth: 5,
                cutOutSize: scanArea,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(geoStation.name!.toUpperCase()),
                  if (_capture != null)
                    const Icon(Icons.check_circle_rounded, color: appColorgreen)
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await _controller.switchCamera();
                            setState(() {}); // refresca el icono
                          },
                          child: Icon(
                            _controller.value.cameraDirection ==
                                    CameraFacing.front
                                ? Icons.camera_front
                                : Icons.camera_rear,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_capture != null) return;            // evita lecturas múltiples
    setState(() => _capture = capture);

    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code != null) Navigator.of(context).maybePop(code);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Overlay ligero equivalente a QrScannerOverlayShape
class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay({
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
    Key? key,
  }) : super(key: key);

  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      final left = (width - cutOutSize) / 2;
      final top = (height - cutOutSize) / 2;

      return Stack(
        children: [
          // Sombra
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
            child: Stack(children: [
              Container(color: Colors.black54),
              Positioned(
                left: left,
                top: top,
                width: cutOutSize,
                height: cutOutSize,
                child: const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.transparent)),
              ),
            ]),
          ),
          // Bordes
          Positioned(
            left: left,
            top: top,
            width: cutOutSize,
            height: cutOutSize,
            child: CustomPaint(
              painter: _BorderPainter(
                borderColor,
                borderRadius,
                borderLength,
                borderWidth,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter(this.color, this.radius, this.length, this.strokeWidth);

  final Color color;
  final double radius;
  final double length;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();

    // esquina sup-izq
    path.moveTo(0, radius);
    path.arcToPoint(const Offset(0, 0), radius: Radius.circular(radius));
    path.lineTo(length, 0);
    path.moveTo(0, radius);
    path.lineTo(0, length);

    // sup-der
    path.moveTo(size.width - length, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, radius);
    path.moveTo(size.width, radius);
    path.lineTo(size.width, length);

    // inf-izq
    path.moveTo(0, size.height - length);
    path.lineTo(0, size.height);
    path.lineTo(radius, size.height);
    path.moveTo(radius, size.height);
    path.lineTo(length, size.height);

    // inf-der
    path.moveTo(size.width - length, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - radius);
    path.moveTo(size.width, size.height - radius);
    path.lineTo(size.width, size.height - length);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
