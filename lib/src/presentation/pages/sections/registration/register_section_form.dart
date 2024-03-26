import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';

import '../../../../domain/controllers/controllers.dart';
import '../../../utils/utils.dart';
import '../../../widgets/components/components.dart';

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

    String status = "activo";
    if (name.isNotEmpty && description.isNotEmpty && icon.isNotEmpty) {
      sectionsController
          .registerSection(icon, name, description, status)
          .then((value) async {
        MessageHandler.showMessageSuccess('Registro de sección exitoso', value);
      }).catchError((error) {
        MessageHandler.showMessageError('Error al registrar sección', error);
      });
      _onCancelForm();
    } else {
      MessageHandler.showMessageWarning('Validación de campos',
          'Ingrese los campos requeridos para poder registrar');
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
              child: Text(
                "Registrar Sección",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.15),
                          child: Text(
                            "Elige un icono",
                            style: GoogleFonts.varelaRound(
                              color: Colors.white,
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
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
                                  handleIconClick(index,
                                      "${IconList.icons[index]["icon"]}");
                                },
                                onLongPress: () {},
                                isActive: activeIndex == index,
                              );
                            },
                          ),
                        ),
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
                      hintText: 'Descripcion',
                      maxLine: 8,
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
                            onPressed: registerSection,
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
