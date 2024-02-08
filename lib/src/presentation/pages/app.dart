import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/administrator.dart';
import 'package:cotiznow/src/presentation/routes/authentication.dart';
import 'package:cotiznow/src/presentation/routes/customer.dart';
import 'package:cotiznow/src/presentation/routes/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        ...HomeRoutes.routes,
        ...AuthenticationRoutes.routes,
        ...AdministratorRoutes.routes,
        ...CustomerRoutes.routes,
      ],
      home: const Main(),
    );
  }
}
