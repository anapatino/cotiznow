import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/components/card/card_user.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/dropdown.dart';

// ignore: must_be_immutable
class Profiles extends StatefulWidget {
  UserController userController = Get.find();

  Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  List<Map<String, String>> userList = [
    {
      "name": "Laura sofia quintero aliendra",
      "email": "laura@gmail.com",
      "phone": "3015849730",
      "role": "customer",
    },
    {
      "name": "Laura sofia quintero",
      "email": "laura@gmail.com",
      "phone": "3015849730",
      "role": "customer",
    },
    {
      "name": "administrador",
      "email": "laura@gmail.com",
      "phone": "3015849730",
      "role": "administrator",
    },
    {
      "name": "angel administrador",
      "email": "laura@gmail.com",
      "phone": "3015849730",
      "role": "administrator",
    },
  ];
  String? selectedOption;
  Widget _buildUserList() {
    List<Map<String, String>> filteredList = [];

    if (selectedOption == 'Clientes') {
      filteredList =
          userList.where((user) => user['role'] == 'customer').toList();
    } else if (selectedOption == 'Administrador') {
      filteredList =
          userList.where((user) => user['role'] == 'administrator').toList();
    } else {
      filteredList = userList;
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return CardUser(
            name: filteredList[index]["name"]!,
            email: filteredList[index]["email"]!,
            phone: filteredList[index]["phone"]!,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Clientes",
                style: GoogleFonts.varelaRound(
                    color: Colors.black, fontSize: screenWidth * 0.06),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
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
              SizedBox(
                height: screenHeight * 0.02,
              ),
              _buildUserList(),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
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
