import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/materials/materials.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../routes/routes.dart';

class MaterialsBoard extends StatefulWidget {
  final MaterialsController materialController = Get.find();
  final SectionsController sectionsController = Get.find();
  final UserController userController = Get.find();
  MaterialsBoard({super.key});

  @override
  State<MaterialsBoard> createState() => _MaterialsBoardState();
}

class _MaterialsBoardState extends State<MaterialsBoard> {
  TextEditingController controllerSearch = TextEditingController();

  int activeIndex = -1;
  String sectionId = "";
  double screenWidth = 0;
  double screenHeight = 0;
  bool isUpdateStatusVisible = false;
  bool isRegisterFormVisible = false;
  List<Section> listSections = [];
  List<Section> filteredSections = [];
  List<Materials> filteredMaterials = [];

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
      code: '',
      discount: '');

  @override
  void initState() {
    super.initState();
    loadSectionsAndHandleIconClick();
  }

  Future<void> loadSectionsAndHandleIconClick() async {
    try {
      listSections = await widget.sectionsController.getAllSections();
      setState(() {
        filteredSections = listSections
            .where((section) => section.status == 'activo')
            .toList();
        if (filteredSections.isNotEmpty) {
          handleIconClick(0, filteredSections[0]);
        }
      });
    } catch (error) {
      MessageHandler.showMessageWarning("Error al carga las secciones", error);
    }
  }

  void toggleRegisterFormVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          isRegisterFormVisible = !isRegisterFormVisible;
        }));
  }

  void toggleStatusFormVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          isUpdateStatusVisible = !isUpdateStatusVisible;
        }));
  }

  Widget _buildSectionsList() {
    return FutureBuilder<List<Section>>(
      future: widget.sectionsController.getAllSections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString(),
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                )),
          );
        }
        final sections = snapshot.data!;
        filteredSections =
            sections.where((section) => section.status == 'activo').toList();
        return _buildRoundIconButtons(filteredSections);
      },
    );
  }

  Widget _buildRoundIconButtons(List<Section> sections) {
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          Section section = sections[index];

          return RoundIconButton(
            icon: section.icon,
            title: section.name,
            onClick: () {
              setState(() {
                handleIconClick(index, section);
              });
            },
            onLongPress: () {},
            isActive: activeIndex == index,
          );
        },
      ),
    );
  }

  Widget _buildMaterialsBySectionId(String sectionId) {
    return FutureBuilder<List<Materials>>(
      future: widget.materialController.getMaterialsBySectionId(sectionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString(),
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                )),
          );
        }
        final materials = snapshot.data!;
        filteredMaterials =
            materials.where((material) => material.status == 'activo').toList();
        if (controllerSearch.text.isNotEmpty) {
          filteredMaterials = filteredMaterials
              .where((material) =>
                  material.name
                      .toLowerCase()
                      .contains(controllerSearch.text.toLowerCase()) &&
                  material.sectionId == sectionId &&
                  material.status == 'activo')
              .toList();
        }
        return _buildCardMaterial(filteredMaterials);
      },
    );
  }

  Widget _buildCardMaterial(List<Materials> materials) {
    return Expanded(
      child: SizedBox(
        width: screenWidth * 0.86,
        height: screenHeight * 0.8,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: materials.length,
          itemBuilder: (context, index) {
            Materials material = materials[index];

            return CardMaterialSimple(
                material: material,
                onClick: () {
                  Get.toNamed(
                    '/details-material',
                    arguments: material,
                  );
                },
                onLongPress: () {
                  showDeleteAlert(material);
                },
                onDoubleTap: () {
                  toggleStatusFormVisibility();
                });
          },
        ),
      ),
    );
  }

  void filterMaterials(String searchText) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          if (searchText.isEmpty) {
            filteredMaterials = (widget.materialController.materialsList ?? [])
                .where((material) =>
                    material.status == 'activo' &&
                    material.sectionId == sectionId)
                .toList();
          } else {
            filteredMaterials = (widget.materialController.materialsList ?? [])
                .where((material) =>
                    material.name
                        .toLowerCase()
                        .contains(searchText.toLowerCase()) &&
                    material.sectionId == sectionId &&
                    material.status == 'activo')
                .toList();
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return SlideInLeft(
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
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.06,
                            inputColor: Palette.grey,
                            textColor: Colors.black,
                            border: 30,
                            onChanged: (value) {
                              filterMaterials(value);
                            },
                            controller: controllerSearch,
                          ),
                        ],
                      ),
                      _buildSectionsList(),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      _buildMaterialsBySectionId(sectionId),
                    ],
                  ),
                ),
                Visibility(
                  visible: isRegisterFormVisible,
                  child: Positioned(
                    top: screenHeight * 0.05,
                    child: RegisterMaterialForm(
                      onCancelForm: () {
                        toggleRegisterFormVisibility();
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: isUpdateStatusVisible,
                  child: Positioned(
                    top: screenHeight * 0.55,
                    child: ChangeMaterialStatus(
                      onCancelForm: () {
                        toggleStatusFormVisibility();
                      },
                      material: material,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: isRegisterFormVisible || isUpdateStatusVisible
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
    );
  }

  Future<void> showDeleteAlert(Materials material) async {
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar material',
      message: '¿Desea eliminar este material?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        try {
          String message = await widget.materialController
              .deleteMaterial(material.id, material.urlPhoto);
          MessageHandler.showMessageSuccess(
              "Se ha realizado con exito la operación", message);
        } catch (e) {
          MessageHandler.showMessageError(
              "Error al realizar esta operación", e);
        }
      },
      backgroundConfirmButton: Palette.errorBackground,
      backgroundCancelButton: Palette.error,
      backgroundColor: Palette.error,
    );
  }

  void handleIconClick(int index, Section section) {
    setState(() {
      if (activeIndex == index) {
        activeIndex = -1;
      } else {
        activeIndex = index;
      }
      sectionId = section.id;
    });
  }
}
