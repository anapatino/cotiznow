import 'package:cotiznow/lib.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Color? textColor;
  final double? textSize;
  final Color? backgroundColor;
  final bool hasBorder;
  final Color? borderColor;

  CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.textColor,
    this.textSize,
    this.backgroundColor,
    this.hasBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: hasBorder
              ? BorderSide(color: borderColor ?? Colors.transparent, width: 3)
              : BorderSide.none,
        ),
        child: Text(text,
            style: GoogleFonts.varelaRound(
              color: textColor,
              fontSize: textSize,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            )),
      ),
    );
  }
}
