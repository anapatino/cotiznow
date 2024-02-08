import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/models/user.dart';
import 'package:cotiznow/src/presentation/widgets/components/card/card_user.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/button.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/dropdown.dart';
import '../../widgets/components/input.dart';

/// ignore: must_be_immutable
class Profiles extends StatefulWidget {
  UserController userController = Get.find();

  Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  late TextEditingController controllerName;
  late TextEditingController controllerLastName;
  late TextEditingController controllerPhone;
  late TextEditingController controllerEmail;
  late TextEditingController controllerPassword;
  late TextEditingController controllerAddress;

  double screenWidth = 0;
  double screenHeight = 0;
  bool isContainerVisible = false;

  @override
  void initState() {
    super.initState();

    // Inicializa los controladores en el initState
    controllerName = TextEditingController();
    controllerLastName = TextEditingController();
    controllerPhone = TextEditingController();
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
    controllerAddress = TextEditingController();

    widget.userController.getUsersList();
  }

  String? selectedOption;

  Widget _buildUserList() {
    List<Users>? filteredList = [];

    if (selectedOption == 'Clientes') {
      filteredList = widget.userController.listUsers
          ?.where((user) => user.role == 'customer')
          .toList();
    } else if (selectedOption == 'Administrador') {
      filteredList = widget.userController.listUsers
          ?.where((user) => user.role == 'administrator')
          .toList();
    } else {
      filteredList = widget.userController.listUsers;
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredList?.length ?? 0,
        itemBuilder: (context, index) {
          Users user = filteredList![index];
          return CardUser(
            name: user.name,
            email: user.email,
            phone: user.phone,
            lastName: user.lastName,
            password: user.password,
            address: user.address,
            role: user.role,
            account: user.account,
          );
        },
      ),
    );
  }

  void _toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  Widget registerAdministrator() {
    return BounceInUp(
      duration: const Duration(seconds: 10),
      child: Visibility(
        visible: isContainerVisible,
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
                Text("Registrar cliente",
                    style: GoogleFonts.varelaRound(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    )),
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
                  icon: Icons.key_outlined,
                  hintText: 'Contraseña',
                  isPassword: true,
                  width: screenWidth * 0.75,
                  height: screenHeight * 0.075,
                  inputColor: Colors.white,
                  textColor: Colors.black,
                  onChanged: (value) {},
                  controller: controllerPassword,
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
                        onPressed: _toggleContainerVisibility,
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
                        onPressed: () {},
                        height: screenHeight * 0.065,
                        width: screenWidth * 0.35,
                        textColor: Colors.white,
                        textSize: screenWidth * 0.04,
                        backgroundColor: Palette.primary,
                        hasBorder: false,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    List<String> options = ['Elija una opción', 'Clientes', 'Administrador'];
    return SlideInLeft(
      duration: const Duration(milliseconds: 15),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: widget.userController.name,
            email: widget.userController.userEmail,
            itemConfigs: AdministratorRoutes().itemConfigs,
            context: context,
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Clientes",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomDropdown(
                      options: options,
                      width: 0.9,
                      widthItems: 0.65,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildUserList(),
                  ],
                ),
              ),
              registerAdministrator(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleContainerVisibility,
            backgroundColor: Palette.primary,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            shape: const CircleBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose de los controladores en el dispose
    controllerName.dispose();
    controllerLastName.dispose();
    controllerPhone.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerAddress.dispose();

    super.dispose();
  }
}
