import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_json_parsing.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'counter.dart';
import 'dart:async';

final counter = Counter(); // Store instance

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MobX Example")),
      body: Center(
        child: Observer(
          builder: (_) {
            if (counter.value == 5) {
              // yaha navigate karwa do
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FutureExample()),
                );
              });
            } else if (counter.value == 6) {
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StreamExample()),
                );
              });
            } else if (counter.value == 7) {
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductPage()),
                );
              });
            }
            return Text(
              "Counter: ${counter.value}",
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FutureExample extends StatefulWidget {
  const FutureExample({super.key});

  @override
  _FutureExampleState createState() => _FutureExampleState();
}

class _FutureExampleState extends State<FutureExample> {
  String data = "Loading...";

  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 3));
    return "Hello from Future!";
  }

  void loadData() async {
    String result = await fetchData();
    setState(() {
      data = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData(); // Start fetching as soon as screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Future Example")),
      body: Center(child: Text(data)),
    );
  }
}

class StreamExample extends StatelessWidget {
  const StreamExample({super.key});

  // Stream that emits numbers every second
  Stream<int> numberStream() async* {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("StreamBuilder Example")),
      body: Center(
        child: StreamBuilder<int>(
          stream: numberStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Waiting for data...");
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return Text(
                "Current Value: ${snapshot.data}",
                style: TextStyle(fontSize: 24),
              );
            } else {
              return Text("Stream completed");
            }
          },
        ),
      ),
    );
  }
}
