import 'package:flutter/material.dart';

class Customer extends StatelessWidget {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard cliente',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard cliente'),
        ),
        body: const Center(
          child: Text('Dashboard cliente'),
        ),
      ),
    );
  }
}
