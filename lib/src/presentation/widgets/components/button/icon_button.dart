import 'package:cotiznow/lib.dart';

import '../../../utils/icon_list.dart';

class RoundIconButton extends StatelessWidget {
  final String icon;
  final String title;
  final Function onClick;
  final Function onLongPress;

  final bool isActive;

  const RoundIconButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onClick,
    this.isActive = false,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              onClick();
            },
            onLongPress: () {
              onLongPress();
            },
            child: Container(
              width: screenWidth * 0.18,
              height: screenWidth * 0.18,
              decoration: BoxDecoration(
                color: isActive ? Palette.primary : Palette.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  IconList.getIconDataFromString(icon),
                  color: isActive ? Colors.white : Palette.textColor,
                  size: screenWidth * 0.085,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.012),
          Text(
            title,
            style: GoogleFonts.varelaRound(
              color: Palette.textColor,
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
