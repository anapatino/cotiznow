import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import '../../../../domain/domain.dart';

// ignore: must_be_immutable
class HistoryQuotationPanel extends StatefulWidget {
  UserController userController = Get.find();
  QuotationHistoryController quotationController = Get.find();
  ServicesController servicesController = Get.find();

  HistoryQuotationPanel({super.key});

  @override
  State<HistoryQuotationPanel> createState() => _HistoryQuotationPanelState();
}

class _HistoryQuotationPanelState extends State<HistoryQuotationPanel> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isTablet = false;
  bool isContainerVisible = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() {
    setState(() {
      selectedOption = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    List<String> options = ['todos', 'pendiente', 'aprobada', 'rechazada',"terminado"];
    final QuotationWidget quotationWidget = QuotationWidget(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
    );
    return PopScope(
      canPop: false,
      child: SlideInLeft(
        duration: const Duration(milliseconds: 15),
        child: Scaffold(
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Historial de cotizaciones",
                  style: GoogleFonts.varelaRound(
                    color: Colors.black,
                    fontSize:
                        isTablet ? screenWidth * 0.04 : screenWidth * 0.06,
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
                quotationWidget.buildHistoryQuotationList(
                    selectedOption != null ? selectedOption! : "",
                    showDeleteAlert),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDeleteAlert(QuotationHistory quotation) async {
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar cotización',
      message: '¿Desea eliminar esta cotización?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        try {
          await widget.quotationController.deleteQuotationHistory(quotation.id);
          MessageHandler.showMessageSuccess(
            'Eliminación de historial exitosa',
            "Se ha eliminado el historial de la cotización",
          );
          refreshList();
        } catch (e) {
          MessageHandler.showMessageError(
              'Error al eliminar historial cotización', e);
        }
      },
      backgroundConfirmButton: Palette.errorBackground,
      backgroundCancelButton: Palette.error,
      backgroundColor: Palette.error,
    );
  }
}
