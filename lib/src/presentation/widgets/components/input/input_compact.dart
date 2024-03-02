import 'package:cotiznow/lib.dart';

class CompactTextField extends StatefulWidget {
  final String hintText;
  final Color inputColor;
  final double width;
  final double? border;

  final double height;
  final Color textColor;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType? type;

  // ignore: use_key_in_widget_constructors
  const CompactTextField({
    required this.hintText,
    this.inputColor = Colors.white,
    this.textColor = Colors.black,
    required this.controller,
    this.onChanged,
    this.type = TextInputType.text,
    this.width = 200.0,
    this.height = 50.0,
    this.border,
  });

  @override
  State<CompactTextField> createState() => _CompactTextFieldState();
}

class _CompactTextFieldState extends State<CompactTextField> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double? border = widget.border ?? 10;

    return Container(
      width: widget.width,
      height: screenHeight * widget.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: TextField(
          keyboardType: widget.type,
          enabled: true,
          controller: widget.controller,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          cursorColor: widget.textColor,
          style: GoogleFonts.varelaRound(
            color: widget.textColor,
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(border),
              borderSide: BorderSide.none,
            ),
            labelText: widget.hintText,
            labelStyle: GoogleFonts.varelaRound(
              color: widget.textColor,
              fontSize: screenWidth * 0.04,
            ),
            filled: true,
            fillColor: widget.inputColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (mounted) {
      widget.controller.dispose();
    }
    super.dispose();
  }
}
