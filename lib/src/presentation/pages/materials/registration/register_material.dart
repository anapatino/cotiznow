import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/presentation/widgets/components/components.dart';

import '../../../../domain/models/models.dart';

class RegisterMaterialForm extends StatefulWidget {
  final Function onCancelForm;

  const RegisterMaterialForm({
    Key? key,
    required this.onCancelForm,
  }) : super(key: key);

  @override
  State<RegisterMaterialForm> createState() => _RegisterMaterialFormState();
}

class _RegisterMaterialFormState extends State<RegisterMaterialForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerUnit = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerSalePrice = TextEditingController();
  TextEditingController controllerPurchasePrice = TextEditingController();
  TextEditingController controllerCode = TextEditingController();
  TextEditingController controllerRegisterUnit = TextEditingController();
  List<String> optionsSection = [];
  List<Section> sections = [];
  List<String> options = [];
  MaterialsController materialController = Get.find();
  SectionsController sectionsController = Get.find();
  UnitsController unitsController = Get.find();

  String url_photo = "";
  String? selectedOption;
  String? selectedOptionSectionId;
  bool showControllerRegister = false;

  void _resetForm() {
    controllerName.clear();
    controllerUnit.clear();
    controllerDescription.clear();
    controllerQuantity.clear();
    controllerSalePrice.clear();
    controllerPurchasePrice.clear();
    controllerCode.clear();
    controllerRegisterUnit.clear();
  }

  @override
  void initState() {
    super.initState();
    loadSections();
    loadUnits();
  }

  void _onCancelForm() {
    widget.onCancelForm();
    _resetForm();
  }

  Future<void> loadUnits() async {
    try {
      List<Units> unitsList = await unitsController.getAllUnits();
      setState(() {
        options = unitsList.map((unit) => unit.name).toList();
      });
    } catch (error) {
      print("Error loading units: $error");
    }
  }

  Future<void> loadSections() async {
    try {
      sections = await sectionsController.getAllSections();
      setState(() {
        optionsSection = sections.map((section) => section.name).toList();
      });
    } catch (error) {
      print("Error loading sections: $error");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        url_photo = pickedFile.path;
      });
    }
  }

  Future<void> registerMaterial() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String unit = controllerUnit.text;
    String size = "";
    String quantity = controllerQuantity.text;
    String sectionId = selectedOptionSectionId!;
    String salePrice = controllerSalePrice.text;
    String purchasePrice = controllerPurchasePrice.text;
    String code = controllerCode.text;
    String status = "activo";
    String newUnit = controllerRegisterUnit.text;
    if (selectedOption != null) {
      size = selectedOption!;
    } else {
      size = "";
    }
    if (newUnit.isNotEmpty) {
      size = newUnit;
      String message = await unitsController.registerUnit(newUnit);
    }
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        quantity.isNotEmpty &&
        sectionId.isNotEmpty &&
        salePrice.isNotEmpty &&
        code.isNotEmpty &&
        purchasePrice.isNotEmpty) {
      Section sectionFound = sections.firstWhere(
        (section) => section.name == selectedOptionSectionId,
        orElse: () => throw "Sección no encontrada",
      );
      Materials material = Materials(
        url_photo: url_photo,
        name: name,
        unit: unit,
        size: size,
        purchasePrice: purchasePrice,
        salePrice: salePrice,
        sectionId: sectionFound.id,
        quantity: quantity,
        description: description,
        status: status,
        id: "",
        code: code,
        discount: '',
      );
      materialController.registerMaterial(material).then((value) async {
        Get.snackbar(
          'Registro de material exitoso',
          value,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
      }).catchError((error) {
        Get.snackbar(
          'Error al registrar material',
          '$error',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.error,
          icon: const Icon(Icons.error),
        );
      });
      _onCancelForm();
    } else {
      Get.snackbar(
        'Error al registrar material',
        'Ingrese los campos requeridos para poder registrar',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BounceInUp(
      duration: const Duration(microseconds: 10),
      child: Container(
        width: screenWidth * 1,
        height: screenHeight * 0.9,
        decoration: const BoxDecoration(
          color: Palette.accent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
              child: Text(
                "Registrar material",
                style: GoogleFonts.varelaRound(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Agregar imagen ",
                            style: GoogleFonts.varelaRound(
                              color: Colors.white,
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          RoundIconButton(
                            icon: "Icons.add",
                            title: "",
                            onClick: _pickImage,
                            onLongPress: () {
                              setState(() {
                                showControllerRegister !=
                                    showControllerRegister;
                              });
                            },
                            isBackgroundImage: true,
                          )
                        ],
                      ),
                    ),
                    CustomTextField(
                      icon: Icons.dehaze_rounded,
                      hintText: 'Codigo',
                      type: TextInputType.number,
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Colors.white,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: controllerCode,
                    ),
                    CustomTextField(
                      icon: Icons.dehaze_rounded,
                      hintText: 'Nombre',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Colors.white,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: controllerName,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.13,
                          vertical: screenHeight * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Agregar unidades",
                            style: GoogleFonts.varelaRound(
                              color: Colors.white,
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                            child: CustomTextField(
                              icon: Icons.dehaze_rounded,
                              hintText: 'Valor unidad',
                              isPassword: false,
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.075,
                              inputColor: Colors.white,
                              textColor: Colors.black,
                              onChanged: (value) {},
                              controller: controllerUnit,
                              showIcon: false,
                              type: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDropdown(
                                  padding: 0,
                                  border: 10,
                                  options: options,
                                  width: 0.55,
                                  height: 0.075,
                                  widthItems: 0.33,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedOption = newValue;
                                    });
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showControllerRegister =
                                          !showControllerRegister;
                                    });
                                  },
                                  icon: Icon(
                                    showControllerRegister
                                        ? Icons.remove
                                        : Icons.add,
                                    color: Palette.accentBackground,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: showControllerRegister,
                            child: CustomTextField(
                              icon: Icons.dehaze_rounded,
                              hintText: 'Nueva unidad',
                              isPassword: false,
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.075,
                              inputColor: Colors.white,
                              textColor: Colors.black,
                              onChanged: (value) {},
                              controller: controllerRegisterUnit,
                              showIcon: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomTextField(
                      icon: Icons.dehaze_rounded,
                      hintText: 'Precio compra',
                      type: TextInputType.number,
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Colors.white,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: controllerPurchasePrice,
                    ),
                    CustomTextField(
                      icon: Icons.dehaze_rounded,
                      type: TextInputType.number,
                      hintText: 'Precio venta',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Colors.white,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: controllerSalePrice,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("  Seccion",
                            style: GoogleFonts.varelaRound(
                              color: Colors.white,
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
                              selectedOptionSectionId = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    CustomTextField(
                      icon: Icons.dehaze_rounded,
                      hintText: 'Cantidad',
                      type: TextInputType.number,
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Colors.white,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: controllerQuantity,
                    ),
                    CustomTextField(
                      icon: Icons.dehaze_rounded,
                      hintText: 'Descripcion',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.17,
                      maxLine: 8,
                      inputColor: Colors.white,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: controllerDescription,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomElevatedButton(
                            text: 'Cancelar',
                            onPressed: _onCancelForm,
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.35,
                            textColor: Colors.white,
                            textSize: screenWidth * 0.04,
                            borderColor: Palette.accent,
                            backgroundColor: Palette.accent,
                            hasBorder: true,
                          ),
                          CustomElevatedButton(
                            text: 'Registrar',
                            onPressed: registerMaterial,
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.35,
                            textColor: Colors.white,
                            textSize: screenWidth * 0.04,
                            backgroundColor: Palette.primary,
                            hasBorder: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
