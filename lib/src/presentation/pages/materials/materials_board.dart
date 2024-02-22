import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/material_controller.dart';
import 'package:cotiznow/src/domain/models/material.dart';
import 'package:cotiznow/src/presentation/pages/materials/registration/register_material.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/input.dart';

class MaterialsBoard extends StatefulWidget {
  final MaterialsController sectionsController = Get.find();
  final UserController userController = Get.find();
  MaterialsBoard({super.key});

  @override
  State<MaterialsBoard> createState() => _MaterialsBoardState();
}

class _MaterialsBoardState extends State<MaterialsBoard> {
  late final TextEditingController? controllerSearch;
  int activeIndex = -1;
  double screenWidth = 0;
  double screenHeight = 0;
  bool isUpdateFormVisible = false;
  bool isRegisterFormVisible = false;
  List<Materials> filteredSections = [];
  Materials material = Materials(
      urlPhoto: '',
      name: '',
      unit: '',
      size: '',
      purchasePrice: '',
      salePrice: '',
      sectionId: '',
      quantity: '',
      description: '',
      status: '',
      id: '',
      code: '');

  @override
  void initState() {
    super.initState();
    controllerSearch = TextEditingController();
    //controllerSearch?.addListener(() {
    // filterSections(controllerSearch!.text);
    //});
  }

  @override
  void dispose() {
    controllerSearch?.clear();
    super.dispose();
  }

  void toggleUpdateFormVisibility(Materials selectMaterial) {
    setState(() {
      isUpdateFormVisible = !isUpdateFormVisible;
      material = selectMaterial;
      if (!isUpdateFormVisible) {
        activeIndex = -1;
      }
    });
  }

  void toggleRegisterFormVisibility() {
    setState(() {
      isRegisterFormVisible = !isRegisterFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
                      "Materiales",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        CustomTextField(
                          icon: Icons.search_rounded,
                          hintText: 'Buscar',
                          isPassword: false,
                          width: screenWidth * 0.73,
                          height: screenHeight * 0.06,
                          inputColor: Palette.grey,
                          textColor: Colors.black,
                          border: 30,
                          onChanged: (value) {
                            //filterSections(value);
                          },
                          controller: controllerSearch!,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
              Visibility(
                visible: isRegisterFormVisible,
                child: Positioned(
                  top: screenHeight * 0.05,
                  child: Opacity(
                    opacity: isRegisterFormVisible ? 1 : 0.0,
                    child: RegisterMaterialForm(
                      onCancelForm: () {
                        toggleRegisterFormVisibility();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: isRegisterFormVisible || isUpdateFormVisible
              ? const SizedBox()
              : FloatingActionButton(
                  onPressed: toggleRegisterFormVisibility,
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

  void handleIconClick(int index, Materials materialNew) {
    setState(() {
      if (activeIndex == index) {
        activeIndex = -1;
      } else {
        activeIndex = index;
      }
      toggleUpdateFormVisibility(materialNew);
    });
  }
}
