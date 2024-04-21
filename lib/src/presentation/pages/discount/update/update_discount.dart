import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/entities/material.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';
import '../../../widgets/components/components.dart';

// ignore: must_be_immutable
class UpdateDiscount extends StatelessWidget {
  TextEditingController controllerDiscount = TextEditingController();
  final material = Get.arguments as Materials;
  UserController userController = Get.find();
  MaterialsController materialController = Get.find();
  UpdateDiscount({super.key});

  void clearControllers() {
    controllerDiscount.clear();
  }

  void updateDiscount(BuildContext context) async {
    int discount = int.parse(controllerDiscount.text);
    try {
      if (discount > 0) {
        double newDiscount = discount / 100;
        String message = await materialController.updateDiscount(
            material.id, newDiscount.toString());
        MessageHandler.showMessageSuccess(
            'Actualización de descuento', message);
        materialController.getAllMaterials();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        MessageHandler.showMessageSuccess(
            'Validación de campos', 'Intente ingresar un numero mayor a 0');
      }
    } catch (e) {
      MessageHandler.showMessageError('Error al actualizar descuento', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    int salePrice = 0;
    double percentage = 0;
    double discount = 0;
    if (material.discount != "") {
      salePrice = int.parse(material.salePrice);

      percentage = double.parse(material.discount);
      discount = salePrice - (salePrice * percentage);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight * 1,
          child: Stack(
            children: [
              Container(
                width: screenWidth * 1,
                height: screenHeight * 0.5,
                decoration: const BoxDecoration(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: material.urlPhoto.isNotEmpty
                    ? Image.network(
                        material.urlPhoto,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
              ),
              Positioned(
                top: screenHeight * 0.04,
                left: screenWidth * 0.05,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                    size: isTablet ? 45.0 : 20.0,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: screenHeight * 0.3,
                child: Container(
                  width: screenWidth * 1,
                  height: screenHeight * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.11,
                        vertical: screenHeight * 0.06),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            material.name,
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: isTablet
                                  ? screenWidth * 0.044
                                  : screenWidth * 0.064,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                          Text(
                            'Codigo: ${material.code}',
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: isTablet
                                  ? screenWidth * 0.034
                                  : screenWidth * 0.045,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1,
                            ),
                          ),
                          Text(
                            'Cantidad disponible: ${material.quantity}',
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: isTablet
                                  ? screenWidth * 0.034
                                  : screenWidth * 0.045,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1,
                            ),
                          ),
                          Text(
                            'Descripción',
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: isTablet
                                  ? screenWidth * 0.036
                                  : screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                          Text(
                            material.description,
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: isTablet
                                  ? screenWidth * 0.034
                                  : screenWidth * 0.045,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.02),
                            child: Row(
                              children: [
                                Text(
                                  'Precio: ${material.salePrice}',
                                  style: GoogleFonts.varelaRound(
                                    color: Colors.black,
                                    fontSize: isTablet
                                        ? screenWidth * 0.038
                                        : screenWidth * 0.055,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * 0.01),
                                  child: Text(
                                    material.size,
                                    style: GoogleFonts.varelaRound(
                                      color: Colors.black,
                                      fontSize: isTablet
                                          ? screenWidth * 0.038
                                          : screenWidth * 0.055,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                                if (percentage > 0)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Text(
                                      '${(percentage * 100).round()}% descuento',
                                      style: GoogleFonts.varelaRound(
                                        color: Palette.accent,
                                        fontSize: isTablet
                                            ? screenWidth * 0.028
                                            : screenWidth * 0.041,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (material.discount != "")
                            Text(
                              'Total: ${discount.round()}',
                              style: GoogleFonts.varelaRound(
                                color: Palette.accent,
                                fontSize: isTablet
                                    ? screenWidth * 0.05
                                    : screenWidth * 0.069,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          if (userController.role != "cliente")
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("  Modificar descuento",
                                      style: GoogleFonts.varelaRound(
                                        color: Colors.black,
                                        fontSize: isTablet
                                            ? screenWidth * 0.025
                                            : screenWidth * 0.035,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1,
                                      )),
                                  CompactTextField(
                                    type: TextInputType.number,
                                    hintText: '',
                                    width: screenWidth * 0.33,
                                    height: 0.075,
                                    inputColor: Palette.grey,
                                    textColor: Palette.textColor,
                                    onChanged: (value) {},
                                    controller: controllerDiscount,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomElevatedButton(
                                          text: 'Limpiar',
                                          onPressed: clearControllers,
                                          height: screenHeight * 0.059,
                                          width: screenWidth * 0.35,
                                          textColor: Palette.error,
                                          textSize: isTablet
                                              ? screenWidth * 0.028
                                              : screenWidth * 0.033,
                                          backgroundColor: Colors.white,
                                          hasBorder: true,
                                          borderColor: Palette.error,
                                        ),
                                        CustomElevatedButton(
                                          text: 'Modificar',
                                          onPressed: () {
                                            updateDiscount(context);
                                          },
                                          height: screenHeight * 0.059,
                                          width: screenWidth * 0.35,
                                          textColor: Colors.white,
                                          textSize: isTablet
                                              ? screenWidth * 0.028
                                              : screenWidth * 0.033,
                                          backgroundColor: Palette.primary,
                                          hasBorder: false,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
