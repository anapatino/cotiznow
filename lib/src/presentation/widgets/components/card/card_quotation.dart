import 'package:cotiznow/lib.dart';

class CardQuotation extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String description;
  final String status;
  final String total;
  final Function onTap;
  final Function onLongPress;
  final Function onDoubleTap;
  final bool showDescription;
  final bool showIcon;
  final Function icon;

  const CardQuotation(
      {super.key,
      required this.onLongPress,
      required this.backgroundColor,
      this.showDescription = false,
      this.showIcon = false,
      required this.title,
      required this.description,
      required this.status,
      required this.total,
      required this.onTap,
      required this.icon,
      required this.onDoubleTap});

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
                SizedBox(
                  width: screenWidth * 0.7,
                  child: Text(
                    title,
                    style: GoogleFonts.varelaRound(
                      fontSize: screenWidth * 0.049,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Estado: $status',
                  style: GoogleFonts.varelaRound(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                if (showDescription)
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: Text(
                      description,
                      style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.033,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total: $total',
                      style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.047,
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
                          size: screenWidth * 0.098,
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
