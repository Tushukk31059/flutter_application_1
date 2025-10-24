import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// Ensure you have an ImagePicker instance
final ImagePicker _picker = ImagePicker();

class FaceRegistrationWidget extends StatefulWidget {
  const FaceRegistrationWidget({super.key});

  @override
  State<FaceRegistrationWidget> createState() => _FaceRegistrationWidgetState();
}

class _FaceRegistrationWidgetState extends State<FaceRegistrationWidget> {
  // 1. State Variables
  File? _imageFile;
  String _statusMessage = 'Please select your image.';
  bool _isProcessing = false;

  // 2. Face Detection Logic
  Future<bool> _checkForFace(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);

    // Initialize the face detector with default options
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast, // Faster detection
      ),
    );

    try {
      final List<Face> faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();

      // Check if at least one face is detected
      return faces.isNotEmpty;
    } catch (e) {
      // Handle any errors during processing
      debugPrint("Face detection error: $e");
      await faceDetector.close();
      return false;
    }
  }

  // 3. Image Picking and Validation Logic
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _isProcessing = true;
        _imageFile = null; // Clear previous image while processing
        _statusMessage = 'Checking image for face...';
      });

      final imagePath = pickedFile.path;
      final hasFace = await _checkForFace(imagePath);

      setState(() {
        _isProcessing = false;
        if (hasFace) {
          _imageFile = File(imagePath);
          _statusMessage =
              '✅ Face detected! Image ready for upload/verification.';
          // TODO: Yahan se aap image ko server pe upload karne ka logic add kar sakte hain
          // For celebrity check, you'll need a live photo and a backend verification step.
        } else {
          _imageFile = null;
          _statusMessage =
              '❌ Error: No face detected. Please upload a clear image of yourself, not an object.';
        }
      });
    } else {
      setState(() {
        _statusMessage = 'Image selection cancelled.';
      });
    }
  }

  // 4. Widget Build Method
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Display the image or a placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
            ),
            child: _imageFile == null
                ? const Center(
                    child: Icon(Icons.person, size: 80, color: Colors.grey),
                  )
                : Image.file(_imageFile!, fit: BoxFit.cover),
          ),

          const SizedBox(height: 16),

          // Status Message
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _statusMessage.startsWith('❌')
                  ? Colors.red
                  : (_statusMessage.startsWith('✅')
                        ? Colors.green
                        : Colors.black87),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          // Buttons for Image Selection
          ElevatedButton.icon(
            onPressed: _isProcessing
                ? null
                : () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Select from Gallery'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _isProcessing
                ? null
                : () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take a Photo (Live)'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(child: CircularProgressIndicator()),
            ),

          const SizedBox(height: 40),

          // Action Button (Hypothetical Register Button)
          ElevatedButton(
            onPressed: (_imageFile != null && !_isProcessing)
                ? () {
                    // TODO: Agar aap live face verification karna chahte hain,
                    // toh yahan 'Take a Photo (Live)' button se ek aur photo capture karwa kar
                    // uski face vector ko database mein stored master image ke vector se match karwayenge (Backend task).

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Image is valid. Proceeding to registration... (Backend verification needed for celebrity check)',
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const Text(
              'Register Student',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
