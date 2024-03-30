import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

import '../../../../../domain/domain.dart';

class InformationServices extends StatefulWidget {
  final TextEditingController controllerLength;
  final TextEditingController controllerWidth;
  final VoidCallback onBack;
  final Function(String) onSelected;

  const InformationServices(
      {super.key,
      required this.onBack,
      required this.controllerLength,
      required this.controllerWidth,
      required this.onSelected});

  @override
  State<InformationServices> createState() => _InformationServicesState();
}

class _InformationServicesState extends State<InformationServices> {
  TextEditingController controllerPrice = TextEditingController();
  SectionsController sectionsController = Get.find();
  ServicesController servicesController = Get.find();
  MaterialsController materialController = Get.find();
  QuotationController quotationController = Get.find();
  ShoppingCartController shoppingCartController = Get.find();

  double screenWidth = 0;
  double screenHeight = 0;
  List<String> optionsService = [];
  List<Service> services = [];
  List<String> optionsSection = [];
  List<Section> sections = [];
  List<Materials> filteredMaterials = [];

  String? selectedOptionSection;
  String? selectedOptionService;
  String sectionId = "";

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
        optionsSection = sections
            .where((section) => section.status == "activo")
            .map((section) => section.name)
            .toList();
        optionsService = services
            .where((service) => service.status == "activo")
            .map((service) => service.name)
            .toList();
      });
    } catch (error) {
      MessageHandler.showMessageWarning(
          "Error al cargar las secciones/servicios", error);
    }
  }

  void saveQuotation() {
    double materialsTotal = shoppingCartController.calculateMaterialsTotal();

    int servicesTotal = shoppingCartController.calculateServicesTotal();
    int iva = 19;
    int total = materialsTotal.round() + servicesTotal;
    int newTotal = (total + (total * iva / 100)).toInt();
    widget.onSelected(
      newTotal.toString(),
    );
  }

  void _onServiceDropdownChanged(String? newValue) {
    setState(() {
      selectedOptionService = newValue;
      if (selectedOptionService != null) {
        Service service = services.firstWhere(
          (service) => service.name == selectedOptionService,
        );
        controllerPrice.text = service.price;
        shoppingCartController.toggleSelectedService(service);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final MaterialWidgets materialWidgets = MaterialWidgets(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
    );

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
          onChanged: _onServiceDropdownChanged,
        ),
        if (controllerPrice.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: CustomTextField(
              isEnable: false,
              icon: Icons.money,
              hintText: 'Precio',
              maxLine: 1,
              isPassword: false,
              width: screenWidth * 0.75,
              height: screenHeight * 0.075,
              inputColor: Palette.grey,
              textColor: Palette.textColor,
              onChanged: (value) {},
              controller: controllerPrice,
            ),
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
            if (newValue != null) {
              Section section =
                  sections.firstWhere((section) => section.name == newValue);
              sectionId = section.id;
            }
          },
        ),
        if (sectionId.isNotEmpty)
          materialWidgets.buildMaterialsBySectionId(sectionId),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Largo",
                style: GoogleFonts.varelaRound(
                  color: Palette.textColor,
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                )),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.015,
              ),
              child: CompactTextField(
                hintText: '',
                width: screenWidth * 0.23,
                height: 0.075,
                inputColor: Palette.grey,
                textColor: Palette.textColor,
                onChanged: (value) {},
                controller: widget.controllerLength,
              ),
            ),
            Text("Ancho",
                style: GoogleFonts.varelaRound(
                  color: Palette.textColor,
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                )),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.015,
              ),
              child: CompactTextField(
                hintText: '',
                width: screenWidth * 0.23,
                height: 0.075,
                inputColor: Palette.grey,
                textColor: Palette.textColor,
                onChanged: (value) {},
                controller: widget.controllerWidth,
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          child: Text("Servicios seleccionados",
              style: GoogleFonts.varelaRound(
                color: Palette.accent,
                fontSize: screenWidth * 0.042,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              )),
        ),
        Text(
          shoppingCartController.selectService.isEmpty
              ? "No hay servicios seleccionados"
              : shoppingCartController.selectService
                  .map((service) => service.name)
                  .join(", "),
          style: GoogleFonts.varelaRound(
            color: Palette.textColor,
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          child: Text("Materiales seleccionados",
              style: GoogleFonts.varelaRound(
                color: Palette.accent,
                fontSize: screenWidth * 0.042,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              )),
        ),
        if (shoppingCartController.cartItems.isNotEmpty)
          materialWidgets.buildCardMaterialCart(
            shoppingCartController.cartItems,
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                text: 'Cancelar',
                onPressed: widget.onBack,
                height: screenHeight * 0.058,
                width: screenWidth * 0.33,
                textColor: Palette.textColor,
                textSize: screenWidth * 0.039,
                borderColor: Colors.white,
                backgroundColor: Colors.white,
                hasBorder: true,
              ),
              CustomElevatedButton(
                text: 'Cotizar',
                onPressed: saveQuotation,
                height: screenHeight * 0.058,
                width: screenWidth * 0.33,
                textColor: Colors.white,
                textSize: screenWidth * 0.039,
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
