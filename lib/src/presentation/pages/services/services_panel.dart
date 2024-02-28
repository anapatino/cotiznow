import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/services/services.dart';
import '../../../domain/domain.dart';
import '../../routes/routes.dart';
import '../../widgets/components/components.dart';
import '../../widgets/widgets.dart';

// ignore: must_be_immutable
class ServicesPanel extends StatefulWidget {
  final ServicesController serviceController = Get.find();
  final UserController userController = Get.find();

  ServicesPanel({Key? key}) : super(key: key);

  @override
  State<ServicesPanel> createState() => _ServicesPanel();
}

class _ServicesPanel extends State<ServicesPanel> {
  TextEditingController controllerSearch = TextEditingController();
  int activeIndex = -1;
  double screenWidth = 0;
  double screenHeight = 0;
  bool isUpdateFormVisible = false;
  bool isRegisterFormVisible = false;
  List<Service> filteredServices = [];
  Service service = Service(
      id: "", icon: "", name: "", description: "", status: "", price: '');

  @override
  void initState() {
    super.initState();
  }

  void toggleUpdateFormVisibility(Service selectedService) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          isUpdateFormVisible = !isUpdateFormVisible;
          service = selectedService;
          if (!isUpdateFormVisible) {
            activeIndex = -1;
          }
        }));
  }

  void toggleRegisterFormVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          isRegisterFormVisible = !isRegisterFormVisible;
        }));
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
          ),
          body: Stack(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Servicios",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    icon: Icons.search_rounded,
                    hintText: 'Buscar',
                    isPassword: false,
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.06,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    border: 30,
                    onChanged: (value) {
                      filterService(value);
                    },
                    controller: controllerSearch,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildServiceList(),
                ],
              ),
            ),
            Visibility(
              visible: isUpdateFormVisible,
              child: Positioned(
                top: screenHeight * 0.17,
                child: Opacity(
                  opacity: isUpdateFormVisible ? 1 : 0.0,
                  child: UpdateServiceForm(
                    onCancelForm: () {
                      toggleUpdateFormVisibility(service);
                    },
                    service: service,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isRegisterFormVisible,
              child: Positioned(
                top: screenHeight * 0.17,
                child: Opacity(
                  opacity: isRegisterFormVisible ? 1 : 0.0,
                  child: RegisterServiceForm(
                    onCancelForm: () {
                      toggleRegisterFormVisibility();
                    },
                  ),
                ),
              ),
            ),
          ]),
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

  void filterService(String searchText) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          setState(() {
            if (searchText.isEmpty) {
              filteredServices = widget.serviceController.servicesList
                      ?.where((service) => service.status == 'activa')
                      .toList() ??
                  [];
            } else {
              filteredServices = widget.serviceController.servicesList!
                  .where((service) =>
                      service.name
                          .toLowerCase()
                          .contains(searchText.toLowerCase()) &&
                      service.status == 'activa')
                  .toList();
            }
          });
        }));
  }

  Widget _buildServiceList() {
    return FutureBuilder<List<Service>>(
      future: widget.serviceController.getAllServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final services = snapshot.data!;
        List<Service> filteredServices =
            services.where((service) => service.status == 'activa').toList();
        if (controllerSearch.text.isNotEmpty) {
          filteredServices = services
              .where((service) =>
                  service.name
                      .toLowerCase()
                      .contains(controllerSearch.text.toLowerCase()) &&
                  service.status == 'activa')
              .toList();
        }

        return _buildRoundIconButtons(filteredServices);
      },
    );
  }

  Widget _buildRoundIconButtons(List<Service> services) {
    return Expanded(
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.7,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 0.01,
            runSpacing: 10.0,
            children: services.map((service) {
              int index = services.indexOf(service);
              return RoundIconButton(
                icon: service.icon,
                title: service.name,
                onClick: () {
                  handleIconClick(index, service);
                },
                onLongPress: () {
                  showDisableServiceAlert(service);
                },
                isActive: activeIndex == index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void handleIconClick(int index, Service serviceNew) {
    setState(() {
      if (activeIndex == index) {
        activeIndex = -1;
      } else {
        activeIndex = index;
      }
    });
    toggleUpdateFormVisibility(serviceNew);
  }

  void showDisableServiceAlert(Service service) {
    DialogUtil.showConfirmationDialog(
      title: 'Deshabilitar Servicio',
      message: '¿Desea eliminar este usuario?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        String message = await widget.serviceController
            .updateServiceStatus(service.id, 'inactiva');
        Get.snackbar(
          'Éxito',
          message,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
      },
      backgroundConfirmButton: Palette.accentBackground,
      backgroundCancelButton: Palette.accent,
      backgroundColor: Palette.accent,
    );
  }
}
