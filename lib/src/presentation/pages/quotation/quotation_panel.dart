import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import '../../../domain/domain.dart';

// ignore: must_be_immutable
class QuotationPanel extends StatefulWidget {
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();

  QuotationPanel({super.key});

  @override
  State<QuotationPanel> createState() => _QuotationPanelState();
}

class _QuotationPanelState extends State<QuotationPanel> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isContainerVisible = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
  }

  List<Quotation> _filterListByOption(List<Quotation> quotations) {
    if (selectedOption != "todos") {
      return quotations
          .where((quotation) => quotation.status == selectedOption)
          .toList();
    }
    return quotations;
  }

  Future<List<Quotation>> _fetchQuotationList() async {
    if (widget.userController.role == "cliente") {
      await widget.quotationController
          .getQuotationsByUserId(widget.userController.idUser);
      widget.quotationController.quotationsListByUser ?? [];
    } else {
      await widget.quotationController.getAllQuotations();
      return widget.quotationController.quotationsList ?? [];
    }
    return [];
  }

  Widget _buildQuotationList() {
    return FutureBuilder<List<Quotation>>(
      future: _fetchQuotationList(),
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
        List<Quotation> quotations = snapshot.data!;
        quotations = _filterListByOption(quotations);
        return _buildCardQuotation(quotations);
      },
    );
  }

  Widget _buildCardQuotation(List<Quotation> quotations) {
    return SizedBox(
      height: screenHeight * 0.75,
      child: ListView.builder(
        itemCount: quotations.length,
        itemBuilder: (context, index) {
          Quotation quotation = quotations[index];
          return CardQuotation(
              onLongPress: () {
                showDeleteAlert(quotation);
              },
              backgroundColor: quotation.status == "pendiente"
                  ? Palette.accent
                  : quotation.status == "rechazado"
                      ? Palette.error
                      : Palette.primary,
              title: quotation.name,
              description: quotation.description,
              status: quotation.status,
              total: quotation.total,
              onTap: () {});
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
                "Cotizaciones",
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
        floatingActionButton: isContainerVisible
            ? const SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  Get.toNamed('/registration-quotation');
                },
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

  Future<void> showDeleteAlert(Quotation quotation) async {
    DialogUtil.showConfirmationDialog(
      title: 'Eliminar cotización',
      message: '¿Desea eliminar esta cotización?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        String message =
            await widget.quotationController.deleteQuotation(quotation.id);
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
