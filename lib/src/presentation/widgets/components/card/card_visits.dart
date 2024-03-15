import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/models/models.dart';

class CardVisits extends StatelessWidget {
  final Color backgroundColor;
  final ProgrammeVisits programmeVisits;
  final Function onTap;
  final Function onLongPress;
  final Function onDoubleTap;
  final bool showCardClient;

  const CardVisits({
    Key? key,
    required this.onLongPress,
    required this.backgroundColor,
    required this.programmeVisits,
    required this.onTap,
    required this.onDoubleTap,
    this.showCardClient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        onTap();
      },
      onLongPress: () {
        onLongPress();
      },
      onDoubleTap: () {
        onDoubleTap();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.02),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.08,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!showCardClient)
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: Text(
                      "Visita programada por ${programmeVisits.user.name} ${programmeVisits.user.lastName}",
                      style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.049,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: Text(
                    'Fecha de registro: ${programmeVisits.date}',
                    style: GoogleFonts.varelaRound(
                      fontSize: showCardClient
                          ? screenWidth * 0.04
                          : screenWidth * 0.035,
                      fontWeight:
                          showCardClient ? FontWeight.w700 : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: Text(
                    'Estado: ${programmeVisits.status}',
                    style: GoogleFonts.varelaRound(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (showCardClient)
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: Text(
                      "Motivo: ${programmeVisits.motive}",
                      style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.037,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
