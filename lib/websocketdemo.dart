import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketDemo extends StatefulWidget {
  const WebSocketDemo({super.key});

  @override
  State<WebSocketDemo> createState() => _WebSocketDemoState();
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  late WebSocketChannel channel;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse("wss://ws.postman-echo.com/raw"), // ✅ stable echo server
    );
  }

  void sendMessage() {
    if (controller.text.isNotEmpty) {
      channel.sink.add(controller.text); // server ko bhejo
      controller.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close(); // connection band
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebSocket Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Enter message"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: sendMessage, child: const Text("Send")),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Connecting...");
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Text(
                      "Received: ${snapshot.data}",
                      style: const TextStyle(fontSize: 18),
                    );
                  } else {
                    return const Text("No message yet");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
