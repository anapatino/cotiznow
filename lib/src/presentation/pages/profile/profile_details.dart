// ignore: must_be_immutable
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/customer.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';

import '../../../domain/controllers/entities/user_controller.dart';
import '../../../domain/models/entities/user.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/button/custom_button.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/dropdown.dart';
import '../../widgets/components/input/input_custom.dart';

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
  String id = "";
  String authId = "";
  String role = "";
  String account = "";

  UserController userController = Get.find();
  Users? parameters;
  String? selectedOption;
  String? selectedOptionRole;

  @override
  void initState() {
    super.initState();
    parameters = Get.arguments as Users?;
    validateFields();
  }

  void validateFields() {
    if (mounted) {
      if (parameters != null) {
        controllerName.text = parameters!.name;
        controllerLastName.text = parameters!.lastName;
        controllerPhone.text = parameters!.phone;
        controllerAddress.text = parameters!.address;
        controllerEmail.text = parameters!.email;
        controllerRole.text = parameters!.role;
        controllerAccount.text = parameters!.account;
        id = parameters!.id;
        authId = parameters!.authId;
        role = parameters!.role;
        account = parameters!.account;
      } else {
        controllerName.text = userController.name;
        controllerLastName.text = userController.lastName;
        controllerPhone.text = userController.phone;
        controllerAddress.text = userController.address;
        controllerEmail.text = userController.userEmail;
        controllerRole.text = userController.role;
        controllerAccount.text = userController.account;
        id = userController.idUser;
        authId = userController.authId;
        role = userController.role;
        account = userController.account;
      }
    }
  }

  void checkAccessAndUpdateUser() {
    if (userController.role == "administrador" &&
        controllerRole.text == "super administrador") {
      MessageHandler.showMessageWarning('Acceso denegado',
          'No tiene acceso para modificar a otro administrador.');
    } else {
      updateUser();
    }
  }

  Future<void> updateUser() async {
    if (selectedOptionRole != null) {
      role = selectedOptionRole!;
    }

    if (selectedOption != null) {
      account = selectedOption!;
    }

    Users updatedUser = Users(
      name: controllerName.text,
      lastName: controllerLastName.text,
      phone: controllerPhone.text,
      address: controllerAddress.text,
      email: controllerEmail.text,
      role: role,
      account: account,
      id: id,
      authId: authId,
    );

    try {
      String message = await userController.updateUser(updatedUser);
      userController.findUser(userController.authId);
      MessageHandler.showMessageSuccess(
          'Usuario actualizado correctamente', message);

      setState(() {
        controllerRole.text = role.isEmpty ? controllerRole.text : role;
        controllerAccount.text =
            account.isEmpty ? controllerAccount.text : account;
      });
      Get.offAllNamed('/customers');
    } catch (error) {
      MessageHandler.showMessageError('Error al actualizar usuario', error);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ['activa', 'inactiva'];
    List<String> optionsRole = userController.role == "super administrador"
        ? ['usuario', 'administrador', 'super administrador']
        : ['usuario', 'administrador'];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    bool isEnable = true;

    return PopScope(
      canPop: parameters != null ? true : false,
      child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: userController.name,
            email: userController.userEmail,
            itemConfigs: userController.role == "usuario"
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
                        fontSize:
                            isTablet ? screenWidth * 0.04 : screenWidth * 0.06,
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
                              fontSize: isTablet
                                  ? screenWidth * 0.028
                                  : screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            )),
                        CustomDropdown(
                          options: options,
                          width: 0.75,
                          widthItems: isTablet ? 0.62 : 0.55,
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
                              fontSize: isTablet
                                  ? screenWidth * 0.028
                                  : screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            )),
                        CustomDropdown(
                          options: optionsRole,
                          width: 0.75,
                          widthItems: isTablet ? 0.62 : 0.55,
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
                      textSize:
                          isTablet ? screenWidth * 0.034 : screenWidth * 0.04,
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
