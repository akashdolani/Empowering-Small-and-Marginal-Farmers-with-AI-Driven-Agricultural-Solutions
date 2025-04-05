import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../presentation/home/home2.dart';

class MainApp2 extends StatelessWidget {
  const MainApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme(),
      home: const GeminiScreen(),
    );
  }
}
