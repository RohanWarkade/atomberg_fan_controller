

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'credential_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController borderController;
  late AnimationController fanController;

  @override
  void initState() {
    super.initState();

    borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    fanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CredentialScreen()),
      );
    });
  }

  @override
  void dispose() {
    borderController.dispose();
    fanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // behind border

      body: SafeArea(
        child: AnimatedBuilder(
          animation: borderController,
          builder: (context, child) {
            return CustomPaint(
              painter: BorderPainter(progress: borderController.value),
              child: child,
            );
          },
          child: Container(
            color: const Color(0xFF0F0F0F), // inner splash background

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/atomberg_logo.png",
                    width: 160,
                  ),

                  const SizedBox(height: 30),

                  RotationTransition(
                    turns: fanController,
                    child: Image.asset(
                      "assets/images/icon.png",
                      width: 140,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class BorderPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  BorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const borderColor = Color(0xFFFF6A00); 
    const borderWidth = 2.0;

    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    
    final perimeter = (rect.width * 2) + (rect.height * 2);

    
    final currentLength = perimeter * progress;

    double remaining = currentLength;

    
    if (remaining <= rect.width) {
      path.moveTo(0, 0);
      path.lineTo(remaining, 0);
      canvas.drawPath(path, paint);
      return;
    } else {
      path.moveTo(0, 0);
      path.lineTo(rect.width, 0);
      remaining -= rect.width;
    }

    
    if (remaining <= rect.height) {
      path.moveTo(rect.width, 0);
      path.lineTo(rect.width, remaining);
      canvas.drawPath(path, paint);
      return;
    } else {
      path.moveTo(rect.width, 0);
      path.lineTo(rect.width, rect.height);
      remaining -= rect.height;
    }

    
    if (remaining <= rect.width) {
      path.moveTo(rect.width, rect.height);
      path.lineTo(rect.width - remaining, rect.height);
      canvas.drawPath(path, paint);
      return;
    } else {
      path.moveTo(rect.width, rect.height);
      path.lineTo(0, rect.height);
      remaining -= rect.width;
    }

    
    if (remaining <= rect.height) {
      path.moveTo(0, rect.height);
      path.lineTo(0, rect.height - remaining);
    } else {
      path.moveTo(0, rect.height);
      path.lineTo(0, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
