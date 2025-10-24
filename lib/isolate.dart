import 'package:flutter/foundation.dart';
// import 'dart:isolate';

// void heavyTask(SendPort sendPort) {
//   // koi heavy calculation
//   int sum = 0;
//   for (int i = 0; i < 10000909; i++) {
//     sum += i;
//   }
//   sendPort.send(sum); // result bhej diya back to main isolate
// }

// void main() async {
//   // receivePort banaya main isolate me
//   ReceivePort receivePort = ReceivePort();

//   // new isolate spawn kiya
//   await Isolate.spawn(heavyTask, receivePort.sendPort);

//   // listen for messages from the isolate
//   receivePort.listen((message) {
//     print("Result from isolate: $message");
//     receivePort.close();
//   });

//   print("Main isolate free hai, UI block nahi hoga.");
// }

int heavyCalculation(int n) {
  int sum = 0;
  for (int i = 0; i < n; i++) {
    sum += i;
  }
  return sum;
}

void main() async {
  print("Start");
  final result = await compute(heavyCalculation, 1000000000);
  print("Result = $result");
}
