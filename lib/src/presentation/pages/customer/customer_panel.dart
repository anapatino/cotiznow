import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../../domain/domain.dart';
import '../../routes/routes.dart';
import '../authentication/authentication.dart';

/// ignore: must_be_immutable
class Customer extends StatefulWidget {
  UserController userController = Get.find();

  Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isContainerVisible = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Users>> _fetchUserList() async {
    await widget.userController.getUsersList();
    return widget.userController.listUsers ?? [];
  }

  Widget _buildUserList() {
    return FutureBuilder<List<Users>>(
      future: _fetchUserList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar la lista de usuarios',
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                )),
          );
        } else {
          List<Users> filteredList = snapshot.data ?? [];
          filteredList = _filterListByOption(filteredList);

          return SizedBox(
            height: screenHeight * 0.85,
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Users user = filteredList[index];
                return CardUser(
                  user: user,
                  onLongPress: () {},
                );
              },
            ),
          );
        }
      },
    );
  }

  List<Users> _filterListByOption(List<Users> userList) {
    if (widget.userController.role == "administrador") {
      return userList.where((user) => user.role == 'usuario').toList();
    } else {
      if (selectedOption == 'usuarios') {
        return userList.where((user) => user.role == 'usuario').toList();
      } else if (selectedOption == 'administradores') {
        return userList.where((user) => user.role == 'administrador').toList();
      } else if (selectedOption == 'super administrador') {
        return userList
            .where((user) => user.role == 'super administrador')
            .toList();
      } else {
        return userList;
      }
    }
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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    List<String> options = widget.userController.role == "administrador"
        ? ['usuarios']
        : ['todos', 'usuarios', 'administradores', 'super administrador'];

    return PopScope(
      canPop: false,
      child: SlideInLeft(
        duration: const Duration(milliseconds: 15),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: widget.userController.name,
            email: widget.userController.userEmail,
            itemConfigs: AdministratorRoutes().itemConfigs,
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight * 1,
              child: Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Usuarios",
                          style: GoogleFonts.varelaRound(
                            color: Colors.black,
                            fontSize: isTablet
                                ? screenWidth * 0.04
                                : screenWidth * 0.06,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomDropdown(
                          options: options,
                          width: isTablet ? 0.8 : 0.9,
                          height: 0.06,
                          widthItems: isTablet ? 0.67 : 0.65,
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
                  Visibility(
                    visible: isContainerVisible,
                    child: Positioned(
                      top: screenHeight * 0.02,
                      child: SingleChildScrollView(
                        child: AdministratorRegistration(
                          onCancelRegistration: () {
                            _toggleContainerVisibility();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
