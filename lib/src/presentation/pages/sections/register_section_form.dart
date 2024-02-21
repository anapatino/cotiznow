import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/section_controller.dart';

import '../../utils/icon_list.dart';
import '../../widgets/components/button/button.dart';
import '../../widgets/components/button/icon_button.dart';
import '../../widgets/components/input.dart';

class RegisterSectionForm extends StatefulWidget {
  final Function onCancelForm;

  const RegisterSectionForm({
    Key? key,
    required this.onCancelForm,
  }) : super(key: key);

  @override
  State<RegisterSectionForm> createState() => _RegisterSectionFormState();
}

class _RegisterSectionFormState extends State<RegisterSectionForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  SectionsController sectionsController = Get.find();
  int activeIndex = -1;
  String icon = "";
  @override
  void initState() {
    super.initState();
  }

  void _resetForm() {
    controllerName.clear();
    controllerDescription.clear();
  }

  void _onCancelForm() {
    widget.onCancelForm();
    _resetForm();
  }

  Future<void> registerSection() async {
    String name = controllerName.text;
    String description = controllerDescription.text;

    String status = "enable";
    if (name.isNotEmpty && description.isNotEmpty && icon.isNotEmpty) {
      sectionsController
          .registerSection(icon, name, description, status)
          .then((value) async {
        Get.snackbar(
          'Registro de sección exitoso',
          value,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.supervised_user_circle_sharp),
        );
      }).catchError((error) {
        Get.snackbar(
          'Error al registrar sección',
          '$error',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.error,
          icon: const Icon(Icons.error_outline_rounded),
        );
      });
      _onCancelForm();
    } else {
      Get.snackbar(
        'Error al registrar sección',
        'Ingrese los campos requeridos para poder registrar',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.error_outline_rounded),
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
        height: screenHeight * 0.58,
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
                "Registrar Sección",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Elige un icono",
                      style: GoogleFonts.varelaRound(
                        color: Colors.white,
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: IconList.icons.length,
                        itemBuilder: (context, index) {
                          return RoundIconButton(
                            icon: "${IconList.icons[index]["icon"]}",
                            title: "${IconList.icons[index]["title"]}",
                            onClick: () {
                              handleIconClick(
                                  index, "${IconList.icons[index]["icon"]}");
                            },
                            onLongPress: () {},
                            isActive: activeIndex == index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                      onPressed: () {},
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

  void handleIconClick(int index, String newIcon) {
    setState(() {
      if (activeIndex == index) {
        activeIndex = -1;
      } else {
        activeIndex = index;
      }
      icon = newIcon;
    });
  }
}
