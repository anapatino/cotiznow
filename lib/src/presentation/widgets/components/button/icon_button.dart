import 'package:cotiznow/lib.dart';

import '../../../utils/icon_list.dart';

class RoundIconButton extends StatelessWidget {
  final String icon;
  final String title;
  final Function onClick;
  final Function onLongPress;
  final bool isBackgroundImage;

  final bool isActive;

  const RoundIconButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onClick,
    this.isActive = false,
    required this.onLongPress,
    this.isBackgroundImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 0.0001 : screenWidth * 0.009,
          vertical: isTablet ? screenHeight * 0.001 : screenHeight * 0.003),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              onClick();
            },
            onLongPress: () {
              onLongPress();
            },
            child: Container(
              width: isTablet ? screenWidth * 0.09 : screenWidth * 0.18,
              height: isTablet ? screenWidth * 0.09 : screenWidth * 0.18,
              decoration: BoxDecoration(
                color: isActive
                    ? Palette.primary
                    : isBackgroundImage
                        ? Palette.backgroundImage
                        : Palette.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  IconList.getIconDataFromString(icon),
                  color: isActive
                      ? Colors.white
                      : isBackgroundImage
                          ? Palette.backgroundImage
                          : Palette.textColor,
                  size: isTablet ? screenWidth * 0.045 : screenWidth * 0.085,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.012),
          SizedBox(
            width: screenWidth * 0.2,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.varelaRound(
                  color: Palette.textColor,
                  fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.03,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
