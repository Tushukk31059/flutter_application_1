import 'package:flutter/material.dart';


class ExplicitAnimationDemo extends StatefulWidget {
  const ExplicitAnimationDemo({super.key});

  @override
  State<ExplicitAnimationDemo> createState() => _ExplicitAnimationDemoState();
}

class _ExplicitAnimationDemoState extends State<ExplicitAnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    // 1. Controller banaya
    _controller = AnimationController(
      vsync: this,                 // ticker provider (fps ke sath sync)
      duration: const Duration(seconds: 2),
    );

    // 2. Size Tween
    _sizeAnimation = Tween<double>(begin: 100, end: 200).animate(_controller);

    // 3. Color Tween
    _colorAnimation =
        ColorTween(begin: Colors.blue, end: Colors.yellow).animate(_controller);

    // 4. Listener (jab bhi animation update ho, redraw kare)
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // memory leak avoid
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explicit Animation")),
      body: Center(
        child: Container(
          height: _sizeAnimation.value,   // animated value
          width: _sizeAnimation.value,
          color: _colorAnimation.value,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isCompleted) {
            _controller.reverse(); // wapas chalao
          } else {
            _controller.forward(); // animation start
          }
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
