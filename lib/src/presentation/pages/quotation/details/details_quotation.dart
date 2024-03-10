import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import 'package:whatsapp/whatsapp.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

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
  double screenWidth = 0;
  double screenHeight = 0;
  String? selectOption;
  WhatsApp whatsapp = WhatsApp();
  @override
  void initState() {
    super.initState();
    loadService();
  }

  Future<void> loadService() async {
    await servicesController.getAllServices();
  }

  List<String> getServiceNames(List<String> idServices) {
    List<String> serviceNames = [];

    idServices.forEach((id) {
      Service? service =
          servicesController.servicesList?.firstWhereOrNull((e) => e?.id == id);
      if (service != null) {
        serviceNames.add(service.name);
      }
    });

    return serviceNames;
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            'Hello World',
          ),
        ),
      ),
    );
    try {
      final outputDir =
          await getExternalStorageDirectory(); // Or getApplicationDocumentsDirectory()
      final file = File('${outputDir!.path}/example.pdf');
      await file.writeAsBytes(await pdf.save());
      print("se supone que ya guarde el pdf");
    } catch (e) {
      print("Error saving PDF: $e");
    }
  }

  Widget _buildCardMaterial(List<Materials> materials) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: SizedBox(
        width: screenWidth * 1,
        height: screenHeight * 0.3,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: materials.length,
          itemBuilder: (context, index) {
            Materials material = materials[index];

            return CardMaterialSimple(
                isLarge: false,
                material: material,
                onClick: () {},
                onLongPress: () {},
                onDoubleTap: () {});
          },
        ),
      ),
    );
  }

  void updateQuotation() async {
    try {
      if (selectOption != null) {
        String message = await quotationController.updateQuotationStatus(
            quotation.id, selectOption!);
        Get.snackbar(
          'Actualización de cotización',
          message,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      Get.snackbar(
        'Error al actualizar cotización',
        '$e',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.error,
        icon: const Icon(Icons.error),
      );
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
                            const TextSpan(
                              text: 'Servicio: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: getServiceNames(quotation.idService)
                                  .join(', '),
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
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomElevatedButton(
                            text: 'Contactame',
                            onPressed: () async {
                              print(await whatsapp.messagesTemplate(
                                to: 3015849730,
                                templateName:
                                    "este es un ejemplo de enviar mensaje desde flutter",
                              ));
                            },
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.4,
                            textColor: Palette.accentBackground,
                            textSize: screenWidth * 0.04,
                            backgroundColor: Colors.white,
                            hasBorder: true,
                            borderColor: Palette.accentBackground,
                          ),
                          CustomElevatedButton(
                            text: 'Actualizar',
                            onPressed: updateQuotation,
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.4,
                            textColor: Colors.white,
                            textSize: screenWidth * 0.04,
                            backgroundColor: Palette.primary,
                            hasBorder: false,
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
