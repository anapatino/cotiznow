import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import '../../../domain/domain.dart';
import '../../widgets/widgets.dart';

// ignore: must_be_immutable
class DiscountPanel extends StatefulWidget {
  const DiscountPanel({Key? key}) : super(key: key);

  @override
  State<DiscountPanel> createState() => _DiscountPanelState();
}

class _DiscountPanelState extends State<DiscountPanel> {
  UserController userController = Get.find();
  MaterialsController materialController = Get.find();
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    loadMaterials();
  }

  Future<void> loadMaterials() async {
    await materialController.getAllMaterials();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: SlideInLeft(
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
      ),
    );
  }

  Widget _buildMaterials() {
    setState(() {
      loadMaterials();
    });
    List<Materials> materials = materialController.materialsList!
        .where((material) =>
            material.status == 'activo' && material.discount != "")
        .toList();

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
                onLongPress: () => showDeleteAlert(material),
                onDoubleTap: () {});
          },
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
          MessageHandler.showMessageSuccess(
              'Se ha eliminado el descuento con exito', message);
        } catch (e) {
          MessageHandler.showMessageError('Error al eliminar descuento', e);
        }
      },
      backgroundConfirmButton: Palette.errorBackground,
      backgroundCancelButton: Palette.error,
      backgroundColor: Palette.error,
    );
  }
}
