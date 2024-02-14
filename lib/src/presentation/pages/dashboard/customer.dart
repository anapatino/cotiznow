import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/customer.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../widgets/components/drawer.dart';

// ignore: must_be_immutable
class Customer extends StatelessWidget {
  UserController userController = Get.find();

  Customer({super.key});

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
            itemConfigs: CustomerRoutes().itemConfigs,
            context: context,
          ),
          body: const Center(
            child: Text("Este es el dashboard clientes"),
          ),
        ),
      ),
    );
  }
}
