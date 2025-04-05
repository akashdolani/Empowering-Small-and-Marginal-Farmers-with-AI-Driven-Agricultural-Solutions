import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 64,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/logo.svg",
      height: size,
      width: size,
    );
  }
}
