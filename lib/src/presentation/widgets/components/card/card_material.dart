import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class CardMaterialSimple extends StatelessWidget {
  final Materials material;
  final bool isLarge;
  final Function onClick;
  final Function onLongPress;
  final Function onDoubleTap;
  final bool showDescount;
  final bool showTotal;
  const CardMaterialSimple(
      {super.key,
      required this.material,
      required this.onClick,
      required this.onLongPress,
      required this.onDoubleTap,
      this.isLarge = true,
      this.showDescount = true,
      this.showTotal = false});

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
    double textPrincipal = isLarge ? screenWidth * 0.04 : screenWidth * 0.45;
    double widthContainer = isLarge ? screenWidth * 0.83 : screenWidth * 0.83;
    double heightContainer =
        isLarge ? screenHeight * 0.16 : screenHeight * 0.155;
    return Padding(
      padding: EdgeInsets.only(
          bottom: screenHeight * 0.02,
          right: isTablet ? screenWidth * 0.04 : 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
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
          width: isTablet ? screenWidth * 0.7 : widthContainer,
          height: heightContainer,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
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
                width: isTablet ? screenWidth * 0.22 : screenWidth * 0.27,
                height: double.infinity,
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
                    width: isLarge ? screenWidth * 0.45 : screenWidth * 0.45,
                    child: Text(
                      '${material.name} ${material.unit} ${material.size}',
                      style: GoogleFonts.varelaRound(
                          fontSize:
                              isTablet ? screenWidth * 0.03 : textPrincipal,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Codigo: ${material.code}',
                    style: GoogleFonts.varelaRound(
                        fontSize:
                            isTablet ? screenWidth * 0.025 : screenWidth * 0.03,
                        fontWeight: FontWeight.w300),
                  ),
                  if (percentage > 0)
                    Text(
                      'Antes: ${material.salePrice} ${material.size}',
                      style: GoogleFonts.varelaRound(
                          fontSize: isTablet
                              ? screenWidth * 0.022
                              : screenWidth * 0.028,
                          fontWeight: FontWeight.w300),
                    ),
                  if (showDescount != true)
                    Text(
                      'Cantidad: ${material.quantity}',
                      style: GoogleFonts.varelaRound(
                          fontSize: isTablet
                              ? screenWidth * 0.025
                              : screenWidth * 0.03,
                          fontWeight: FontWeight.w300),
                    ),
                  if (percentage > 0)
                    Text(
                      showTotal
                          ? '\$${(discount.round() * int.parse(material.quantity))}'
                          : '\$${discount.round()}',
                      style: GoogleFonts.varelaRound(
                          fontSize: isTablet
                              ? screenWidth * 0.03
                              : screenWidth * 0.04,
                          fontWeight: FontWeight.w600),
                    ),
                  if (percentage <= 0)
                    Text(
                      '\$${material.salePrice}',
                      style: GoogleFonts.varelaRound(
                          fontSize: isTablet
                              ? screenWidth * 0.03
                              : screenWidth * 0.038,
                          fontWeight: FontWeight.w600),
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
