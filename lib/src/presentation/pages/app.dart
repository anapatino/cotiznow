import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/authentication/register.dart';

import 'authentication/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/principal': (context) => const Main(),
      },
      home: const Main(),
    );
  }
}
