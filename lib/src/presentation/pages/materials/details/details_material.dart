import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/entities/material.dart';
import 'package:cotiznow/src/presentation/pages/materials/materials.dart';

class MaterialDetails extends StatefulWidget {
  const MaterialDetails({super.key});

  @override
  State<MaterialDetails> createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<MaterialDetails> {
  final material = Get.arguments as Materials;
  UserController userController = Get.find();

  bool isUpdateFormVisible = false;

  void toggleUpdateFormVisibility() {
    setState(() {
      isUpdateFormVisible = !isUpdateFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    int salePrice = int.parse(material.salePrice);
    double percentage = 0;
    double discount = 0;
    if (material.discount != "") {
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
                width: screenWidth,
                height: screenHeight * 0.58,
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
                          color: Colors.blue,
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
                top: screenHeight * 0.48,
                child: Container(
                  width: screenWidth * 1,
                  height: screenHeight * 0.58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(29),
                      topRight: Radius.circular(29),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Precio: ${material.salePrice}',
                                  style: GoogleFonts.varelaRound(
                                    color: Colors.black,
                                    fontSize: isTablet
                                        ? screenWidth * 0.044
                                        : screenWidth * 0.055,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.1,
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
                                            ? screenWidth * 0.033
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
                                    ? screenWidth * 0.054
                                    : screenWidth * 0.069,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isUpdateFormVisible,
                child: Positioned(
                  top: screenHeight * 0.15,
                  child: UpdateFormMaterial(
                    onCancelForm: () {
                      toggleUpdateFormVisibility();
                    },
                    material: material,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isUpdateFormVisible
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: toggleUpdateFormVisibility,
              backgroundColor: Palette.accent,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              shape: const CircleBorder(),
            ),
    );
  }
}
