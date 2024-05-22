import 'package:cotiznow/lib.dart';

class CardQuotation extends StatelessWidget {
  final Color backgroundColor;
  final String name;
  final String address;
  final String phone;
  final String status;
  final String total;
  final Function onTap;
  final Function onLongPress;
  final Function onDoubleTap;
  final bool showMoreInfo;
  final bool showIcon;
  final Function icon;
  final bool isHistory;
  final String? date;

  const CardQuotation({
    super.key,
    required this.onLongPress,
    required this.backgroundColor,
    this.showMoreInfo = false,
    this.showIcon = false,
    required this.name,
    required this.address,
    required this.phone,
    required this.status,
    required this.total,
    required this.onTap,
    required this.icon,
    required this.onDoubleTap,
    this.isHistory = false,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

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
        padding: EdgeInsets.only(
            bottom: screenHeight * 0.02,
            right: isTablet ? screenWidth * 0.1 : 0),
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
                if (isHistory)
                  Text(
                    'Fecha: $date',
                    style: GoogleFonts.varelaRound(
                      fontSize:
                          isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: Text(
                    name,
                    style: GoogleFonts.varelaRound(
                      fontSize:
                          isTablet ? screenWidth * 0.039 : screenWidth * 0.049,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Estado: $status',
                  style: GoogleFonts.varelaRound(
                    fontSize:
                        isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                if (showMoreInfo)
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ubicación: $address",
                          style: GoogleFonts.varelaRound(
                            fontSize: isTablet
                                ? screenWidth * 0.028
                                : screenWidth * 0.033,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Telefono: $phone",
                          style: GoogleFonts.varelaRound(
                            fontSize: isTablet
                                ? screenWidth * 0.028
                                : screenWidth * 0.033,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total: $total',
                      style: GoogleFonts.varelaRound(
                        fontSize: isTablet
                            ? screenWidth * 0.037
                            : screenWidth * 0.047,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (showIcon)
                      IconButton(
                        onPressed: () {
                          icon();
                        },
                        icon: Icon(
                          Icons.download_for_offline_rounded,
                          color: Colors.white,
                          size: isTablet
                              ? screenWidth * 0.07
                              : screenWidth * 0.098,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
