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

  void _toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  Widget _buildQuotationList() {
    return FutureBuilder<List<Quotation>>(
      future: widget.userController.role == "cliente"
          ? widget.quotationController.getAllQuotations()
          : widget.quotationController
              .getAllQuotationsByUser(widget.userController.idUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar la lista de usuarios'),
          );
        }
        final quotations = snapshot.data!;
//        return _buildCardQuotation(quotations);

        return const SizedBox();
      },
    );
  }

  Widget _buildCardQuotation(List<Quotation> quotations) {
/*return SizedBox(
            height: screenHeight * 0.75,
            child: ListView.builder(
              itemCount: quotations.length,
              itemBuilder: (context, index) {
                Users user = quotations[index];
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
          );*/
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    List<String> options = ['pendiente', 'terminada', 'rechazada'];
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
                    "Cotizaciones",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  //_buildQuotationList(),
                ],
              ),
            ),
            /*Positioned(
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
              ),*/
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
      )),
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
