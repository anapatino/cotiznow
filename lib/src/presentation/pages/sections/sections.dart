import 'package:cotiznow/lib.dart';
import '../../../domain/controllers/user_controller.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/drawer.dart';

// ignore: must_be_immutable
class Sections extends StatelessWidget {
  UserController userController = Get.find();

  Sections({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: userController.name,
            email: userController.userEmail,
            itemConfigs: AdministratorRoutes().itemConfigs,
            context: context,
          ),
          body: const Center(
            child: Text(
              "bienvenido secciones",
              style: TextStyle(color: Colors.black),
            ),
          )),
    );
  }
}
