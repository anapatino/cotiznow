import 'package:cotiznow/src/presentation/pages/pages.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const Main(),
        '/register': (context) => const Main(),
        '/principal': (context) => const Main(),
      },
      home: const Main(),
    );
  }
}
