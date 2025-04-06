import 'package:flutter/material.dart';

void main() {
  runApp(const demoApp());
}

class demoApp extends StatelessWidget {
  const demoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image from Assets',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Field'),
        ),
        body: Center(
          child: Image.asset('assets/images/farmImage.jpg'),
        ),
      ),
    );
  }
}
