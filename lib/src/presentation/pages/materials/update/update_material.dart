import 'dart:ui';

import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';

import '../../../widgets/components/components.dart';
import '../../../widgets/components/loading/loading_page.dart';

class UpdateFormMaterial extends StatefulWidget {
  final Function onCancelForm;
  final Materials material;

  const UpdateFormMaterial({
    Key? key,
    required this.onCancelForm,
    required this.material,
  }) : super(key: key);

  @override
  State<UpdateFormMaterial> createState() => _UpdateFormMaterialState();
}

class _UpdateFormMaterialState extends State<UpdateFormMaterial> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerUnit = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerSalePrice = TextEditingController();
  TextEditingController controllerPurchasePrice = TextEditingController();
  TextEditingController controllerCode = TextEditingController();
  TextEditingController controllerSectionInitial = TextEditingController();
  List<String> optionsSection = [];
  List<Section> sections = [];
  MaterialsController materialController = Get.find();
  SectionsController sectionsController = Get.find();
  UnitsController unitsController = Get.find();
  String urlPhoto = "";
  String? selectedOption;
  String? selectedOptionSectionId;
  List<String> options = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMaterial();
  }

  Future<void> loadMaterial() async {
    try {
      await loadSections();
      await loadSectionName();
      await loadUnits();
      controllerName.text = widget.material.name;
      controllerUnit.text = widget.material.unit;
      controllerDescription.text = widget.material.description;
      controllerQuantity.text = widget.material.quantity;
      controllerSalePrice.text = widget.material.salePrice;
      controllerPurchasePrice.text = widget.material.purchasePrice;
      controllerCode.text = widget.material.code;
      selectedOption = widget.material.size;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      MessageHandler.showMessageError(
          'Error al cargar información del material', e);
    }
  }

  void _resetForm() {
    controllerName.clear();
    controllerUnit.clear();
    controllerDescription.clear();
    controllerQuantity.clear();
    controllerSalePrice.clear();
    controllerPurchasePrice.clear();
    controllerCode.clear();
    urlPhoto = "";
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
      MessageHandler.showUnitsLoadingError(error);

      _onCancelForm();
    }
  }

  Future<void> loadSections() async {
    try {
      sections = await sectionsController.getAllSections();
      setState(() {
        optionsSection = sections
            .where((section) => section.status == "activo")
            .map((section) => section.name)
            .toList();
      });
    } catch (error) {
      MessageHandler.showSectionLoadingError(error);
      _onCancelForm();
    }
  }

  Future<void> loadSectionName() async {
    try {
      setState(() {
        Section section = sections
            .firstWhere((section) => section.id == widget.material.sectionId);
        controllerSectionInitial.text = section.name;
      });
    } catch (error) {
      MessageHandler.showSectionLoadingError(error);
      _onCancelForm();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        urlPhoto = pickedFile.path;
      });
    }
  }

  bool validateFields(String name, String description, String unit,
      String quantity, String salePrice, String purchasePrice, String code) {
    return name.isNotEmpty &&
        description.isNotEmpty &&
        unit.isNotEmpty &&
        quantity.isNotEmpty &&
        salePrice.isNotEmpty &&
        code.isNotEmpty &&
        purchasePrice.isNotEmpty;
  }

  Future<void> updateMaterial() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String unit = controllerUnit.text;
    String quantity = controllerQuantity.text;
    String sectionId = selectedOptionSectionId != null
        ? selectedOptionSectionId!
        : widget.material.sectionId;
    String salePrice = controllerSalePrice.text;
    String purchasePrice = controllerPurchasePrice.text;
    String code = controllerCode.text;
    String size =
        selectedOption != null ? selectedOption! : widget.material.size;
    if (validateFields(
        name, description, unit, quantity, salePrice, purchasePrice, code)) {
      if (urlPhoto.isEmpty) {
        urlPhoto = widget.material.urlPhoto;
      }

      Materials material = Materials(
        urlPhoto: urlPhoto,
        name: name,
        unit: unit,
        size: size,
        purchasePrice: purchasePrice,
        salePrice: salePrice,
        sectionId: sectionId,
        quantity: quantity,
        description: description,
        status: widget.material.status,
        id: widget.material.id,
        code: code,
        discount: widget.material.discount,
      );

      try {
        String message = await materialController.updateMaterial(
            material, widget.material.urlPhoto);
        MessageHandler.showMessageSuccess(
            'Actualización realizada con éxito', message);
        _onCancelForm();
      } catch (error) {
        MessageHandler.showMessageError('Error al actualizar material', error);
      }
    } else {
      MessageHandler.showMessageWarning('Validación de campos',
          'Ingrese los campos requeridos para poder actualizar');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (isLoading) {
      return const LoadingScreen();
    }
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        _onCancelForm();
      },
      child: BounceInUp(
        duration: const Duration(microseconds: 10),
        child: Container(
          width: screenWidth * 1,
          height: screenHeight * 1,
          decoration: const BoxDecoration(
            color: Palette.accent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                child: Text(
                  "Actualizar material",
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
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.15),
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
                              onLongPress: () {},
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
                      CustomTextField(
                        icon: Icons.dehaze_rounded,
                        hintText: 'Unidad',
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
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.035),
                        child: CustomDropdownInitial(
                          initialValue: selectedOption!,
                          padding: 0,
                          border: 10,
                          options: options,
                          width: 0.75,
                          height: 0.075,
                          widthItems: 0.55,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOption = newValue;
                            });
                          },
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
                          CustomDropdownInitial(
                            padding: 0,
                            border: 10,
                            initialValue: controllerSectionInitial.text,
                            options: optionsSection,
                            width: 0.75,
                            height: 0.075,
                            widthItems: 0.55,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOptionSectionId = newValue;
                              });
                              if (newValue != null) {
                                Section section = sections.firstWhere(
                                    (section) => section.name == newValue);
                                selectedOptionSectionId = section.id;
                              }
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
                              text: 'Actualizar',
                              onPressed: updateMaterial,
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
      ),
    );
  }
}
