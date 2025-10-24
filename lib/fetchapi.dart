import 'dart:convert'; // JSON ke liye
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http package

class ApiExample extends StatefulWidget {
  const ApiExample({super.key});

  @override
  State<ApiExample> createState() => _ApiExampleState();
}

class _ApiExampleState extends State<ApiExample> {
  String result = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchData(); // app start hote hi call ho
  }

  Future<void> fetchData() async {
    // Step 1: API URL
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=Jalandhar&appid=5630e7aa407f9e1557d0aafc7e21d214&units=metric",
    );
    
    // Step 2: Request bhejna
    final response = await http.get(url);

    // Step 3: Response check
    if (response.statusCode == 200) {
      // success
      final data = jsonDecode(response.body);
      setState(() {
        result="City: ${data['name']}\nTemp: ${data['main']['temp']} °C\nWeather: ${data['weather'][0]['description']}";
      });
      
      print("City: ${data['name']}");
      print("Temp: ${data['main']['temp']} °C");
      print("Weather: ${data['weather'][0]['description']}");
    } else {
      setState(() {
        result = "Error: ${response.statusCode}";
      });
    }
    //     final response = await http.post(
    //   url,
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode({
    //     "title": "Hello Flutter",
    //     "body": "This is my first API post!",
    //     "userId": 1,
    //   }),
    // );

    // if (response.statusCode == 201) {
    //   print("Post Created: ${response.body}");
    // } else {
    //   print("Error: ${response.statusCode}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Example")),
      body: Center(child: Text(result, style: const TextStyle(fontSize: 18))),
    );
  }
}
