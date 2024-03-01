import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/models/material.dart';

class MaterialDetails extends StatefulWidget {
  const MaterialDetails({super.key});

  @override
  State<MaterialDetails> createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<MaterialDetails> {
  Materials? material;
  Map<String, dynamic>? parameters = Get.arguments;

  @override
  void initState() {
    super.initState();
    material = Materials.createMaterialFromParameters(parameters);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: Column(
          children: [
            Container(
              width: screenWidth * 1,
              height: screenHeight * 0.3,
              decoration: const BoxDecoration(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: material!.url_photo.isNotEmpty
                  ? Image.network(
                      material!.url_photo,
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
            Container(
              width: screenWidth * 1,
              height: screenHeight * 0.59,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15,
                    vertical: screenHeight * 0.06),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material!.name,
                        style: GoogleFonts.varelaRound(
                          color: Colors.black,
                          fontSize: screenWidth * 0.064,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                      Text(
                        'Codigo: ${material!.code}',
                        style: GoogleFonts.varelaRound(
                          color: Colors.black,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.1,
                        ),
                      ),
                      Text(
                        'Cantidad disponible: ${material!.quantity}',
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
                        material!.description,
                        style: GoogleFonts.varelaRound(
                          color: Colors.black,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.1,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        child: Row(
                          children: [
                            Text(
                              'Precio: ${material!.salePrice}',
                              style: GoogleFonts.varelaRound(
                                color: Colors.black,
                                fontSize: screenWidth * 0.055,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                            Text(
                              material!.size,
                              style: GoogleFonts.varelaRound(
                                color: Colors.black,
                                fontSize: screenWidth * 0.055,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        material!.discount,
                        style: GoogleFonts.varelaRound(
                          color: Palette.accent,
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
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
