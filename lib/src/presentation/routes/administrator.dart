import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/profile/profile_details.dart';
import 'package:cotiznow/src/presentation/pages/sections/sections.dart';

import '../pages/dashboard/administrator.dart';
import '../pages/customer/customer.dart';
import '../widgets/components/drawer.dart';

class AdministratorRoutes {
  static const String administrator = '/administrator-dashboard';
  static const String profiles = '/profiles';
  static const String customers = '/customers';
  static const String sections = '/sections';
  static const String materials = '/materials';
  static const String services = '/services';
  static const String quotes = '/quotes';
  static const String discounts = '/discounts';
  static const String exit = '/principal';

  static final routes = [
    GetPage(
      name: administrator,
      page: () => Administrator(),
    ),
    GetPage(
      name: profiles,
      page: () => ProfileDetails(),
    ),
    GetPage(
      name: customers,
      page: () => Customer(),
    ),
    GetPage(
      name: sections,
      page: () => Sections(),
    ),
    GetPage(
      name: materials,
      page: () => const Main(),
    ),
    GetPage(
      name: services,
      page: () => const Main(),
    ),
    GetPage(
      name: discounts,
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
      routeName: profiles,
    ),
    DrawerItemConfig(
      icon: Icons.people,
      title: 'Clientes',
      routeName: customers,
    ),
    DrawerItemConfig(
      icon: Icons.grid_view_rounded,
      title: 'Secciones',
      routeName: sections,
    ),
    DrawerItemConfig(
      icon: Icons.layers_rounded,
      title: 'Materiales',
      routeName: materials,
    ),
    DrawerItemConfig(
      icon: Icons.inventory,
      title: 'Servicios',
      routeName: services,
    ),
    DrawerItemConfig(
      icon: Icons.request_quote,
      title: 'Cotizaciones',
      routeName: quotes,
    ),
    DrawerItemConfig(
      icon: Icons.percent,
      title: 'Descuentos',
      routeName: discounts,
    ),
    DrawerItemConfig(
      icon: Icons.door_front_door_rounded,
      title: 'Salir',
      routeName: exit,
    ),
  ];
}
