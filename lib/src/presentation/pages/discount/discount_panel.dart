import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';

import '../../../domain/controllers/controllers.dart';
import '../../../domain/domain.dart';
import '../../widgets/components/components.dart';

class DiscountPanel extends StatelessWidget {
  UserController userController = Get.find();
  MaterialsController materialController = Get.find();
  double screenWidth = 0;
  double screenHeight = 0;
  List<Materials> filteredMaterials = [];
  DiscountPanel({super.key});

  Widget _buildMaterials() {
    return FutureBuilder<List<Materials>>(
      future: materialController.getAllMaterials(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        List<Materials> materials = snapshot.data!;
        filteredMaterials =
            materials.where((material) => material.status == 'activo').toList();

        return _buildCardMaterial(filteredMaterials);
      },
    );
  }

  Widget _buildCardMaterial(List<Materials> materials) {
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.7,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: materials.length,
        itemBuilder: (context, index) {
          Materials material = materials[index];

          return CardMaterialSimple(
              material: material,
              onClick: () {
                Get.toNamed('/details-material', arguments: {
                  'material': material,
                  'showDiscount': true,
                });
              },
              onLongPress: () {},
              onDoubleTap: () {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideInLeft(
      duration: const Duration(milliseconds: 15),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
        ),
        drawer: CustomDrawer(
          name: userController.name,
          email: userController.userEmail,
          itemConfigs: AdministratorRoutes().itemConfigs,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1, vertical: screenHeight * 0.1),
          child: Column(
            children: [
              Text(
                "Descuentos",
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              Text(
                'Hello World',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
