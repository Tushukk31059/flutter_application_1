import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';

class MaterialWidgetsDemo extends StatelessWidget {
  const MaterialWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Widgets Demo")),
      body: const Center(
        child: Text(
          "Welcome to Material Widgets Demo!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    //  Enter fullscreen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = VideoPlayerController.asset("assets/videos/splash.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.setLooping(false);

    _controller.addListener(() {
      // Check if the video has finished playing
      if (_controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying) {
        // Restore UI overlays before navigating
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        // Navigate with fade transition
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) =>
                MaterialWidgetsDemo(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Container(color: Colors.white),
    );
  }
}
