import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/anim.dart';
import 'package:flutter_application_1/counterscreen.dart';
import 'package:flutter_application_1/expanim.dart';
import 'package:flutter_application_1/faceregistration.dart';
import 'package:flutter_application_1/fetchapi.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/databasehelper.dart';
import 'package:flutter_application_1/notesapp.dart';
import 'package:flutter_application_1/qrdemoapp.dart';
import 'package:flutter_application_1/sharedprefsfile.dart';
import 'package:flutter_application_1/techcadd.dart';
import 'package:flutter_application_1/validate.dart';
import 'package:flutter_application_1/websocketdemo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner
      home: Sharedprefsfile(),
      // app ka home screen
    );
  }
}


class Practice extends StatefulWidget {
  const Practice({super.key});
  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  final dbHelper = DatabaseHelper.instance;
  String _imageStatusMessage = 'Tap to upload student image.';
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isProcessingImage = false;
  List<Map<String, dynamic>> students = [];


Future<void> fetchStudents() async {
  final data = await dbHelper.getAllStudent();
  setState(() {
    students = data;
  });
  print("Fetched Notes: $students"); // 👈 ye confirm karega DB se kya aa raha hai
}

@override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> _submit() async {
    try {
      // Show loading
      Fluttertoast.showToast(msg: "Saving data...");

      // Upload image to Firebase Storage
      final storageRef = firebase_storage.FirebaseStorage.instance.ref().child(
        'student_images/image.jpg',
      );
      print("stuimg $storageRef");
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      print("edrr" + imageUrl);

      // Save student data in Firestore
      await FirebaseFirestore.instance
          .collection('students')
          .doc("_regCtrl.text")
          .set({
            // "reg": _regCtrl.text,
            // "name": _nameCtrl.text,
            // "email": _emailCtrl.text,
            // "mobile": _mobileCtrl.text,
            // "branch": _branch,
            // "course": _course,
            // "subCourse": _subCourse,
            // "type": _type,
            // "duration": _duration,
            // "startDate": _startDate?.toIso8601String(),
            "imageUrl": imageUrl,
            // "timestamp": FieldValue.serverTimestamp(),
          });

      Fluttertoast.showToast(
        msg: "Student Registered Successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to student dashboard
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _pickAndVerifyImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      // 1. Set state to start processing
      setState(() {
        _isProcessingImage = true;
        _selectedImage = null; // Clear previous image
        _imageStatusMessage = 'Checking image for face... Please wait.';
      });

      final imagePath = pickedFile.path;
      // final hasFace = await _checkForFace(imagePath);

      // 2. Update state based on verification result
      setState(() {
        _isProcessingImage = false;
        // if (hasFace) {
        _selectedImage = File(imagePath);
        // _imageStatusMessage = '✅ Face detected successfully! Image is valid.';
        // } else {
        //   _selectedImage = null;
        //   _imageStatusMessage =
        //       '❌ Error: No face detected. Please ensure your face is visible.';
        // }
      });
    } else {
      setState(() {
        _imageStatusMessage = 'Image selection cancelled.';
      });
    }
  }

  void _showImagePicker() {
    if (_isProcessingImage) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF282C5C),
                ),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndVerifyImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF282C5C)),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndVerifyImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadField() {
    final bool isFaceVerified = _imageStatusMessage.startsWith('✅');
    final Color borderColor = isFaceVerified
        ? Colors.green
        : (_imageStatusMessage.startsWith('❌')
              ? Colors.red
              : Colors.grey[300]!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 66, 66, 66),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isProcessingImage
              ? null
              : _showImagePicker, // Disable tap during processing
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[100],
            ),
            child: _selectedImage == null
                ? Center(
                    child: _isProcessingImage
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF282C5C),
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 40,
                                color: Color(0xFF282C5C),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Tap to upload",
                                style: TextStyle(color: Color(0xFF282C5C)),
                              ),
                            ],
                          ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        // Status message display
        Text(
          _imageStatusMessage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            // color: isFaceVerified
            //     ? Colors.green.shade700
            //     : (_imageStatusMessage.startsWith('❌')
            //           ? Colors.red
            //           : Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildPopMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        print(value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'One',
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 200,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Choose an option", style: TextStyle(fontSize: 18)),
                    ListTile(
                      leading: Icon(Icons.photo),
                      title: Text("AnimationPage"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimationDemo(),
                          ),
                        );
                        print("Gallery tapped");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text("FormPage"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentFormPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          child: Text('Option 1'),
        ),
        PopupMenuItem(
          value: 'Two',
          onTap: () => showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // sirf content jitna height
                    children: [
                      Icon(Icons.info, size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        "Custom Dialog",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("This is a custom styled dialog box."),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Close"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          child: Text('Option 2'),
        ),
        PopupMenuItem(
          value: 'three',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SecondScreen(message: "hello from first screen"),
            ),
          ),

          child: Text('Option 3'),
        ),
        PopupMenuItem(
          value: 'four',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExplicitAnimationDemo()),
          ),

          child: Text('Explicit Animation'),
        ),
        PopupMenuItem(
          value: 'five',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CounterScreen()),
          ),

          child: Text("counter with mobx"),
        ),
        PopupMenuItem(
          value: 'six',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ApiExample()),
          ),

          child: Text("fetch data with API "),
        ),
        PopupMenuItem(
          value: 'seven',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebSocketDemo()),
          ),
          child: Text("fetch data with websockets "),
        ),
        PopupMenuItem(
          value: 'eight',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotesApp()),
          ),
          child: Text("notes app with sql database "),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFE9ECEF), // 👈 nav bar bg
        systemNavigationBarIconBrightness: Brightness.dark, // 👈 icons color
        statusBarColor: Colors.transparent, // 👈 status bar bg
        statusBarIconBrightness: Brightness.light, // 👈 status bar icons
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("ListView Example")),
        body: Builder(
          builder: (context) {
            return Center(
              child: ListView(
                children: [
                  Center(child: _buildPopMenuButton()),

                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                            Fluttertoast.showToast(
                              msg: "Thiz is a toast",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM_LEFT,

                              textColor: const Color.fromARGB(
                                255,
                                246,
                                248,
                                247,
                              ),
                              fontSize: 16.0,
                            );
                          },
                          child: const Text("Techcadd App"),
                        ),
                        SizedBox(height: 26),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Qrdemoapp(),
                              ),
                            );
                          },
                          child: Text("Qr"),
                        ),
                        SizedBox(height: 26),
                        _buildUploadField(),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            _submit();
                          },
                          child: Text("submit "),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FaceRegistrationWidget(),
                              ),
                            );
                          },
                          child: Text("Face register"),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: ListView.builder(
                      shrinkWrap: true, // apni height content ke hisaab se le
                      physics:
                          NeverScrollableScrollPhysics(), // parent hi scroll karega
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text("User $index"),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: GridView.count(
                      shrinkWrap: true, // apni height content ke hisaab se le
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4, // 2 columns
                      children: [
                        Container(color: Colors.red, height: 100),
                        Container(color: Colors.green, height: 100),
                        Container(color: Colors.blue, height: 100),
                        Container(color: Colors.blue, height: 100),
                        Container(color: Colors.blue, height: 100),
                        Container(color: Colors.orange, height: 100),
                      ],
                    ),
                  ),
                  Center(
                    child: GridView.builder(
                      shrinkWrap: true, // apni height content ke hisaab se le
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 columns
                        crossAxisSpacing: 10, // columns ke beech gap
                        mainAxisSpacing: 10, // rows ke beech gap
                      ),
                      itemCount: 20, // total items
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.blue,
                          child: Center(child: Text("Item $index")),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: GridView.extent(
                      shrinkWrap: true, // apni height content ke hisaab se le
                      physics: NeverScrollableScrollPhysics(),
                      maxCrossAxisExtent: 250, // ek item ki max width
                      children: List.generate(10, (index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          color: Colors.teal,
                          child: Center(child: Text("Box $index")),
                        );
                      }),
                    ),
                  ),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        print("Tapped!");
                      },
                      onDoubleTap: () {
                        print("Double Tapped!");
                      },
                      onLongPress: () {
                        print("Long Pressed!");
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.blue,
                        child: Center(child: Text("Click Me")),
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Item"),
                              content: Text(
                                "Are you sure you want to delete this item?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    print("cancelled");
                                    Navigator.of(context).pop(); // dialog band
                                  },
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    print("Item Deleted");
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDoubleTap: () {
                        print("Double Tapped!");
                      },
                      onLongPress: () {
                        print("Long Pressed!");
                      },
                      radius: 200,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Tap Here"),
                      ),
                    ),
                  ),
                  Center(
                    child: InkResponse(
                      onTap: () {
                        print("InkResponse tapped");
                      },
                      onDoubleTap: () {
                        print("Double Tapped!");
                      },
                      onLongPress: () {
                        print("Long Pressed!");
                      },
                      radius: 100, // ripple size
                      containedInkWell: false, // by default ripple bahar jayega
                      highlightShape: BoxShape.circle,
                      child: Container(
                        height: 80,
                        width: 180,
                        color: Colors.green,
                        child: Center(child: Text("InkResponse")),
                      ),
                    ),
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Scaffold.of(context).showBottomSheet(
                          (context) => Container(
                            height: 200,
                            color: Colors.teal,
                            child: Center(child: Text("data")),
                          ),
                        );
                      },
                      child: const Text("Go to Profile Screen"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyList extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => "Item ${index + 1}");

  MyList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length, // total items
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.star),
          title: Text(items[index]),
          subtitle: Text("This is ${items[index]}"),
        );
      },
    );
  }
}

class SecondScreen extends StatelessWidget {
  final String message;
  const SecondScreen({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Screen")),
      body: Center(
        child: Column(
          children: [
            Text(message),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // back to previous screen
              },
              child: Text("Go Back"),
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(color: Colors.red, height: 100),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(color: Colors.green, height: 100),
                ),
              ],
            ),
            Container(
              color: Colors.blue,
              width: 100,
              height: 100,
              child: FittedBox(
                child: Text(
                  "This is a very long text",
                  style: TextStyle(fontSize: 2, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}