import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

import '../../../../../domain/domain.dart';

class InformationServices extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) onSelected;

  const InformationServices({
    super.key,
    required this.onBack,
    required this.onSelected,
  });

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
  bool isTablet = false;
  List<Service> services = [];
  List<String> optionsSection = [];
  List<Section> sections = [];
  List<Materials> filteredMaterials = [];

  String? selectedOptionSection;
  String sectionId = "";

  Map<String, TextEditingController> heightControllers = {};
  Map<String, TextEditingController> widthControllers = {};

  @override
  void initState() {
    super.initState();
    loadSectionsAndServices();
    loadControllers();
  }

  Future<void> loadControllers() async {
    setState(() {
      if (shoppingCartController.selectCustomizedService.isNotEmpty) {
        shoppingCartController.selectCustomizedService.forEach((service) {
          if (service.measures.height != "0" && service.measures.width != "0") {
            heightControllers[service.id] =
                TextEditingController(text: service.measures.height);
            widthControllers[service.id] =
                TextEditingController(text: service.measures.width);
          }
        });
      }
    });
  }

  Future<void> loadSectionsAndServices() async {
    try {
      sections = await sectionsController.getAllSections();
      services = await servicesController.getAllServices();
      setState(() {
        services =
            services.where((service) => service.status == "activo").toList();
        optionsSection = sections
            .where((section) => section.status == "activo")
            .map((section) => section.name)
            .toList();
      });
    } catch (error) {
      MessageHandler.showMessageWarning(
          "Error al cargar las secciones/servicios", error);
    }
  }

  void saveQuotation() {
    double materialsTotal = shoppingCartController.calculateMaterialsTotal();
    shoppingCartController.createCustomizedService(
        heightControllers, widthControllers);
    int servicesTotal = shoppingCartController.calculateServicesTotal();
    int iva = 19;
    int total = materialsTotal.round() + servicesTotal;
    int newTotal = (total + (total * iva / 100)).round();

    widget.onSelected(
      newTotal.toString(),
    );
  }

  void _onServiceDropdownChangedRegister(Service? service) {
    setState(() {
      if (service != null) {
        controllerPrice.text = service.price;
        if (shoppingCartController.selectCustomizedService.isNotEmpty) {
          shoppingCartController.toggleSelectedService(service);
        }
        if (shoppingCartController.selectService.contains(service)) {
          heightControllers.remove(service.id);
          widthControllers.remove(service.id);
        } else {
          if (service.measures == "true") {
            heightControllers[service.id] = TextEditingController();
            widthControllers[service.id] = TextEditingController();
          }
        }
        if (shoppingCartController.selectCustomizedService.isEmpty) {
          shoppingCartController.toggleSelectedService(service);
        }
      }
    });
  }

  void _onServiceDropdownChangedUpdate(Service? service) {
    setState(() {
      if (service != null) {
        controllerPrice.text = service.price;
        if (shoppingCartController.selectService.contains(service)) {
          heightControllers.remove(service.id);
          widthControllers.remove(service.id);
        } else {
          if (service.measures == "true") {
            heightControllers[service.id] = TextEditingController();
            widthControllers[service.id] = TextEditingController();
          }
        }
        shoppingCartController.toggleSelectedService(service);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isTablet = MediaQuery.of(context).size.shortestSide >= 600;

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
              fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            )),
        CustomDropdownService(
          padding: 0,
          border: 10,
          options: services,
          width: 0.75,
          height: 0.075,
          widthItems: isTablet ? 0.6 : 0.55,
          onChanged: _onServiceDropdownChangedRegister,
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
              fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            )),
        CustomDropdown(
          padding: 0,
          border: 10,
          options: optionsSection,
          width: 0.75,
          height: 0.075,
          widthItems: isTablet ? 0.6 : 0.55,
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
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          child: Text("Servicios seleccionados",
              style: GoogleFonts.varelaRound(
                color: Palette.accent,
                fontSize: isTablet ? screenWidth * 0.034 : screenWidth * 0.042,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              )),
        ),
        Column(
          children: [
            if (shoppingCartController.selectService.isEmpty)
              Text(
                "No hay servicios seleccionados",
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize:
                      isTablet ? screenWidth * 0.028 : screenWidth * 0.035,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                ),
              )
            else
              Column(
                children: shoppingCartController.selectService.map((service) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.name,
                        style: GoogleFonts.varelaRound(
                          color: Colors.black,
                          fontSize: isTablet
                              ? screenWidth * 0.028
                              : screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _onServiceDropdownChangedRegister(service);
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: shoppingCartController.selectService.map((option) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (heightControllers.containsKey(option.id) &&
                    widthControllers.containsKey(option.id))
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Text("Medidas(M) ${option.name}",
                        style: GoogleFonts.varelaRound(
                          color: Palette.textColor,
                          fontSize: isTablet
                              ? screenWidth * 0.029
                              : screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        )),
                  ),
                if (heightControllers.containsKey(option.id) &&
                    widthControllers.containsKey(option.id))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Largo",
                          style: GoogleFonts.varelaRound(
                            color: Palette.textColor,
                            fontSize: isTablet
                                ? screenWidth * 0.029
                                : screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.015,
                        ),
                        child: CompactTextField(
                          type: TextInputType.number,
                          hintText: '',
                          width: screenWidth * 0.23,
                          height: 0.075,
                          inputColor: Palette.grey,
                          textColor: Palette.textColor,
                          onChanged: (value) {},
                          controller: heightControllers[option.id]!,
                        ),
                      ),
                      Text("Ancho",
                          style: GoogleFonts.varelaRound(
                            color: Palette.textColor,
                            fontSize: isTablet
                                ? screenWidth * 0.029
                                : screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.015,
                        ),
                        child: CompactTextField(
                          type: TextInputType.number,
                          hintText: '',
                          width: screenWidth * 0.23,
                          height: 0.075,
                          inputColor: Palette.grey,
                          textColor: Palette.textColor,
                          onChanged: (value) {},
                          controller: widthControllers[option.id]!,
                        ),
                      ),
                    ],
                  ),
              ],
            );
          }).toList(),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          child: Text("Materiales seleccionados",
              style: GoogleFonts.varelaRound(
                color: Palette.accent,
                fontSize: isTablet ? screenWidth * 0.034 : screenWidth * 0.042,
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
                textSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.039,
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
                textSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.039,
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
