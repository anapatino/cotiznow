import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/models/user.dart';
import 'package:cotiznow/src/presentation/pages/authentication/register_administrator.dart';
import 'package:cotiznow/src/presentation/widgets/components/card/card_user.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/dropdown.dart';

/// ignore: must_be_immutable
class Profiles extends StatefulWidget {
  UserController userController = Get.find();

  Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isContainerVisible = false;

  @override
  void initState() {
    super.initState();
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
              if (isContainerVisible)
                AdministratorRegistration(
                  onCancelRegistration: () {
                    _toggleContainerVisibility();
                  },
                )
            ],
          ),
          floatingActionButton: isContainerVisible
              ? const SizedBox()
              : FloatingActionButton(
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
}
