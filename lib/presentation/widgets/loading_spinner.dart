import 'package:flutter/material.dart';

import 'logo.dart';

class RotatingSpinner extends StatefulWidget {
  const RotatingSpinner({super.key});

  @override
  State<RotatingSpinner> createState() => _RotatingSpinnerState();
}

class _RotatingSpinnerState extends State<RotatingSpinner>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const AppLogo(size: 24);
    }
    return RotationTransition(
      turns: _controller!,
      child: const AppLogo(size: 24),
    );
  }
}
