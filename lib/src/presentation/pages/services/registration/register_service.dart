import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/entities/service.dart';
import 'package:cotiznow/src/presentation/utils/utils.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';
import 'package:cotiznow/src/presentation/widgets/components/components.dart';

class RegisterServiceForm extends StatefulWidget {
  final Function onCancelForm;

  const RegisterServiceForm({
    Key? key,
    required this.onCancelForm,
  }) : super(key: key);

  @override
  State<RegisterServiceForm> createState() => _RegisterServiceFormState();
}

class _RegisterServiceFormState extends State<RegisterServiceForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();

  ServicesController serviceController = Get.find();
  int activeIndex = -1;
  String icon = "";
  String selectMeasures = "";
  @override
  void dispose() {
    super.dispose();
    _resetForm();
  }

  void _resetForm() {
    controllerName.clear();
    controllerDescription.clear();
    icon = "";
  }

  void _onCancelForm() {
    _resetForm();
    widget.onCancelForm();
  }

  Future<void> registerService() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String price = controllerPrice.text;
    String status = "activo";
    String measures = selectMeasures == "si" ? "true" : "false";
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        icon.isNotEmpty &&
        price.isNotEmpty &&
        measures.isNotEmpty) {
      Service service = Service(
          id: '',
          icon: icon,
          name: name,
          description: description,
          status: status,
          price: price,
          measures: measures);
      serviceController.registerService(service).then((value) async {
        MessageHandler.showMessageSuccess(
            'Registro de servicio exitoso', value);
      }).catchError((error) {
        MessageHandler.showMessageError('Error al registrar servicio', error);
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

    List<String> options = ["si", "no"];

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        _onCancelForm();
      },
      child: BounceInUp(
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
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.04,
                ),
                child: Text(
                  "Registrar servicio",
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
                        maxLine: 8,
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
                      CustomTextField(
                        type: TextInputType.number,
                        icon: Icons.money,
                        hintText: 'Precio',
                        isPassword: false,
                        width: screenWidth * 0.75,
                        height: screenHeight * 0.15,
                        inputColor: Colors.white,
                        textColor: Colors.black,
                        onChanged: (value) {},
                        controller: controllerPrice,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.01),
                            child: Text(
                              "El servicio requiere medidas?",
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
                          CustomDropdown(
                            padding: 0,
                            border: 10,
                            options: options,
                            width: 0.75,
                            height: 0.075,
                            widthItems: 0.55,
                            onChanged: (value) {
                              setState(() {
                                selectMeasures = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet
                              ? screenWidth * 0.13
                              : screenWidth * 0.07,
                          vertical: screenHeight * 0.05,
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
                              textSize: isTablet
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.04,
                              borderColor: Palette.accent,
                              backgroundColor: Palette.accent,
                              hasBorder: true,
                            ),
                            CustomElevatedButton(
                              text: 'Registrar',
                              onPressed: registerService,
                              height: screenHeight * 0.065,
                              width: screenWidth * 0.35,
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
                      SizedBox(height: screenHeight * 0.15)
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
