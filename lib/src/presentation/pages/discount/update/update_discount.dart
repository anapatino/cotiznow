import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/material.dart';
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
        Get.snackbar(
          'Actualización de descuento',
          message,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        Get.snackbar(
          'Validar campos',
          'Intente ingresar un numero mayor a 0',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.error),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error al actualizar descuento',
        '$e',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.error,
        icon: const Icon(Icons.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int salePrice = int.parse(material.salePrice);
    double percentage = 0;
    double discount = 0;
    if (material.discount != "") {
      percentage = double.parse(material.discount);
      discount = salePrice - (salePrice * percentage);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: screenHeight * 1,
        child: Stack(
          children: [
            Container(
              width: screenWidth * 1,
              height: screenHeight * 0.5,
              decoration: const BoxDecoration(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: material.url_photo.isNotEmpty
                  ? Image.network(
                      material.url_photo,
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
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: screenHeight * 0.35,
              child: Container(
                width: screenWidth * 1,
                height: screenHeight * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
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
                            fontSize: screenWidth * 0.064,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                        Text(
                          'Codigo: ${material.code}',
                          style: GoogleFonts.varelaRound(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.1,
                          ),
                        ),
                        Text(
                          'Cantidad disponible: ${material.quantity}',
                          style: GoogleFonts.varelaRound(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.1,
                          ),
                        ),
                        Text(
                          'Descripción',
                          style: GoogleFonts.varelaRound(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                        Text(
                          material.description,
                          style: GoogleFonts.varelaRound(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
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
                                  fontSize: screenWidth * 0.055,
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
                                    fontSize: screenWidth * 0.055,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                              if (percentage > 0)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * 0.02),
                                  child: Text(
                                    '${(percentage * 100).round()}% descuento',
                                    style: GoogleFonts.varelaRound(
                                      color: Palette.accent,
                                      fontSize: screenWidth * 0.041,
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
                              fontSize: screenWidth * 0.069,
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
                                      fontSize: screenWidth * 0.035,
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
                                  padding:
                                      EdgeInsets.only(top: screenHeight * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomElevatedButton(
                                        text: 'Anular',
                                        onPressed: clearControllers,
                                        height: screenHeight * 0.059,
                                        width: screenWidth * 0.35,
                                        textColor: Palette.error,
                                        textSize: screenWidth * 0.033,
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
                                        textSize: screenWidth * 0.033,
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
    );
  }
}
