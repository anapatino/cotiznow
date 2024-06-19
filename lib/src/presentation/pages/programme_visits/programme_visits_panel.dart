import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/models.dart';
import 'package:cotiznow/src/presentation/pages/programme_visits/programme_visits.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';

import '../../widgets/widgets.dart';

// ignore: must_be_immutable
class ProgrammeVisitsPanel extends StatefulWidget {
  UserController userController = Get.find();
  ProgrammeVisitsController programmeVisitsController = Get.find();

  ProgrammeVisitsPanel({super.key});

  @override
  State<ProgrammeVisitsPanel> createState() => _ProgrammeVisitsPanelState();
}

class _ProgrammeVisitsPanelState extends State<ProgrammeVisitsPanel> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isTablet = false;
  bool isContainerVisible = false;
  String? selectedOption;

  List<ProgrammeVisits> _filterListByOption(
      List<ProgrammeVisits> list, String selectedOption) {
    if (selectedOption == "todos" || selectedOption == "") {
      return list;
    }
    return list.where((visit) => visit.status == selectedOption).toList();
  }

  Widget _buildProgrammeVisitsList() {
    return FutureBuilder<List<ProgrammeVisits>>(
      future: widget.userController.role == "usuario"
          ? widget.programmeVisitsController
              .getAllVisitsByUser(widget.userController.authId)
          : widget.programmeVisitsController.getAllVisits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar la lista de cotizaciones',
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                )),
          );
        }
        List<ProgrammeVisits> list = snapshot.data!;
        list = _filterListByOption(
            list, selectedOption != null ? selectedOption! : "");
        return _buildCardProgrammeVisits(list);
      },
    );
  }

  Widget _buildCardProgrammeVisits(List<ProgrammeVisits> list) {
    return SizedBox(
      height: screenHeight * 0.85,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          ProgrammeVisits programmeVisits = list[index];
          return CardVisits(
              showCardClient:
                  widget.userController.role == "usuario" ? true : false,
              onLongPress: () {
                if (widget.userController.role != "usuario") {
                  showDeleteAlert(programmeVisits);
                }
              },
              backgroundColor: programmeVisits.status == "pendiente"
                  ? Palette.accent
                  : programmeVisits.status == "rechazada"
                      ? Palette.error
                      : Palette.primary,
              programmeVisits: programmeVisits,
              onTap: () {
                Get.toNamed('/visit-details', arguments: programmeVisits);
              },
              onDoubleTap: () {});
        },
      ),
    );
  }

  void toggleRegisterFormVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          isContainerVisible = !isContainerVisible;
        }));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    List<String> options = ['todos', 'pendiente', 'aprobada', 'rechazada'];

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
            itemConfigs: widget.userController.role == "usuario"
                ? CustomerRoutes().itemConfigs
                : AdministratorRoutes().itemConfigs,
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
                          "Visitas programadas",
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
                        _buildProgrammeVisitsList()
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isContainerVisible,
                    child: Positioned(
                      top: screenHeight * 0.45,
                      child: RegisterProgrammeVisits(
                        onCancelForm: () {
                          toggleRegisterFormVisibility();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton:
              !isContainerVisible && widget.userController.role == "usuario"
                  ? FloatingActionButton(
                      onPressed: toggleRegisterFormVisibility,
                      backgroundColor: Palette.primary,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      shape: const CircleBorder(),
                    )
                  : const SizedBox(),
        ),
      ),
    );
  }

  Future<void> showDeleteAlert(ProgrammeVisits visit) async {
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar visita',
      message: '¿Desea eliminar esta visita?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        try {
          await widget.programmeVisitsController.deleteVisit(visit.id);
          MessageHandler.showMessageSuccess(
              'Se ha realizado con exito la operación',
              "Se ha eliminado con exito la visita");

          setState(() {});
        } catch (e) {
          MessageHandler.showMessageError('Error al eliminar la visita', e);
        }
      },
      backgroundConfirmButton: Palette.errorBackground,
      backgroundCancelButton: Palette.error,
      backgroundColor: Palette.error,
    );
  }
}
