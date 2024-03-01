import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
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
                child: SingleChildScrollView(
                  child: AdministratorRegistration(
                    onCancelRegistration: () {
                      _toggleContainerVisibility();
                    },
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
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar usuario',
      message: '¿Desea eliminar este usuario?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        String message = await widget.userController.deleteUser(user.id);
        Get.snackbar(
          'Éxito',
          message,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
      },
      backgroundConfirmButton: Palette.errorBackground,
      backgroundCancelButton: Palette.error,
      backgroundColor: Palette.error,
    );
  }
}
