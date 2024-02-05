import 'package:cotiznow/src/presentation/utils/colors.dart';
import 'package:cotiznow/lib.dart';

import '../widgets/components/button.dart';

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Palette.secondary,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight * 1,
          width: screenWidth * 1,
          child: Stack(
            children: [
              Positioned(
                top: -140,
                left: -80,
                child: Container(
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/triangle_lines.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.1,
                left: screenWidth * 0.2,
                child: const CircleAvatar(
                  backgroundColor: Palette.accent,
                  radius: 15,
                ),
              ),
              Positioned(
                top: screenHeight * 0.7,
                left: screenWidth * 0.06,
                child: Transform.rotate(
                  angle: -33,
                  alignment: Alignment.topLeft,
                  child: Text("CotizNow",
                      style: GoogleFonts.pacifico(
                        color: Palette.primary,
                        fontSize: screenWidth * 0.25,
                        letterSpacing: 1.6,
                      )),
                ),
              ),
              Positioned(
                top: screenHeight * 0.2,
                right: -120,
                child: Container(
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/triangle_lines.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -70,
                left: -120,
                child: Container(
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/triangle_lines.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.04,
                left: screenWidth * 0.14,
                child: SizedBox(
                  width: screenWidth * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ventas y cotizaciones al alcance de tu mano.",
                          style: GoogleFonts.varelaRound(
                            color: Colors.white,
                            fontSize: screenWidth * 0.049,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 1,
                          )),
                      Text("¡Negocio optimizado en un clic!",
                          style: GoogleFonts.varelaRound(
                            color: Colors.white,
                            fontSize: screenWidth * 0.049,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          )),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      CustomElevatedButton(
                        text: 'Ingresar',
                        onPressed: () {
                          print("le di click");
                        },
                        height: 50.0,
                        width: 150.0,
                        textColor: Palette.secondary,
                        textSize: screenWidth * 0.04,
                        backgroundColor: Palette.primary,
                        hasBorder: false,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
