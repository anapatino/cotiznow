import 'package:cotiznow/lib.dart';

import '../../../domain/controllers/controllers.dart';
import '../../routes/routes.dart';
import '../../widgets/components/components.dart';

// ignore: must_be_immutable
class Administrator extends StatelessWidget {
  UserController userController = Get.find();

  Administrator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SlideInRight(
      duration: const Duration(milliseconds: 15),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.local_mall_outlined,
                  color: Palette.textColor,
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: screenWidth * 0.02,
              )
            ],
          ),
          drawer: CustomDrawer(
            name: userController.name,
            email: userController.userEmail,
            itemConfigs: AdministratorRoutes().itemConfigs,
            context: context,
          ),
          body: const Center(
            child: Text("Este es el dashboard"),
          ),
        ),
      ),
    );
  }
}
