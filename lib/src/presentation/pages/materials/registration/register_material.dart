import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/presentation/widgets/components/components.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/models/material.dart';

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
  TextEditingController controllerSize = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerSectionId = TextEditingController();
  TextEditingController controllerSalePrice = TextEditingController();
  TextEditingController controllerPurchasePrice = TextEditingController();
  MaterialsController materialController = Get.find();
  String urlPhoto = "";

  void _resetForm() {
    controllerName.clear();
    controllerDescription.clear();
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

  Future<void> registerMaterial() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String unit = controllerUnit.text;
    String size = controllerSize.text;
    String quantity = controllerQuantity.text;
    String sectionId = controllerSectionId.text;
    String salePrice = controllerSalePrice.text;
    String purchasePrice = controllerPurchasePrice.text;
    String status = "enable";
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        unit.isNotEmpty &&
        size.isNotEmpty &&
        quantity.isNotEmpty &&
        sectionId.isNotEmpty &&
        salePrice.isNotEmpty &&
        purchasePrice.isNotEmpty) {
      Materials material = Materials(
        urlPhoto: "",
        name: name,
        unit: unit,
        size: size,
        purchasePrice: purchasePrice,
        salePrice: salePrice,
        sectionId: sectionId,
        quantity: quantity,
        description: description,
        status: status,
        id: "",
      );
      materialController.registerMaterial(material).then((value) async {
        Get.snackbar(
          'Registro de sección exitoso',
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
                "Registrar material",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  )
                ],
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
                hintText: 'Precio compra',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.15,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerDescription,
              ),
              CustomTextField(
                icon: Icons.dehaze_rounded,
                hintText: 'Precio venta',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.15,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerDescription,
              ),
              CustomTextField(
                icon: Icons.dehaze_rounded,
                hintText: 'cantidad',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.15,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerDescription,
              ),
              CustomTextField(
                icon: Icons.dehaze_rounded,
                hintText: 'Descripcion',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.15,
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
                height: screenHeight * 0.06,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
