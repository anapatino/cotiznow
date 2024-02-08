import 'package:cotiznow/lib.dart';

class CardUser extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const CardUser(
      {super.key,
      required this.name,
      required this.email,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
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
              width: screenWidth * 0.2,
              height: screenHeight * 0.15,
              decoration: const BoxDecoration(
                color: Palette.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
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
                    name,
                    style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  'Correo: $email',
                  style: GoogleFonts.varelaRound(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  'Teléfono: $phone',
                  style: GoogleFonts.varelaRound(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w300),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
