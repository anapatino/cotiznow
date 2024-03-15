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
  bool isContainerVisible = false;
  String? selectedOption;

  List<ProgrammeVisits> _filterListByOption(List<ProgrammeVisits> list) {
    if (selectedOption == "pendiente" ||
        selectedOption == "aprobada" ||
        selectedOption == "rechazada") {
      list = list
          .where((quotation) => quotation.status == selectedOption)
          .toList();
    }

    return list;
  }

  Widget _buildProgrammeVisitsList() {
    return FutureBuilder<List<ProgrammeVisits>>(
      future: widget.userController.role == "cliente"
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
          return const Center(
            child: Text('Error al cargar la lista de cotizaciones'),
          );
        }
        List<ProgrammeVisits> list = snapshot.data!;
        list = _filterListByOption(list);
        return _buildCardProgrammeVisits(list);
      },
    );
  }

  Widget _buildCardProgrammeVisits(List<ProgrammeVisits> list) {
    return SizedBox(
      height: screenHeight * 0.75,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          ProgrammeVisits programmeVisits = list[index];
          return CardVisits(
              showCardClient:
                  widget.userController.role == "cliente" ? true : false,
              onLongPress: () {
                showDeleteAlert(programmeVisits);
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
    List<String> options = ['todos', 'pendiente', 'aprobada', 'rechazada'];

    return SlideInLeft(
      duration: const Duration(milliseconds: 15),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
        ),
        drawer: CustomDrawer(
          name: widget.userController.name,
          email: widget.userController.userEmail,
          itemConfigs: widget.userController.role == "cliente"
              ? CustomerRoutes().itemConfigs
              : AdministratorRoutes().itemConfigs,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visitas programadas",
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
                  _buildProgrammeVisitsList()
                ],
              ),
            ),
            Visibility(
              visible: isContainerVisible,
              child: Positioned(
                top: screenHeight * 0.42,
                child: RegisterProgrammeVisits(
                  onCancelForm: () {
                    toggleRegisterFormVisibility();
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: isContainerVisible
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

  Future<void> showDeleteAlert(ProgrammeVisits visit) async {
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar cotización',
      message: '¿Desea eliminar esta cotización?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        await widget.programmeVisitsController.deleteVisit(visit.id);
        Get.snackbar(
          'Éxito',
          "Se ha eliminado con exito la visita",
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
