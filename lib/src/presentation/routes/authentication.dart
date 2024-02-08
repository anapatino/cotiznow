import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/authentication/login.dart';
import 'package:cotiznow/src/presentation/pages/authentication/register.dart';

class AuthenticationRoutes {
  static const String login = '/login';
  static const String register = '/register';

  static final routes = [
    GetPage(
      name: login,
      page: () => Login(),
    ),
    GetPage(
      name: register,
      page: () => Register(),
    ),
  ];
}
