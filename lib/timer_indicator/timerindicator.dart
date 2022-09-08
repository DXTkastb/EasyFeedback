import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/speech_data_provider.dart';
class LinearIndicator extends StatefulWidget {
  const LinearIndicator({Key? key}) : super(key: key);

  @override
  State<LinearIndicator> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<LinearIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..addListener(() {
        setState(() {});
      })..forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: Colors.black,
      value: controller.value,
      semanticsLabel: 'Linear progress indicator',
    );
  }
}
