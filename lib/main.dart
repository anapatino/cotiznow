import 'dart:developer';

import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/material_controller.dart';
import 'package:cotiznow/src/domain/controllers/section_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/domain/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(UserController());
    Get.put(SectionsController());
    Get.put(MaterialsController());

    runApp(const App());
  } catch (e) {
    log("Error al iniciar la aplicación: $e");
  }
}
