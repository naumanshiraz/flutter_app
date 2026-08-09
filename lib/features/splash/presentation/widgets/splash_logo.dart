import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  final double size;

  const SplashLogo({
    super.key,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}