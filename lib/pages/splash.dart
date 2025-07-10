import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String routeNameSP = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _treeController;
  late AnimationController _textController;
  late AnimationController _waveController;
  late AnimationController _buttonsController;

  late Animation<double> _treeScaleAnimation;
  late Animation<double> _treeOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _buttonsSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Tree animations
    _treeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _treeScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _treeController,
      curve: Curves.easeOutBack,
    ));

    _treeOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _treeController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Wave animation
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Buttons animation
    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonsController,
      curve: Curves.easeOutBack,
    ));

    // Start animations in sequence
    _treeController.forward().then((_) {
      _textController.forward().then((_) {
        _buttonsController.forward();
      });
    });
  }

  @override
  void dispose() {
    _treeController.dispose();
    _textController.dispose();
    _waveController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated wave background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 300),
                  painter: WavePainter(
                    animation: _waveController,
                    color: const Color(0xFFE6E0FA),
                  ),
                );
              },
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Logo text
                FadeTransition(
                  opacity: _textOpacityAnimation,
                  child: SizedBox(
                    width: 250,
                    child: Image.asset("assets/images/logo.png")
                    )
                ),
                const SizedBox(height: 50),
                // Animated tree
                Expanded(
                  child: Center(
                    child: ScaleTransition(
                      scale: _treeScaleAnimation,
                      child: FadeTransition(
                        opacity: _treeOpacityAnimation,
                        child:SizedBox(
                          width: 270,
                          child: Image.asset("assets/images/tree.png")
                          ),
                      ),
                    ),
                  ),
                ),
                // Buttons
                SlideTransition(
                  position: _buttonsSlideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,"/sign-in");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'SIGN-IN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/sign-up");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF8B5CF6),
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              'SIGN-UP',
                              style: TextStyle(color: Color(0xFF8B5CF6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the animated wave
class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 1);

    for (var i = 0.0; i < size.width; i++) {
  path.lineTo(
    i,
    size.height * 0.7 +
        math.sin((i / size.width * 2 * math.pi) + (animation.value * 2 * math.pi)) * 20, // Increased from 10 to 20
  );
}

    path.lineTo(size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}