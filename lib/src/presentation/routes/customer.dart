import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/pages.dart';
import '../widgets/components/drawer.dart';

class CustomerRoutes {
  static const String customer = '/customer-dashboard';
  static const String profiles = '/profiles';
  static const String sections = '/sections';
  static const String requestVisit = '/request-visit';
  static const String visitDetails = '/visit-details';

  static const String quotations = '/quotations';
  static const String quotationsRegistration = '/registration-quotation';
  static const String whatsapp = '/whatsapp';
  static const String exit = '/principal';
  static final routes = [
    GetPage(
      name: customer,
      page: () => CustomerDashboard(),
    ),
    GetPage(
      name: profiles,
      page: () => ProfileDetails(),
    ),
    GetPage(
      name: sections,
      page: () => const Main(),
    ),
    GetPage(
      name: requestVisit,
      page: () => ProgrammeVisitsPanel(),
    ),
    GetPage(
      name: visitDetails,
      page: () => const VisitDetails(),
    ),
    GetPage(
      name: quotations,
      page: () => QuotationPanel(),
    ),
    GetPage(
      name: quotationsRegistration,
      page: () => const RegisterQuotation(),
    ),
    GetPage(
      name: whatsapp,
      page: () => const RedirectToWhatsapp(),
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
      icon: Icons.grid_view_rounded,
      title: 'Principal',
      routeName: customer,
    ),
    DrawerItemConfig(
      icon: Icons.person_pin_rounded,
      title: 'Solicitar visita',
      routeName: requestVisit,
    ),
    DrawerItemConfig(
      icon: Icons.request_quote,
      title: 'Cotizaciones',
      routeName: quotations,
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
