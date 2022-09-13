import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class Polygon extends StatefulWidget {
  const Polygon({super.key});

  @override
  State<Polygon> createState() => _PolygonState();
}

class _PolygonState extends State<Polygon> with SingleTickerProviderStateMixin {
  double sides = 3.0;
  bool showDots = false, showPath = true;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
        title: const Text('Polygon'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) => Center(
                  child: CustomPaint(
                    painter: PolygonPainter(
                      sides: sides,
                      progress: controller.value,
                      showDots: showDots,
                      showPath: showPath,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 0.0),
                  child: Text('Show Dots'),
                ),
                Switch(
                  value: showDots,
                  onChanged: (value) => setState(() {
                    showDots = value;
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 0.0),
                  child: Text('Show Path'),
                ),
                Switch(
                  value: showPath,
                  onChanged: (value) => setState(() {
                    showPath = value;
                  }),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text('Progress'),
            ),
            Slider(
              value: controller.value,
              min: 0.0,
              max: 1.0,
              onChanged: (value) => setState(() {
                controller.value = value;
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  PolygonPainter(
      {required this.sides,
      required this.progress,
      required this.showDots,
      required this.showPath});

  final double sides;
  final double progress;
  bool showDots, showPath;

  final Paint _paint = Paint()
    ..color = Colors.purple
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = createPath(sides.toInt(), 100);
    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath =
        pathMetric.extractPath(0.0, pathMetric.length * progress);
    if (showPath) {
      canvas.drawPath(extractPath, _paint);
    }
    if (showDots) {
      try {
        PathMetric metric = extractPath
            .computeMetrics()
            .firstWhere((element) => true, orElse: () => pathMetric);
        final offset = metric.getTangentForOffset(metric.length)?.position;
        canvas.drawCircle(offset!, 8.0, _paint);
      } catch (err) {
        rethrow;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Path createPath(int sides, double radius) {
    Path path = Path();
    var angle = (math.pi * 2) / sides;
    path.moveTo(radius * math.cos(0.0), radius * math.sin(0.0));

    for (int index = 1; index <= sides; index++) {
      double x = radius * math.cos(angle * index);
      double y = radius * math.sin(angle * index);
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }
}
