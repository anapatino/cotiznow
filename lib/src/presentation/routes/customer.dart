import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/dashboard/customer.dart';
import '../widgets/components/drawer.dart';

class CustomerRoutes {
  static const String customer = '/customer-dashboard';
  static const String profile = '/profile-details';
  static const String sections = '/sections';
  static const String requestVisit = '/request-visit';
  static const String whatsapp = '/whatsapp';
  static const String exit = '/principal';
  static final routes = [
    GetPage(
      name: customer,
      page: () => Customer(),
    ),
    GetPage(
      name: profile,
      page: () => const Main(),
    ),
    GetPage(
      name: sections,
      page: () => const Main(),
    ),
    GetPage(
      name: sections,
      page: () => const Main(),
    ),
    GetPage(
      name: requestVisit,
      page: () => const Main(),
    ),
    GetPage(
      name: whatsapp,
      page: () => const Main(),
    ),
    GetPage(
      name: exit,
      page: () => const Main(),
    ),
  ];

  final List<DrawerItemConfig> itemConfigs = [
    DrawerItemConfig(
      icon: Icons.person,
      title: 'Perfil',
      routeName: profile,
    ),
    DrawerItemConfig(
      icon: Icons.grid_view_rounded,
      title: 'Principal',
      routeName: sections,
    ),
    DrawerItemConfig(
      icon: Icons.person_pin_rounded,
      title: 'Solicitar visita',
      routeName: requestVisit,
    ),
    DrawerItemConfig(
      icon: Icons.phone_rounded,
      title: 'WhatsApp',
      routeName: whatsapp,
    ),
    DrawerItemConfig(
      icon: Icons.door_front_door_rounded,
      title: 'Salir',
      routeName: exit,
    ),
  ];

  Widget buildRoute(String routeName, BuildContext context) {
    var itemConfig = itemConfigs.firstWhere(
        (item) => item.routeName == routeName,
        orElse: () => throw Exception('Ruta no reconocida: $routeName'));

    return itemConfig.build(context);
  }
}
