import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class CardQuotation extends StatelessWidget {
  final Quotation quotation;
  final Function onLongPress;

  const CardQuotation(
      {super.key, required this.onLongPress, required this.quotation});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: InkWell(
        onTap: () {
          Get.toNamed('/details-quotation', arguments: {
            'name': quotation.name,
            'description': quotation.description,
            'id_section': quotation.idSection,
            'id_service': quotation.idService,
            'length': quotation.length,
            'materials': quotation.materials.values
                .map((material) => material.toJson())
                .toList(),
            'status': quotation.status,
            'total': quotation.total,
            'width': quotation.width,
          });
        },
        onLongPress: () {
          onLongPress();
        },
        child: Expanded(
          child: Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.138,
            decoration: BoxDecoration(
              color: Palette.accent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.55,
                    child: Text(
                      quotation.name,
                      style: GoogleFonts.varelaRound(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    'Estado: ${quotation.status}',
                    style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: screenWidth * 0.55,
                    child: Text(
                      quotation.description,
                      style: GoogleFonts.varelaRound(
                          fontSize: screenWidth * 0.025,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Text(
                    'Total: ${quotation.total}',
                    style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
