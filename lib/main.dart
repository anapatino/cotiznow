import 'dart:developer';
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/domain/controllers/controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(UserController());
    Get.put(SectionsController());
    Get.put(MaterialsController());
    Get.put(ServicesController());
    Get.put(QuotationController());
    Get.put(UnitsController());

    runApp(const App());
  } catch (e) {
    log("Error al iniciar la aplicación: $e");
  }
}
