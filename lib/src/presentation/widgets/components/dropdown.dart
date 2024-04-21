import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final double width;
  final double height;
  final double widthItems;
  final double? border;
  final ValueChanged<String?>? onChanged;
  final double? padding;

  const CustomDropdown({
    Key? key,
    required this.options,
    required this.width,
    required this.widthItems,
    this.onChanged,
    this.border,
    required this.height,
    this.padding,
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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Container(
      width: screenWidth * widget.width,
      height: screenHeight * widget.height,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.border ?? 30),
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
                    fontSize:
                        isTablet ? screenWidth * 0.027 : screenWidth * 0.04,
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

class CustomDropdownInitial extends StatefulWidget {
  final List<String> options;
  final double width;
  final double height;
  final double widthItems;
  final double? border;
  final ValueChanged<String?>? onChanged;
  final double? padding;
  final String initialValue;

  const CustomDropdownInitial({
    Key? key,
    required this.options,
    required this.width,
    required this.widthItems,
    this.onChanged,
    this.border,
    required this.height,
    this.padding,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<CustomDropdownInitial> createState() => _CustomDropdownInitial();
}

class _CustomDropdownInitial extends State<CustomDropdownInitial> {
  String selectedOption = "";

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * widget.width,
      height: screenHeight * widget.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.border ?? 30),
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
              selectedOption = newValue!;
            });
            widget.onChanged!.call(newValue);
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

class CustomDropdownService extends StatefulWidget {
  final List<Service> options;
  final double width;
  final double height;
  final double widthItems;
  final double? border;
  final ValueChanged<Service?>? onChanged;
  final double? padding;

  const CustomDropdownService({
    Key? key,
    required this.options,
    required this.width,
    required this.widthItems,
    this.onChanged,
    this.border,
    required this.height,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomDropdownService> createState() => _CustomDropdownService();
}

class _CustomDropdownService extends State<CustomDropdownService> {
  Service? selectedOption;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * widget.width,
      height: screenHeight * widget.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.border ?? 30),
        color: Palette.grey,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: DropdownButton<Service>(
          value: selectedOption,
          underline: Container(
            height: 0,
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Palette.textColor),
          elevation: 1,
          borderRadius: BorderRadius.circular(15),
          onChanged: (Service? newValue) {
            setState(() {
              selectedOption = newValue;
            });
            widget.onChanged?.call(newValue);
          },
          items: widget.options.map<DropdownMenuItem<Service>>((Service value) {
            return DropdownMenuItem<Service>(
              value: value,
              child: SizedBox(
                width: screenWidth * widget.widthItems,
                child: Text(
                  value.name,
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
