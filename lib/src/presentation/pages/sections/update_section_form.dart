import 'package:cotiznow/lib.dart';

import '../../widgets/components/button/button.dart';
import '../../widgets/components/input.dart';

class UpdateSectionForm extends StatefulWidget {
  final String icon;
  final Function onCancelUpdate;
  final String name;
  final String description;

  const UpdateSectionForm({
    Key? key,
    required this.icon,
    required this.onCancelUpdate,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  State<UpdateSectionForm> createState() => _UpdateSectionFormState();
}

class _UpdateSectionFormState extends State<UpdateSectionForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void _resetForm() {
    controllerName.clear();
    controllerDescription.clear();
  }

  void _onCancelUpdate() {
    widget.onCancelUpdate();
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BounceInUp(
      duration: const Duration(microseconds: 10),
      child: Container(
        width: screenWidth * 1,
        height: screenHeight * 0.5,
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
              height: screenHeight * 0.04,
            ),
            CustomTextField(
              icon: Icons.person,
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
              icon: Icons.person,
              hintText: 'Descripcion',
              isPassword: false,
              width: screenWidth * 0.75,
              height: screenHeight * 0.075,
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
                    onPressed: _onCancelUpdate,
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
                    onPressed: () {
                      // Acciones al hacer clic en "Registrar"
                    },
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
          ],
        ),
      ),
    );
  }
}
