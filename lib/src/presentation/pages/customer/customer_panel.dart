import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/models/user.dart';
import 'package:cotiznow/src/presentation/pages/authentication/register_administrator.dart';
import 'package:cotiznow/src/presentation/widgets/components/card/card_user.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/dropdown.dart';

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
          return const Center(
            child: Text('Error al cargar la lista de usuarios'),
          );
        } else {
          List<Users> filteredList = snapshot.data ?? [];
          filteredList = _filterListByOption(filteredList);

          return SizedBox(
            height: screenHeight * 0.75,
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Users user = filteredList[index];
                return CardUser(
                  name: user.name,
                  email: user.email,
                  phone: user.phone,
                  lastName: user.lastName,
                  address: user.address,
                  role: user.role,
                  account: user.account,
                );
              },
            ),
          );
        }
      },
    );
  }

  List<Users> _filterListByOption(List<Users> userList) {
    if (widget.userController.role == "administrator") {
      return userList.where((user) => user.role == 'customer').toList();
    } else {
      if (selectedOption == 'Clientes') {
        return userList.where((user) => user.role == 'customer').toList();
      } else if (selectedOption == 'Administrador') {
        return userList.where((user) => user.role == 'administrator').toList();
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
    List<String> options = widget.userController.role == "administrator"
        ? ['Clientes']
        : ['Todos', 'Clientes', 'Administrador'];

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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
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
                      height: 0.06,
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
              Positioned(
                top: isContainerVisible
                    ? screenHeight * 0.02
                    : screenHeight * 0.97,
                child: Opacity(
                  opacity: isContainerVisible ? 1 : 0.0,
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
