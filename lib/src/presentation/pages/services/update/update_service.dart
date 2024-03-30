import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/entities/service.dart';
import 'package:cotiznow/src/presentation/utils/utils.dart';
import 'package:cotiznow/src/presentation/widgets/components/components.dart';

import '../../../widgets/class/class.dart';

class UpdateServiceForm extends StatefulWidget {
  final Function onCancelForm;
  final Service service;

  const UpdateServiceForm({
    Key? key,
    required this.onCancelForm,
    required this.service,
  }) : super(key: key);

  @override
  State<UpdateServiceForm> createState() => _UpdateServiceFormState();
}

class _UpdateServiceFormState extends State<UpdateServiceForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();

  ServicesController serviceController = Get.find();
  int activeIndex = -1;
  String icon = "";

  @override
  void initState() {
    super.initState();
    controllerDescription.text = widget.service.description;
    controllerName.text = widget.service.name;
    controllerPrice.text = widget.service.price;
  }

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

  Future<void> updateService() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String price = controllerPrice.text;
    String status = "activo";
    Service service = Service(
        id: widget.service.id,
        icon: icon,
        name: name,
        description: description,
        status: status,
        price: price);
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        icon.isNotEmpty &&
        price.isNotEmpty) {
      serviceController.updateService(service).then((value) async {
        MessageHandler.showMessageSuccess(
            'Actualización de servicio exitos0', value);
      }).catchError((error) {
        MessageHandler.showMessageError(
            'Error al actualizar la servicio', error);
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
                "Actualizar servicio",
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
                            onPressed: updateService,
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
                      height: screenHeight * 0.22,
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
