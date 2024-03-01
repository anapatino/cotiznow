import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

import '../../../../../domain/domain.dart';

class InformationServices extends StatefulWidget {
  final TextEditingController controllerLength;
  final TextEditingController controllerWidth;
  final VoidCallback onBack;

  const InformationServices(
      {super.key,
      required this.onBack,
      required this.controllerLength,
      required this.controllerWidth});

  @override
  State<InformationServices> createState() => _InformationServicesState();
}

class _InformationServicesState extends State<InformationServices> {
  SectionsController sectionsController = Get.find();
  ServicesController servicesController = Get.find();
  List<String> optionsService = [];
  List<Service> services = [];
  List<String> optionsSection = [];
  List<Section> sections = [];
  String? selectedOptionSection;
  String? selectedOptionService;

  @override
  void initState() {
    super.initState();
    loadSectionsAndServices();
  }

  Future<void> loadSectionsAndServices() async {
    try {
      sections = await sectionsController.getAllSections();
      services = await servicesController.getAllServices();
      setState(() {
        optionsSection = sections.map((section) => section.name).toList();
        optionsService = services.map((services) => services.name).toList();
      });
    } catch (error) {
      print("Error loading sections: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  Servicios",
            style: GoogleFonts.varelaRound(
              color: Palette.textColor,
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            )),
        CustomDropdown(
          padding: 0,
          border: 10,
          options: optionsService,
          width: 0.75,
          height: 0.075,
          widthItems: 0.55,
          onChanged: (String? newValue) {
            setState(() {
              selectedOptionService = newValue;
            });
          },
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Text("  Seccion",
            style: GoogleFonts.varelaRound(
              color: Palette.textColor,
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            )),
        CustomDropdown(
          padding: 0,
          border: 10,
          options: optionsSection,
          width: 0.75,
          height: 0.075,
          widthItems: 0.55,
          onChanged: (String? newValue) {
            setState(() {
              selectedOptionSection = newValue;
            });
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          child: Text("Medidas de la sección",
              style: GoogleFonts.varelaRound(
                color: Palette.textColor,
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Largo",
                style: GoogleFonts.varelaRound(
                  color: Palette.textColor,
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                )),
            CustomTextField(
              icon: Icons.dehaze_rounded,
              hintText: '',
              isPassword: false,
              width: screenWidth * 0.34,
              height: screenHeight * 0.075,
              inputColor: Colors.white,
              textColor: Colors.black,
              onChanged: (value) {},
              controller: widget.controllerLength,
              showIcon: false,
              type: TextInputType.number,
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ancho",
                style: GoogleFonts.varelaRound(
                  color: Palette.textColor,
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                )),
            CustomTextField(
              icon: Icons.dehaze_rounded,
              hintText: '',
              isPassword: false,
              width: screenWidth * 0.34,
              height: screenHeight * 0.075,
              inputColor: Colors.white,
              textColor: Colors.black,
              onChanged: (value) {},
              controller: widget.controllerLength,
              showIcon: false,
              type: TextInputType.number,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                text: 'Cancelar',
                onPressed: widget.onBack,
                height: screenHeight * 0.055,
                width: screenWidth * 0.28,
                textColor: Palette.textColor,
                textSize: screenWidth * 0.03,
                borderColor: Colors.white,
                backgroundColor: Colors.white,
                hasBorder: true,
              ),
              CustomElevatedButton(
                text: 'Continuar',
                onPressed: () {},
                height: screenHeight * 0.055,
                width: screenWidth * 0.29,
                textColor: Colors.white,
                textSize: screenWidth * 0.03,
                backgroundColor: Palette.accent,
                hasBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
