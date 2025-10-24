import 'package:flutter/material.dart';
import 'package:flutter_application_1/practice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Sharedprefsfile extends StatefulWidget {
  const Sharedprefsfile({super.key});

  @override
  State<Sharedprefsfile> createState() => _SharedPrefsfileState();
}

class _SharedPrefsfileState extends State<Sharedprefsfile> {
  final _storage = const FlutterSecureStorage();
  var nameController = TextEditingController();
  static const String KEYNAME = "name";
  var nameValue = "";

  Future<void> saveToken(String token) async {
    await _storage.write(key: "auth_token", value: token);
  }

  Future<void> getToken(String token) async {
    await _storage.read(key: "auth_token");
  }

  Future<void> clearToken() async {
    await _storage.delete(key: "auth_token");
  }

  @override
  void initState() {
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("shared prefs")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text("name"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              // var name = nameController.text.toString();
              // saveToken(nameController.text.toString());
              var prefs = await SharedPreferences.getInstance();
              prefs.setString(KEYNAME, nameController.text.toString());
              if (nameController.text == nameValue || nameValue.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Practice()),
                );
              }
            },
            child: Text("Save"),
          ),
          Text(nameValue),
        ],
      ),
    );
  }

  void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    var getName = prefs.getString(KEYNAME);
    nameValue = getName!;
    setState(() {});
  }
}
