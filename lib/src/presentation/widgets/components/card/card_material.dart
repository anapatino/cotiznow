import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class CardMaterialSimple extends StatelessWidget {
  final Materials material;
  final Function onClick;
  final Function onLongPress;
  final Function onDoubleTap;
  const CardMaterialSimple(
      {super.key,
      required this.material,
      required this.onClick,
      required this.onLongPress,
      required this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: InkWell(
        onTap: () {
          onClick();
        },
        onLongPress: () {
          onLongPress();
        },
        onDoubleTap: () {
          onDoubleTap();
        },
        child: Container(
          width: screenWidth * 0.85,
          height: screenHeight * 0.138,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 8),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.27,
                height: screenHeight * 0.15,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
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
              SizedBox(
                width: screenWidth * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.55,
                    child: Text(
                      material.name,
                      style: GoogleFonts.varelaRound(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Codigo: ${material.code}',
                    style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    '${material.salePrice} ${material.size}',
                    style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
