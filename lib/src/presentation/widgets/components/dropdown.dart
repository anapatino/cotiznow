import 'package:cotiznow/lib.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final double width;
  final double widthItems;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.options,
    required this.width,
    required this.widthItems,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * widget.width,
      height: screenHeight * 0.06,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Palette.grey,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: DropdownButton<String>(
          value: selectedOption,
          underline: Container(
            height: 0,
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Palette.textColor),
          elevation: 1,
          borderRadius: BorderRadius.circular(15),
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue;
            });
            widget.onChanged?.call(newValue);
          },
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                width: screenWidth * widget.widthItems,
                child: Text(
                  value,
                  style: GoogleFonts.varelaRound(
                    color: Colors.black,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
