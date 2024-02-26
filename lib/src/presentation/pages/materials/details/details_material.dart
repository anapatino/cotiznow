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
    material = Materials(
        urlPhoto: parameters?['urlPhoto'],
        name: parameters?['name'],
        code: parameters?['code'],
        unit: parameters?['unit'],
        size: parameters?['size'],
        purchasePrice: parameters?['purchasePrice'],
        salePrice: parameters?['salePrice'],
        sectionId: parameters?['sectionId'],
        quantity: parameters?['quantity'],
        description: parameters?['description'],
        id: parameters?['id'],
        status: parameters?['status']);
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Text(
                "Detalles material",
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
