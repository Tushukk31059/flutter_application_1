import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  double _size = 100;
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Implicit Animation")),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1), // animation ka time
          //  curve: Curves.linear,
          // curve: Curves.easeIn, // Dheere start hota hai, fir fast
          // curve: Curves.easeOut   ,  // Fast start hota hai, dheere khatam hota hai
          // curve: Curves.easeInOut,
          // curve: Curves.easeInOut,               // smoothness of animation
          // curve: Curves.bounceIn,
          // curve: Curves.bounceOut,
          // curve: Curves.bounceInOut,
          // curve: Curves.elasticIn,
          // curve: Curves.elasticOut,
          curve:Curves.decelerate,
          // curve: Curves.elasticInOut,
          height: _size,
          width: _size,
          color: _color,
          child: const Center(child: Text("Tap Me")),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _size = (_size == 100) ? 200 : 100;
            _color = (_color == Colors.blue) ? Colors.red : Colors.blue;
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
