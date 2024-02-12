// ignore: must_be_immutable
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/customer.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/button/button.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/dropdown.dart';
import '../../widgets/components/input.dart';

// ignore: must_be_immutable
class ProfileDetails extends StatefulWidget {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerRole = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String address;
  final String account;
  final String role;

  UserController userController = Get.find();
  ProfileDetails({
    super.key,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.account,
    required this.role,
  });

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  void initState() {
    super.initState();
    widget.controllerName.text = widget.name;
    widget.controllerLastName.text = widget.lastName;
    widget.controllerPhone.text = widget.phone;
    widget.controllerAddress.text = widget.address;
    widget.controllerEmail.text = widget.email;
    widget.controllerRole.text = widget.role;
  }

  @override
  void dispose() {
    widget.controllerName.dispose();
    widget.controllerLastName.dispose();
    widget.controllerPhone.dispose();
    widget.controllerAddress.dispose();
    widget.controllerEmail.dispose();
    widget.controllerRole.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ['Clientes', 'Administrador'];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String? selectedOption;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: widget.userController.name,
            email: widget.userController.userEmail,
            itemConfigs: widget.userController.role == "customer"
                ? CustomerRoutes().itemConfigs
                : AdministratorRoutes().itemConfigs,
            context: context,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Detalles cliente",
                        style: GoogleFonts.varelaRound(
                          color: Colors.black,
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        )),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    CustomTextField(
                      icon: Icons.person,
                      hintText: 'Nombre',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Palette.grey,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: widget.controllerName,
                    ),
                    CustomTextField(
                      icon: Icons.person,
                      hintText: 'Apellido',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Palette.grey,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: widget.controllerLastName,
                    ),
                    CustomTextField(
                      icon: Icons.phone,
                      hintText: 'Telefono',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Palette.grey,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: widget.controllerPhone,
                    ),
                    CustomTextField(
                      icon: Icons.location_on_rounded,
                      hintText: 'Dirección',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Palette.grey,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: widget.controllerAddress,
                    ),
                    CustomTextField(
                      icon: Icons.mail_rounded,
                      hintText: 'Correo electronico',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Palette.grey,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: widget.controllerEmail,
                    ),
                    CustomTextField(
                      icon: Icons.person,
                      hintText: 'Rol',
                      isPassword: false,
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.075,
                      inputColor: Palette.grey,
                      textColor: Colors.black,
                      onChanged: (value) {},
                      controller: widget.controllerRole,
                    ),
                    CustomDropdown(
                      options: options,
                      width: 0.65,
                      widthItems: 0.35,
                      height: 0.6,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    CustomElevatedButton(
                      text: 'Actualizar',
                      onPressed: () {},
                      height: screenHeight * 0.065,
                      width: screenWidth * 0.85,
                      textColor: Colors.white,
                      textSize: screenWidth * 0.04,
                      backgroundColor: Palette.primary,
                      hasBorder: false,
                    )
                  ]),
            ),
          )),
    );
  }
}
