import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class Circles extends StatefulWidget {
  const Circles({super.key});

  @override
  State<Circles> createState() => _CirclesState();
}

class _CirclesState extends State<Circles> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  double circles = 5.0;
  bool showDots = false, showPath = true;

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
        title: const Text('Circles'),
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
                    painter: CirclePainter(
                      circles: circles,
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
                  onChanged: (value) {
                    setState(() {
                      showDots = value;
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 0.0),
                  child: Text('Show Path'),
                ),
                Switch(
                  value: showPath,
                  onChanged: (value) {
                    setState(() {
                      showPath = value;
                    });
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text('Circles'),
            ),
            Slider(
              min: 1.0,
              max: 10.0,
              value: circles,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  circles = value;
                });
              },
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
                child: const Text('Animate'),
                onPressed: () {
                  controller.reset();
                  controller.forward();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.circles,
    required this.progress,
    required this.showDots,
    required this.showPath,
  });

  final double circles, progress;
  bool showDots, showPath;

  var myPaint = Paint()
    ..color = Colors.amber
    ..style = PaintingStyle.stroke
    ..strokeWidth = 7.0;

  double radius = 80;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = createPath();
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      if (showPath) {
        canvas.drawPath(extractPath, myPaint);
      }
      if (showDots) {
        try {
          PathMetric metric = extractPath.computeMetrics().first;
          final offset = metric.getTangentForOffset(metric.length)?.position;
          canvas.drawCircle(offset!, 8.0, Paint());
        } catch (err) {
          rethrow;
        }
      }
    }
  }

  Path createPath() {
    Path path = Path();
    int n = circles.toInt();
    var range = List<int>.generate(n, (index) => index + 1);
    double angle = 2 * math.pi / n;
    for (int index in range) {
      double x = radius * math.cos(index * angle);
      double y = radius * math.sin(index * angle);
      path.addOval(
        Rect.fromCircle(
          center: Offset(x, y),
          radius: radius,
        ),
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
