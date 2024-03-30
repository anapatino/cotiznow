import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class DetailsQuotation extends StatefulWidget {
  const DetailsQuotation({super.key});

  @override
  State<DetailsQuotation> createState() => _DetailsQuotationState();
}

class _DetailsQuotationState extends State<DetailsQuotation> {
  final quotation = Get.arguments as Quotation;
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();
  ServicesController servicesController = Get.find();
  MaterialsController materialsController = Get.find();
  ManagementController managementController = Get.find();
  InvoiceController invoiceController = Get.find();

  double screenWidth = 0;
  double screenHeight = 0;
  String? selectOption;
  List<String> serviceNames = [];

  @override
  void initState() {
    super.initState();
    loadService();
    ManagementController.fetchManagement();
  }

  Future<void> loadService() async {
    final filteredServices = servicesController.servicesList!
        .where((service) => quotation.idService.contains(service.id));

    serviceNames = filteredServices.map((service) => service.name).toList();
  }

  Future<void> generatePDF() async {
    try {
      String downloadPath = await invoiceController.generatePDF(
          quotation, userController.user!, managementController.management!);
      MessageHandler.showMessageSuccess('Descarga de factura exitosa',
          "La factura se ha descargado en: $downloadPath");
    } catch (e) {
      MessageHandler.showMessageError('Error al generar factura', e);
    }
  }

  Future<void> _launchUrl() async {
    String message = "*¡Hola Ferreenergy!* 🛠️%0A%0A"
        "Tengo algunas dudas sobre la cotización: *${quotation.name}*.%0A%0A"
        "*Código de la cotización:* ${quotation.id}%0A"
        "*Estado de la cotización:* ${quotation.status}%0A"
        "*Cliente:* ${userController.name} ${userController.lastName}%0A"
        "*Descripción:* ${quotation.description}%0A%0A"
        "¿Me podrías ayudar con esto? 🤔%0A%0A";
    final Uri url =
        Uri.parse('https://wa.me/${managementController.phone}?text=$message');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildCardMaterial(List<Materials> materials) {
    return SizedBox(
      width: screenWidth * 0.96,
      height: screenHeight * 0.17,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: materials.length,
        itemBuilder: (context, index) {
          Materials material = materials[index];

          return Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.01, right: screenWidth * 0.025),
            child: CardMaterialSimple(
                showDescount: false,
                isLarge: false,
                showTotal: true,
                material: material,
                onClick: () {},
                onLongPress: () {},
                onDoubleTap: () {}),
          );
        },
      ),
    );
  }

  void updateQuotation() async {
    try {
      if (selectOption != null) {
        String message = await quotationController.updateQuotationStatus(
            quotation, selectOption!);
        MessageHandler.showMessageSuccess(
            'Actualización de cotización', message);

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      MessageHandler.showMessageError('Error al actualizar cotización', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    List<String> options = ['pendiente', 'aprobada', 'rechazada'];

    return SlideInRight(
      duration: const Duration(milliseconds: 15),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Text(
                    "Detalles cotización",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                CardQuotation(
                    showIcon: true,
                    showDescription: true,
                    onLongPress: () {},
                    backgroundColor: quotation.status == "pendiente"
                        ? Palette.accent
                        : quotation.status == "rechazada"
                            ? Palette.error
                            : Palette.primary,
                    title: quotation.name,
                    description: quotation.description,
                    status: quotation.status,
                    total: quotation.total,
                    onTap: () {},
                    icon: () {
                      generatePDF();
                    },
                    onDoubleTap: () {}),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.varelaRound(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
                            letterSpacing: 0.1,
                          ),
                          children: [
                            TextSpan(
                              text: 'Servicio: ',
                              style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: serviceNames.join(', '),
                              style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      child: Text(
                        'Medidas de la sección',
                        style: GoogleFonts.varelaRound(
                          color: Colors.black,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ancho: ${quotation.width}',
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1,
                            ),
                          ),
                          Text(
                            'Largo: ${quotation.length}',
                            style: GoogleFonts.varelaRound(
                              color: Colors.black,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (quotation.materials.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02),
                            child: Text(
                              'Materiales seleccionados',
                              style: GoogleFonts.varelaRound(
                                color: Palette.accent,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          _buildCardMaterial(quotation.materials),
                        ],
                      ),
                    if (userController.role != "cliente")
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: screenHeight * 0.02,
                            top: screenHeight * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("  Cambiar estado",
                                style: GoogleFonts.varelaRound(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                )),
                            CustomDropdown(
                              options: options,
                              width: 0.87,
                              widthItems: 0.65,
                              height: 0.073,
                              border: 10,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectOption = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.03,
                          horizontal: screenWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: userController.role == "cliente"
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (userController.role != "cliente")
                            CustomElevatedButton(
                              text: 'Actualizar',
                              onPressed: updateQuotation,
                              height: screenHeight * 0.065,
                              width: userController.role == "cliente"
                                  ? screenWidth * 0.65
                                  : screenWidth * 0.85,
                              textColor: Colors.white,
                              textSize: screenWidth * 0.04,
                              backgroundColor: Palette.primary,
                              hasBorder: false,
                            ),
                          if (userController.role == "cliente")
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onTap: _launchUrl,
                              child: Container(
                                height: screenHeight * 0.065,
                                width: screenWidth * 0.15,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/logo_whatsapp.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
