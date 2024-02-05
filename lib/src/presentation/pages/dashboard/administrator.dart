import 'package:flutter/material.dart';

class Administrator extends StatelessWidget {
  const Administrator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Administrator',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Administrator'),
        ),
        body: const Center(
          child: Text('Dashboard Administrator'),
        ),
      ),
    );
  }
}
