import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/presentation/widgets/class/dialog_util.dart';

import '../../routes/routes.dart';
import '../../widgets/components/components.dart';

// ignore: must_be_immutable
class Discount extends StatefulWidget {
  UserController userController = Get.find();

  Discount({super.key});

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isContainerVisible = false;
  void _toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
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
            name: widget.userController.name,
            email: widget.userController.userEmail,
            itemConfigs: AdministratorRoutes().itemConfigs,
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
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
                  ],
                ),
              ),
              /*Positioned(
              top: isContainerVisible
                  ? screenHeight * 0.02
                  : screenHeight * 0.97,
              child: SingleChildScrollView(
                child: AdministratorRegistration(
                  onCancelRegistration: () {
                    _toggleContainerVisibility();
                  },
                ),
              ),
            ),*/
            ],
          ),
          floatingActionButton: isContainerVisible
              ? const SizedBox()
              : FloatingActionButton(
                  onPressed: _toggleContainerVisibility,
                  backgroundColor: Palette.primary,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  shape: const CircleBorder(),
                ),
        ));
  }

  Future<void> showDeleteAlert(Material material) async {
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar descuento',
      message: '¿Desea eliminar este descuento?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        //String message = await widget.userController.deleteUser(material);
        Get.snackbar(
          'Éxito',
          '',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
      },
      backgroundConfirmButton: Palette.errorBackground,
      backgroundCancelButton: Palette.error,
      backgroundColor: Palette.error,
    );
  }
}
