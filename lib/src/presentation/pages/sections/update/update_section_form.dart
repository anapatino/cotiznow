import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';

import '../../../../domain/domain.dart';
import '../../../utils/utils.dart';
import '../../../widgets/components/components.dart';

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
    String status = "activo";
    Section section = Section(
        id: widget.section.id,
        icon: icon,
        name: name,
        description: description,
        status: status);
    if (name.isNotEmpty && description.isNotEmpty && icon.isNotEmpty) {
      sectionsController.updateSection(section).then((value) async {
        MessageHandler.showMessageSuccess(
            'Actualización de sección exitosa', value);
      }).catchError((error) {
        MessageHandler.showMessageError(
            'Error al actualizar la sección', error);
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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        _onCancelForm();
      },
      child: BounceInUp(
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
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.04,
                ),
                child: Text(
                  "Actualizar sección",
                  style: GoogleFonts.varelaRound(
                    color: Colors.white,
                    fontSize:
                        isTablet ? screenWidth * 0.04 : screenWidth * 0.05,
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
                                fontSize: isTablet
                                    ? screenWidth * 0.025
                                    : screenWidth * 0.03,
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
                                  isActive: activeIndex == index,
                                  onLongPress: () {},
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
                          horizontal: isTablet
                              ? screenWidth * 0.13
                              : screenWidth * 0.07,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomElevatedButton(
                              text: 'Cancelar',
                              onPressed: _onCancelForm,
                              height: screenHeight * 0.065,
                              width: isTablet
                                  ? screenWidth * 0.32
                                  : screenWidth * 0.35,
                              textColor: Colors.white,
                              textSize: isTablet
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.04,
                              borderColor: Palette.accent,
                              backgroundColor: Palette.accent,
                              hasBorder: true,
                            ),
                            CustomElevatedButton(
                              text: 'Actualizar',
                              onPressed: updateSection,
                              height: screenHeight * 0.065,
                              width: isTablet
                                  ? screenWidth * 0.32
                                  : screenWidth * 0.35,
                              textColor: Colors.white,
                              textSize: isTablet
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.04,
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
