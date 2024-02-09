import 'package:cotiznow/lib.dart';

import '../../widgets/components/button.dart';
import '../../widgets/components/input.dart';

class AdministratorRegistration extends StatefulWidget {
  final Function onCancelRegistration;
  const AdministratorRegistration({
    super.key,
    required this.onCancelRegistration,
  });

  @override
  _AdministratorRegistrationState createState() =>
      _AdministratorRegistrationState();
}

class _AdministratorRegistrationState extends State<AdministratorRegistration> {
  late TextEditingController controllerName;
  late TextEditingController controllerLastName;
  late TextEditingController controllerPhone;
  late TextEditingController controllerEmail;
  late TextEditingController controllerPassword;
  late TextEditingController controllerAddress;
  late TextEditingController controllerRole;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerLastName = TextEditingController();
    controllerPhone = TextEditingController();
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
    controllerAddress = TextEditingController();
    controllerRole = TextEditingController();
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerLastName.dispose();
    controllerPhone.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerAddress.dispose();
    controllerRole.dispose();
    super.dispose();
  }

  void _onRegister() {
    _resetForm();
  }

  void _resetForm() {
    controllerName.clear();
    controllerLastName.clear();
    controllerPhone.clear();
    controllerEmail.clear();
    controllerPassword.clear();
    controllerAddress.clear();
    controllerRole.clear();
  }

  void _onCancelRegistration() {
    widget.onCancelRegistration();
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BounceInUp(
      duration: const Duration(microseconds: 10),
      child: Visibility(
        visible: true,
        child: Positioned(
          top: screenHeight * 0.3,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Text(
                  "Registrar cliente",
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
                  hintText: 'Apellido',
                  isPassword: false,
                  width: screenWidth * 0.75,
                  height: screenHeight * 0.075,
                  inputColor: Colors.white,
                  textColor: Colors.black,
                  onChanged: (value) {},
                  controller: controllerLastName,
                ),
                CustomTextField(
                  icon: Icons.phone,
                  hintText: 'Telefono',
                  isPassword: false,
                  width: screenWidth * 0.75,
                  height: screenHeight * 0.075,
                  inputColor: Colors.white,
                  textColor: Colors.black,
                  onChanged: (value) {},
                  controller: controllerPhone,
                ),
                CustomTextField(
                  icon: Icons.location_on_rounded,
                  hintText: 'Dirección',
                  isPassword: false,
                  width: screenWidth * 0.75,
                  height: screenHeight * 0.075,
                  inputColor: Colors.white,
                  textColor: Colors.black,
                  onChanged: (value) {},
                  controller: controllerAddress,
                ),
                CustomTextField(
                  icon: Icons.mail_rounded,
                  hintText: 'Correo electronico',
                  isPassword: false,
                  width: screenWidth * 0.75,
                  height: screenHeight * 0.075,
                  inputColor: Colors.white,
                  textColor: Colors.black,
                  onChanged: (value) {},
                  controller: controllerEmail,
                ),
                CustomTextField(
                  icon: Icons.person,
                  hintText: 'Rol',
                  isPassword: false,
                  width: screenWidth * 0.75,
                  height: screenHeight * 0.075,
                  inputColor: Colors.white,
                  textColor: Colors.black,
                  onChanged: (value) {},
                  controller: controllerRole,
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
                        onPressed: _onCancelRegistration,
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
                        onPressed: _onRegister,
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
        ),
      ),
    );
  }
}
