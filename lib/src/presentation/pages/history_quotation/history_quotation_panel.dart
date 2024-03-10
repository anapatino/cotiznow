import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import '../../../domain/domain.dart';

// ignore: must_be_immutable
class HistoryQuotationPanel extends StatefulWidget {
  UserController userController = Get.find();
  QuotationHistoryController quotationController = Get.find();

  HistoryQuotationPanel({super.key});

  @override
  State<HistoryQuotationPanel> createState() => _HistoryQuotationPanelState();
}

class _HistoryQuotationPanelState extends State<HistoryQuotationPanel> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isContainerVisible = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
  }

  List<QuotationHistory> _filterListByOption(
      List<QuotationHistory> quotations) {
    if (widget.userController.role != "cliente") {
      if (selectedOption == "pendiente" ||
          selectedOption == "aprobada" ||
          selectedOption == "rechazada") {
        quotations = quotations
            .where((quotation) => quotation.quotation.status == selectedOption)
            .toList();
      }
    }
    return quotations;
  }

  Widget _buildQuotationList() {
    return FutureBuilder<List<QuotationHistory>>(
      future: widget.quotationController.getAllQuotationsHistory(),
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
        List<QuotationHistory> quotations = snapshot.data!;
        quotations = _filterListByOption(quotations);
        return _buildCardQuotation(quotations);
      },
    );
  }

  Widget _buildCardQuotation(List<QuotationHistory> quotations) {
    return SizedBox(
      height: screenHeight * 0.75,
      child: ListView.builder(
        itemCount: quotations.length,
        itemBuilder: (context, index) {
          QuotationHistory quotation = quotations[index];
          return CardQuotation(
            onLongPress: () {
              showDeleteAlert(quotation);
            },
            backgroundColor: quotation.quotation.status == "pendiente"
                ? Palette.accent
                : quotation.quotation.status == "rechazada"
                    ? Palette.error
                    : Palette.primary,
            title: quotation.quotation.name,
            description: quotation.quotation.description,
            status: quotation.quotation.status,
            total: quotation.quotation.total,
            onTap: () {
              Get.toNamed('/details-quotation', arguments: quotation);
            },
            icon: () {},
            onDoubleTap: () {},
          );
        },
      ),
    );
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " Historial de cotizaciones",
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
              _buildQuotationList(),
            ],
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
        await widget.quotationController.deleteQuotationHistory(quotation.id);
        Get.snackbar(
          'Éxito',
          "Se ha eliminado la cotización satisfactoriamente",
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
