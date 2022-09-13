import 'dart:ui';

import 'package:flutter/material.dart';

class Lines extends StatefulWidget {
  const Lines({super.key});

  @override
  State<Lines> createState() => _LinesState();
}

class _LinesState extends State<Lines> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    controller.value = 1.0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lines'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                      child: CustomPaint(
                        painter: LinePainter(progress: controller.value),
                        size: const Size(double.maxFinite, 100),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                      child: CustomPaint(
                        painter: DashLinePainter(progress: controller.value),
                        size: const Size(double.maxFinite, 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text('Progress'),
            ),
            Slider(
              value: controller.value,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  controller.value = value;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Animated'),
                onPressed: () {
                  controller.reset();
                  controller.forward();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double progress;
  LinePainter({required this.progress});

  final _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * progress, size.height / 2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class DashLinePainter extends CustomPainter {
  final double progress;

  DashLinePainter({required this.progress});

  final _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width * progress, size.height / 2);

    Path dashPath = Path();
    double dashWidth = 10.0;
    double dashSpace = 5.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }

    canvas.drawPath(dashPath, _paint);
  }

  @override
  bool shouldRepaint(covariant DashLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
