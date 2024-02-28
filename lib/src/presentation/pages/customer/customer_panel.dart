import 'package:cotiznow/lib.dart';
import '../../../domain/domain.dart';
import '../../routes/routes.dart';
import '../../widgets/components/components.dart';
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
                  onLongPress: () {
                    showDeleteAlert(user);
                  },
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
      return userList.where((user) => user.role == 'cliente').toList();
    } else {
      if (selectedOption == 'clientes') {
        return userList.where((user) => user.role == 'cliente').toList();
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
    List<String> options = widget.userController.role == "administrador"
        ? ['clientes']
        : ['todos', 'clientes', 'administradores', 'super administrador'];

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

  Future<void> showDeleteAlert(Users user) async {
    Get.defaultDialog(
      title: 'Eliminar usuario',
      titleStyle: GoogleFonts.varelaRound(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.055,
      ),
      confirmTextColor: Colors.white,
      backgroundColor: Palette.error,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.015),
            child: Text(
              '¿Desea eliminar este usuario?',
              style: GoogleFonts.varelaRound(
                color: Colors.white,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.error,
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.varelaRound(
                    color: Colors.white,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.errorBackground,
                ),
                onPressed: () async {
                  Get.back();
                  try {
                    String result =
                        await widget.userController.deleteUser(user.id);
                    Get.snackbar(
                      'Éxito',
                      result,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      backgroundColor: Palette.accent,
                      icon: const Icon(Icons.check_circle),
                    );
                  } catch (error) {
                    Get.snackbar(
                      'Error al eliminar usuario',
                      '$error',
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      backgroundColor: Palette.error,
                      icon: const Icon(Icons.error),
                    );
                  }
                },
                child: Text(
                  'Aceptar',
                  style: GoogleFonts.varelaRound(
                    color: Colors.white,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
