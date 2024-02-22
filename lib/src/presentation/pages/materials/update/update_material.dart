import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

import '../../../widgets/components/components.dart';

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

  MaterialsController materialController = Get.find();
  String urlPhoto = "";
  String? selectedOption;
  String? selectedOptionSectionId;

  @override
  void initState() {
    super.initState();
    controllerName.text = widget.material.name;
    controllerUnit.text = widget.material.unit;
    controllerDescription.text = widget.material.description;
    controllerQuantity.text = widget.material.quantity;
    controllerSalePrice.text = widget.material.salePrice;
    controllerPurchasePrice.text = widget.material.purchasePrice;
    controllerCode.text = widget.material.code;
  }

  void _resetForm() {
    controllerName.clear();
    controllerUnit.clear();
    controllerDescription.clear();
    controllerQuantity.clear();
    controllerSalePrice.clear();
    controllerPurchasePrice.clear();
    controllerCode.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _onCancelForm();
  }

  void _onCancelForm() {
    widget.onCancelForm();
    _resetForm();
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

  Future<void> updateMaterial() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String unit = controllerUnit.text;
    String size = selectedOption!;
    String quantity = controllerQuantity.text;
    String sectionId = selectedOptionSectionId!;
    String salePrice = controllerSalePrice.text;
    String purchasePrice = controllerPurchasePrice.text;
    String code = controllerCode.text;
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        unit.isNotEmpty &&
        size.isNotEmpty &&
        quantity.isNotEmpty &&
        sectionId.isNotEmpty &&
        salePrice.isNotEmpty &&
        code.isNotEmpty &&
        purchasePrice.isNotEmpty) {
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
      );
      materialController
          .updateMaterial(material, widget.material.urlPhoto)
          .then((value) async {
        Get.snackbar(
          'Actualizacion de material exitoso',
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
    List<String> options = ['m2', 'm'];
    List<String> optionsSection = ['m2', 'm'];

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Text(
                "Actualizar material",
                style: GoogleFonts.varelaRound(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: CustomTextField(
                        icon: Icons.dehaze_rounded,
                        hintText: 'Unidad',
                        isPassword: false,
                        width: screenWidth * 0.34,
                        height: screenHeight * 0.075,
                        inputColor: Colors.white,
                        textColor: Colors.black,
                        onChanged: (value) {},
                        controller: controllerUnit,
                        showIcon: false,
                        type: TextInputType.number,
                      ),
                    ),
                    CustomDropdown(
                      padding: 0,
                      border: 10,
                      options: options,
                      width: 0.39,
                      height: 0.075,
                      widthItems: 0.18,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
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
    );
  }
}
