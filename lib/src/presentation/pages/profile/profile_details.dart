// ignore: must_be_immutable
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/customer.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../../domain/models/user.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/button/custom_button.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/dropdown.dart';
import '../../widgets/components/input.dart';

// ignore: must_be_immutable
class ProfileDetails extends StatefulWidget {
  ProfileDetails({
    super.key,
  });

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerRole = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();
  final TextEditingController controllerAccount = TextEditingController();

  UserController userController = Get.find();
  Map<String, dynamic>? parameters = Get.arguments;
  String? selectedOption;
  String? selectedOptionRole;

  @override
  void initState() {
    super.initState();
    validateFields();
  }

  void validateFields() {
    if (mounted) {
      if (parameters != null) {
        controllerName.text = parameters?['name'];
        controllerLastName.text = parameters?['lastName'];
        controllerPhone.text = parameters?['phone'];
        controllerAddress.text = parameters?['address'];
        controllerEmail.text = parameters?['email'];
        controllerRole.text = parameters?['role'];
        controllerAccount.text = parameters?['account'];
      } else {
        controllerName.text = userController.name;
        controllerLastName.text = userController.lastName;
        controllerPhone.text = userController.phone;
        controllerAddress.text = userController.address;
        controllerEmail.text = userController.userEmail;
        controllerRole.text = userController.role;
        controllerAccount.text = userController.account;
      }
    }
  }

  void checkAccessAndUpdateUser() {
    if (userController.role == "administrador" &&
        controllerRole.text == "super administrador") {
      Get.snackbar(
        'Acceso denegado',
        'No tiene acceso para modificar a otro administrador.',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.warning,
        icon: const Icon(Icons.error_rounded),
      );
    } else {
      updateUser();
    }
  }

  Future<void> updateUser() async {
    String role = "";
    String account = "";
    if (selectedOptionRole != null) {
      role = selectedOptionRole!;
    } else {
      role = userController.role;
    }
    if (selectedOption != null) {
      account = selectedOption == "activar" ? "activa" : "desactivada";
    } else {
      account = userController.account;
    }

    Users updatedUser = Users(
      name: controllerName.text,
      lastName: controllerLastName.text,
      phone: controllerPhone.text,
      address: controllerAddress.text,
      email: controllerEmail.text,
      role: role,
      account: account,
      id: userController.idUser,
      authId: userController.authId,
      quotationIds: [],
    );

    try {
      String message = await userController.updateUser(updatedUser);

      Get.snackbar(
        'Usuario actualizado correctamente',
        message,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.check_circle),
      );
    } catch (error) {
      Get.snackbar(
        'Error al actualizar usuario',
        error.toString(),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.error,
        icon: const Icon(Icons.error_rounded),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ['activar', 'desactivar'];
    List<String> optionsRole = userController.role == "super administrador"
        ? ['cliente', 'administrador', 'super administrador']
        : ['cliente', 'administrador'];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isEnable = userController.role == "cliente" ? false : true;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: userController.name,
            email: userController.userEmail,
            itemConfigs: userController.role == "cliente"
                ? CustomerRoutes().itemConfigs
                : AdministratorRoutes().itemConfigs,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Center(
                child: Column(children: [
                  Text("Perfil",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      )),
                  SizedBox(
                    height: screenHeight * 0.015,
                  ),
                  CustomTextField(
                    isEnable: isEnable,
                    icon: Icons.person,
                    hintText: 'Nombre',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerName,
                  ),
                  CustomTextField(
                    isEnable: isEnable,
                    icon: Icons.person,
                    hintText: 'Apellido',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerLastName,
                  ),
                  CustomTextField(
                    isEnable: isEnable,
                    icon: Icons.phone,
                    type: TextInputType.phone,
                    hintText: 'Telefono',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerPhone,
                  ),
                  CustomTextField(
                    isEnable: isEnable,
                    type: TextInputType.streetAddress,
                    icon: Icons.location_on_rounded,
                    hintText: 'Dirección',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerAddress,
                  ),
                  CustomTextField(
                    isEnable: isEnable,
                    icon: Icons.mail_rounded,
                    type: TextInputType.emailAddress,
                    hintText: 'Correo electronico',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerEmail,
                  ),
                  CustomTextField(
                    isEnable: false,
                    icon: Icons.account_circle_rounded,
                    hintText: 'Rol',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerRole,
                  ),
                  CustomTextField(
                    isEnable: false,
                    icon: Icons.admin_panel_settings_sharp,
                    hintText: 'Cuenta',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerAccount,
                  ),
                  if (userController.role == "super administrador")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("  Cambiar estado",
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            )),
                        CustomDropdown(
                          options: options,
                          width: 0.75,
                          widthItems: 0.55,
                          height: 0.073,
                          border: 10,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOption = newValue;
                            });
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Text("  Cambiar rol",
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            )),
                        CustomDropdown(
                          options: optionsRole,
                          width: 0.75,
                          widthItems: 0.55,
                          height: 0.073,
                          border: 10,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOptionRole = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.02, bottom: screenHeight * 0.03),
                    child: CustomElevatedButton(
                      text: 'Actualizar',
                      onPressed: checkAccessAndUpdateUser,
                      height: screenHeight * 0.065,
                      width: screenWidth * 0.75,
                      textColor: Colors.white,
                      textSize: screenWidth * 0.04,
                      backgroundColor: Palette.primary,
                      hasBorder: false,
                    ),
                  )
                ]),
              ),
            ),
          )),
    );
  }
}
