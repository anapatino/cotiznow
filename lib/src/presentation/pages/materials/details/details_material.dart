import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/entities/material.dart';

// ignore: must_be_immutable
class MaterialDetails extends StatelessWidget {
  final material = Get.arguments as Materials;
  UserController userController = Get.find();

  MaterialDetails({super.key});

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
                        color: Palette.accent,
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
              top: screenHeight * 0.48,
              child: Container(
                width: screenWidth * 1,
                height: screenHeight * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(29),
                    topRight: Radius.circular(29),
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
