import 'package:cotiznow/lib.dart';

class HomeRoutes {
  static const String principal = '/principal';

  static final routes = [
    GetPage(
      name: principal,
      page: () => const Main(),
    ),
  ];
}
