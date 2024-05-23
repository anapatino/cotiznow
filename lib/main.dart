import 'dart:developer';
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/domain/controllers/controllers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
     // Inicialización de notificaciones para Android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');


    // Configuración inicial para todas las plataformas
    const InitializationSettings initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(UserController());
    Get.put(SectionsController());
    Get.put(MaterialsController());
    Get.put(ServicesController());
    Get.put(QuotationController());
    Get.put(UnitsController());
    Get.put(ProgrammeVisitsController());
    Get.put(QuotationHistoryController());
    Get.put(ShoppingCartController());
    Get.put(ManagementController());
    Get.put(InvoiceController());

    runApp(const App());
  } catch (e) {
    log("Error al iniciar la aplicación: $e");
  }
}
