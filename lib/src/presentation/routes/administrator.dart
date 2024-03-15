import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/pages.dart';
import '../widgets/components/drawer.dart';

class AdministratorRoutes {
  static const String administrator = '/administrator-dashboard';
  static const String profiles = '/profiles';
  static const String customers = '/customers';
  static const String sections = '/sections';

  static const String materials = '/materials';
  static const String details = '/details-material';

  static const String services = '/services';

  static const String quotations = '/quotations';
  static const String quotationsDetails = '/details-quotation';
  static const String quotationsRegistration = '/registration-quotation';
  static const String quotationsUpdate = '/update-quotation';
  static const String quotationsHistory = '/history-quotation';

  static const String discounts = '/discounts';
  static const String discountsRegister = '/register-discounts';
  static const String discountsUpdate = '/update-discounts';

  static const String requestVisit = '/request-visit';
  static const String visitDetails = '/visit-details';

  static const String exit = '/principal';

  static final routes = [
    GetPage(
      name: administrator,
      page: () => AdministratorDashboard(),
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
      page: () => MaterialsBoard(),
    ),
    GetPage(
      name: details,
      page: () => MaterialDetails(),
    ),
    GetPage(
      name: services,
      page: () => ServicesPanel(),
    ),
    GetPage(
      name: discounts,
      page: () => DiscountPanel(),
    ),
    GetPage(
      name: discountsUpdate,
      page: () => UpdateDiscount(),
    ),
    GetPage(
      name: discountsRegister,
      page: () => RegisterDiscount(),
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
      name: quotationsUpdate,
      page: () => const UpdateQuotation(),
    ),
    GetPage(
      name: quotationsDetails,
      page: () => const DetailsQuotation(),
    ),
    GetPage(
      name: quotationsHistory,
      page: () => HistoryQuotationPanel(),
    ),
    GetPage(
      name: requestVisit,
      page: () => ProgrammeVisitsPanel(),
    ),
    GetPage(
      name: visitDetails,
      page: () => VisitDetails(),
    ),
    GetPage(
      name: exit,
      page: () => const Main(),
    ),
  ];

  final List<DrawerItemConfig> itemConfigs = [
    DrawerItemConfig(
      icon: Icons.home_rounded,
      title: 'Principal',
      routeName: administrator,
    ),
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
      routeName: quotations,
    ),
    DrawerItemConfig(
      icon: Icons.request_quote,
      title: 'Historial cotizaciones',
      routeName: quotationsHistory,
    ),
    DrawerItemConfig(
      icon: Icons.percent,
      title: 'Descuentos',
      routeName: discounts,
    ),
    DrawerItemConfig(
      icon: Icons.person_pin_rounded,
      title: 'Consultar visitas',
      routeName: requestVisit,
    ),
    DrawerItemConfig(
      icon: Icons.door_front_door_rounded,
      title: 'Salir',
      routeName: exit,
    ),
  ];
}
