import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class CardUser extends StatelessWidget {
  final Users user;

  final Function onLongPress;

  const CardUser({super.key, required this.user, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Padding(
      padding: EdgeInsets.only(
          bottom: screenHeight * 0.02,
          right: isTablet ? screenHeight * 0.04 : 0),
      child: InkWell(
        onTap: () {
          Get.toNamed('/profiles', arguments: user);
        },
        onLongPress: () {
          onLongPress();
        },
        child: Container(
          width: isTablet ? screenWidth * 0.55 : screenWidth * 0.85,
          height: isTablet ? screenHeight * 0.13 : screenHeight * 0.138,
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
                width: isTablet ? screenWidth * 0.14 : screenWidth * 0.2,
                height: isTablet ? screenHeight * 0.13 : screenHeight * 0.15,
                decoration: const BoxDecoration(
                  color: Palette.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: isTablet ? 50.0 : 40.0,
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
                      user.name,
                      style: GoogleFonts.varelaRound(
                          fontSize: isTablet
                              ? screenWidth * 0.035
                              : screenWidth * 0.045,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Correo: ${user.email}',
                    style: GoogleFonts.varelaRound(
                        fontSize:
                            isTablet ? screenWidth * 0.025 : screenWidth * 0.03,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Teléfono: ${user.phone}',
                    style: GoogleFonts.varelaRound(
                        fontSize:
                            isTablet ? screenWidth * 0.025 : screenWidth * 0.03,
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
