import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/section_controller.dart';
import 'package:cotiznow/src/domain/models/section.dart';

import '../../utils/icon_list.dart';
import '../../widgets/components/button/button.dart';
import '../../widgets/components/button/icon_button.dart';
import '../../widgets/components/input.dart';

class UpdateSectionForm extends StatefulWidget {
  final Function onCancelForm;
  final Section section;

  const UpdateSectionForm({
    Key? key,
    required this.onCancelForm,
    required this.section,
  }) : super(key: key);

  @override
  State<UpdateSectionForm> createState() => _UpdateSectionFormState();
}

class _UpdateSectionFormState extends State<UpdateSectionForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  SectionsController sectionsController = Get.find();
  int activeIndex = -1;
  String icon = "";

  @override
  void initState() {
    super.initState();
    controllerDescription.text = widget.section.description;
    controllerName.text = widget.section.name;
  }

  void _resetForm() {
    controllerName.clear();
    controllerDescription.clear();
  }

  void _onCancelForm() {
    widget.onCancelForm();
    _resetForm();
  }

  Future<void> updateSection() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String status = "enable";
    Section section = Section(
        id: widget.section.id,
        icon: icon,
        name: name,
        description: description,
        status: status);
    if (name.isNotEmpty && description.isNotEmpty && icon.isNotEmpty) {
      sectionsController.updateSection(section).then((value) async {
        Get.snackbar(
          'Actualización de sección exitoso',
          value,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
      }).catchError((error) {
        Get.snackbar(
          'Error al actualizar sección',
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
        'Error al actualizar sección',
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
                "Actualizar sección",
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
                            isActive: activeIndex == index,
                            onLongPress: () {},
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
                      text: 'Actualizar',
                      onPressed: updateSection,
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
