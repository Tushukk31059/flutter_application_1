import 'package:flutter/material.dart';
import 'package:flutter_application_1/employeeform.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math';

class Qrdemoapp extends StatelessWidget {
  const Qrdemoapp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Token Registration Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Staff Screen (Show QR)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Student Screen (Scan QR)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScan()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
// <-- apne file ka correct path use karo

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String? scannedCode;
  String? token;

  final MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
  );

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    if (scannedCode != null) return; // prevent duplicate scans

    setState(() {
      scannedCode = barcode.rawValue;
    });

    if (barcode.rawValue == "register_here") {
      final random = Random();
      token =
          "T-${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(9999)}";

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmployeeFormPage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Scan Successful! TokenID: $token")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid QR Code")));
      // reset after delay so user can scan again
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => scannedCode = null);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282C5C),
      body: Stack(
        children: [
          Column(
            children: [
              // --- Scanner area ---
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: _onBarcodeDetected,
                    ),

                    // Scanner overlay
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        child: CustomPaint(
                          painter: ScannerOverlayPainter(
                            boxColor: Color(0xFFF8F9FA),
                            borderRadius: 15.0,
                            cornerLength: 30.0,
                            cornerThickness: 4.0,
                          ),
                        ),
                      ),
                    ),

                    // Flashlight button
                    Positioned(
                      bottom: 20,
                      child: ValueListenableBuilder<MobileScannerState>(
                        valueListenable: cameraController,
                        builder: (context, state, child) {
                          final bool isOn = state.torchState == TorchState.on;
                          return FloatingActionButton(
                            heroTag: "flashButton",
                            backgroundColor: Color(0xFFF8F9FA),
                            onPressed: () async {
                              try {
                                await cameraController.toggleTorch();
                              } catch (e) {
                                debugPrint("Torch toggle error: $e");
                              }
                            },
                            child: Icon(
                              isOn ? Icons.flashlight_on : Icons.flashlight_off,
                              color: const Color(0xFF282C5C),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // --- Info area ---
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: scannedCode == null
                        ? const Text(
                            "SCAN QR TO REGISTER",
                            style: TextStyle(
                              color: Color(0xFFF8F9FA),
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            "Your Token: $token",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFFF8F9FA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),

          // --- Close button top right ---
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF8F9FA),
                ),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF282C5C),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter to draw the four L-shaped corners for the scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  final Color boxColor;
  final double cornerLength;
  final double cornerThickness;
  final double borderRadius;

  ScannerOverlayPainter({
    required this.boxColor,
    required this.cornerLength,
    required this.cornerThickness,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = boxColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerThickness
      ..strokeCap = StrokeCap.round; // Use round cap for nice corner tips

    final double width = size.width;
    final double height = size.height;

    // --- Top Left Corner ---
    // Horizontal line segment (starting after the radius)
    canvas.drawLine(Offset(borderRadius, 0), Offset(cornerLength, 0), paint);
    // Vertical line segment (starting after the radius)
    canvas.drawLine(Offset(0, borderRadius), Offset(0, cornerLength), paint);
    // Arc for the round corner
    canvas.drawArc(
      Rect.fromLTWH(0, 0, borderRadius * 2, borderRadius * 2),
      pi, // Start angle (270 degrees in radians, pointing up)
      pi / 2, // Sweep angle (90 degrees)
      false,
      paint,
    );

    // --- Top Right Corner ---
    // Horizontal line segment
    canvas.drawLine(
      Offset(width - cornerLength, 0),
      Offset(width - borderRadius, 0),
      paint,
    );
    // Vertical line segment
    canvas.drawLine(
      Offset(width, borderRadius),
      Offset(width, cornerLength),
      paint,
    );
    // Arc for the round corner
    canvas.drawArc(
      Rect.fromLTWH(
        width - borderRadius * 2,
        0,
        borderRadius * 2,
        borderRadius * 2,
      ),
      -pi / 2, // Start angle (360 degrees, pointing right)
      pi / 2, // Sweep angle (90 degrees)
      false,
      paint,
    );

    // --- Bottom Left Corner ---
    // Horizontal line segment
    canvas.drawLine(
      Offset(borderRadius, height),
      Offset(cornerLength, height),
      paint,
    );
    // Vertical line segment
    canvas.drawLine(
      Offset(0, height - cornerLength),
      Offset(0, height - borderRadius),
      paint,
    );
    // Arc for the round corner
    canvas.drawArc(
      Rect.fromLTWH(
        0,
        height - borderRadius * 2,
        borderRadius * 2,
        borderRadius * 2,
      ),
      pi / 2, // Start angle (90 degrees, pointing down)
      pi / 2, // Sweep angle (90 degrees)
      false,
      paint,
    );

    // --- Bottom Right Corner ---
    // Horizontal line segment
    canvas.drawLine(
      Offset(width - cornerLength, height),
      Offset(width - borderRadius, height),
      paint,
    );
    // Vertical line segment
    canvas.drawLine(
      Offset(width, height - cornerLength),
      Offset(width, height - borderRadius),
      paint,
    );
    // Arc for the round corner
    canvas.drawArc(
      Rect.fromLTWH(
        width - borderRadius * 2,
        height - borderRadius * 2,
        borderRadius * 2,
        borderRadius * 2,
      ),
      0, // Start angle (0 degrees, pointing left)
      pi / 2, // Sweep angle (90 degrees)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The fixed content to be encoded in the QR code.
    const String qrContent = "register_here";

    // We wrap the QR code in a Card for a clean, printable frame.
    // This design is simple, maximizing the contrast between the dark QR code
    // and the white background, which is optimal for scanning and printing.
    return Scaffold(
      backgroundColor: Color(
        0xFFF8F9FA,
      ), // Ensure white background for printout consistency
      // appBar: AppBar(
      //   title: const Text(
      //     "Staff Registration QR Code",
      //     style: TextStyle(
      //       color: Color(0xFFF8F9FA),
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: Color(0xFF282C5C),
      //   iconTheme: const IconThemeData(color: Color(0xFFF8F9FA)),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Informational Text
              const Text(
                "Scan this code to Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  color: Color(0xFF282C5C),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 56),

              // The QR Code container (simulating the printable area)
              Card(
                elevation: 10,
                color: Color(0xFF282C5C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    10.0,
                  ), // Padding inside the card
                  child: QrImageView(
                    data: qrContent,
                    version: QrVersions.auto,
                    size:
                        280.0, // Slightly larger for better visibility/printing
                    // The foreground color is set to the dark primary color for high contrast.
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.circle,
                      color: Color(0xFF282C5C),
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: Color(0xFF282C5C),
                    ),

                    // Applying rounded corners to the three outer 'eyes'

                    // Ensure the background is transparent or white for clean printing
                    backgroundColor: Color(0xFFF8F9FA),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Helper text for content verification
              // Text(
              //   "Content: $qrContent",
              //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
