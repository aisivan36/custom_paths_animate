import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circles'),
      ),
    );
  }
}
