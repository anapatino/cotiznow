import 'package:cotiznow/lib.dart';

class RoundIconButton extends StatefulWidget {
  final String icon;
  final String title;
  final Function onClick;
  final bool isActive; // Nueva propiedad

  const RoundIconButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onClick,
    this.isActive = false,
  }) : super(key: key);

  @override
  _RoundIconButtonState createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton> {
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
              widget.onClick();
            },
            child: Container(
              width: screenWidth * 0.18,
              height: screenWidth * 0.18,
              decoration: BoxDecoration(
                color: widget.isActive ? Palette.primary : Palette.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.access_time_rounded,
                  color: widget.isActive ? Colors.white : Palette.textColor,
                  size: screenWidth * 0.085,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.012),
          Text(
            widget.title,
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
