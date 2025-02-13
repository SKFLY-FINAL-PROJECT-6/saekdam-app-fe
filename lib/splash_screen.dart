import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("GIF 애니메이션 조절 예제")),
        body: Center(
          child: Image.asset("asset/img/splash_screen_gif.gif")
              .animate()

        ),
    );
  }
}
