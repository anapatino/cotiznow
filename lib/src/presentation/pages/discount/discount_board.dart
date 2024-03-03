import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/presentation/widgets/class/dialog_util.dart';

import '../../../domain/domain.dart';
import '../../routes/routes.dart';
import '../../widgets/components/components.dart';

// ignore: must_be_immutable
class Discount extends StatefulWidget {
  UserController userController = Get.find();
  MaterialsController materialController = Get.find();

  Discount({super.key});

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  double screenWidth = 0;
  double screenHeight = 0;
  List<Materials> filteredMaterials = [];

  Widget _buildMaterials() {
    return FutureBuilder<List<Materials>>(
      future: widget.materialController.getAllMaterials(),
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
                Get.toNamed('/details-material', arguments: material);
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
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              actions: const [],
            ),
            drawer: CustomDrawer(
              name: widget.userController.name,
              email: widget.userController.userEmail,
              itemConfigs: AdministratorRoutes().itemConfigs,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.055,
                  vertical: screenHeight * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Descuentos",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildMaterials(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Palette.primary,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              shape: const CircleBorder(),
            ),
          ),
        ));
  }

  Future<void> showDeleteAlert(Materials material) async {
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar descuento',
      message: '¿Desea eliminar este descuento?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        try {
          String message =
              await widget.materialController.updateDiscount(material.id, "");
          Get.snackbar(
            'Éxito',
            message,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            backgroundColor: Palette.accent,
            icon: const Icon(Icons.check_circle),
          );
        } catch (e) {
          Get.snackbar(
            'Error al eliminar descuento',
            e.toString(),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            backgroundColor: Palette.error,
            icon: const Icon(Icons.error_rounded),
          );
        }
      },
      backgroundConfirmButton: Palette.errorBackground,
      backgroundCancelButton: Palette.error,
      backgroundColor: Palette.error,
    );
  }
}
