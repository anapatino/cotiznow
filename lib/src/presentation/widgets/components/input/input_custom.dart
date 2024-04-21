// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cotiznow/lib.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final double width;
  final double height;
  final Color inputColor;
  final Color textColor;
  final double? border;
  final bool? isEnable;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final int? maxLine;
  final TextInputType? type;
  final bool? showIcon;

  CustomTextField({
    required this.icon,
    required this.hintText,
    this.isPassword = false,
    this.width = 200.0,
    this.height = 50.0,
    this.inputColor = Colors.white,
    this.textColor = Colors.black,
    this.onChanged,
    required this.controller,
    this.border,
    this.isEnable = true,
    this.maxLine = 1,
    this.type = TextInputType.text,
    this.showIcon = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showError = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double? border = widget.border ?? 10;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return SizedBox(
      height: widget.height + screenHeight * 0.032,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.inputColor,
              borderRadius: BorderRadius.circular(border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.showIcon == true)
                    Icon(
                      widget.icon,
                      color: Palette.textlabel,
                      size: isTablet ? 40 : 24,
                    ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      keyboardType: widget.type,
                      maxLines: widget.maxLine,
                      enabled: widget.isEnable,
                      controller: widget.controller,
                      obscureText:
                          widget.isPassword ? _obscureText : widget.isPassword,
                      onChanged: (value) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                        setState(() {
                          _showError = value.isEmpty;
                        });
                      },
                      cursorColor: Palette.textlabel,
                      cursorHeight: 22,
                      style: GoogleFonts.varelaRound(
                        color: widget.textColor,
                        fontSize: isTablet
                            ? screenWidth * 0.027
                            : screenWidth * 0.037,
                        fontWeight: FontWeight.w100,
                        letterSpacing: 1,
                      ),
                      decoration: InputDecoration(
                        labelText: widget.hintText,
                        labelStyle: GoogleFonts.varelaRound(
                          color: widget.textColor,
                          fontSize: isTablet
                              ? screenWidth * 0.03
                              : screenWidth * 0.04,
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: widget.inputColor,
                      ),
                    ),
                  ),
                  if (widget.isPassword)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: const Color.fromARGB(255, 176, 176, 176),
                        size: isTablet ? 40 : 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_showError)
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001),
              child: Text(
                'Este campo no puede estar vacío',
                style: GoogleFonts.varelaRound(
                  color: Colors.red,
                  fontSize:
                      isTablet ? screenWidth * 0.023 : screenWidth * 0.035,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
