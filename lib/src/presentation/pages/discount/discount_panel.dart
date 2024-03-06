import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import '../../../domain/domain.dart';
import '../../widgets/widgets.dart';

// ignore: must_be_immutable
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
        filteredMaterials = materials
            .where((material) =>
                material.status == 'activo' && material.discount != "")
            .toList();

        return _buildCardMaterial(filteredMaterials);
      },
    );
  }

  Widget _buildCardMaterial(List<Materials> materials) {
    return Expanded(
      child: SizedBox(
        width: screenWidth * 1,
        height: screenHeight * 0.7,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: materials.length,
          itemBuilder: (context, index) {
            Materials material = materials[index];

            return CardMaterialSimple(
                material: material,
                onClick: () {
                  Get.toNamed('/update-discounts', arguments: material);
                },
                onLongPress: showDeleteAlert,
                onDoubleTap: () {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
            horizontal: screenWidth * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
          onPressed: () {
            Get.toNamed('/register-discounts');
          },
          backgroundColor: Palette.primary,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape: const CircleBorder(),
        ),
      ),
    );
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
              await materialController.updateDiscount(material.id, "");
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
