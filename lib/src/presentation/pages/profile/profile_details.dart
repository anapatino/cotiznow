// ignore: must_be_immutable
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/customer.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../../domain/models/user.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/button/button.dart';
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
        controllerRole.text =
            userController.role == "customer" ? "Cliente" : "Administrador";
        controllerAccount.text =
            userController.account == "enable" ? "Activa" : "Desactivada";
      }
    }
  }

  Future<void> updateUser() async {
    String role = "";
    String account = "";
    if (selectedOptionRole != null) {
      role = selectedOptionRole == "Cliente" ? "customer" : "administrator";
    } else {
      role = userController.role;
    }
    if (selectedOption != null) {
      account = selectedOption == "habilitar" ? "enable" : "disable";
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
    );

    try {
      String message = await userController.updateUser(updatedUser);
      userController.role == "customer"
          ? Get.offAllNamed("/administrator-dashboard")
          : Get.offAllNamed("/customer-dashboard");
      Get.snackbar(
        'Usuario actualizado correctamente',
        message,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.check_circle_outline_rounded),
      );
    } catch (error) {
      Get.snackbar(
        'Error al actualizar usuario',
        error.toString(),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.error,
        icon: const Icon(Icons.error_outline_rounded),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ['habilitar', 'deshabilitar'];
    List<String> optionsRole = ['Cliente', 'Administrador'];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: userController.name,
            email: userController.userEmail,
            itemConfigs: userController.role == "customer"
                ? CustomerRoutes().itemConfigs
                : AdministratorRoutes().itemConfigs,
            context: context,
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
                    icon: Icons.phone,
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
                    icon: Icons.mail_rounded,
                    hintText: 'Correo electronico',
                    isPassword: false,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.073,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    onChanged: (value) {},
                    controller: controllerEmail,
                  ),
                  if (userController.role != "super_administrador")
                    CustomTextField(
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
                  if (userController.role != "super_administrador")
                    CustomTextField(
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
                  if (userController.role == "super_administrator")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("  Estado",
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
                        Text("  Rol",
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
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        CustomElevatedButton(
                          text: 'Actualizar',
                          onPressed: updateUser,
                          height: screenHeight * 0.065,
                          width: screenWidth * 0.75,
                          textColor: Colors.white,
                          textSize: screenWidth * 0.04,
                          backgroundColor: Palette.primary,
                          hasBorder: false,
                        )
                      ],
                    ),
                ]),
              ),
            ),
          )),
    );
  }
}
