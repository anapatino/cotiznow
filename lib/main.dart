import 'dart:developer';

import 'package:cotiznow/lib.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/domain/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(UserController());

    runApp(const App());
  } catch (e) {
    log("Error al iniciar la aplicación: $e");
  }
}
