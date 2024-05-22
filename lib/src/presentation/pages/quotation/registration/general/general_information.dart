import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/components/components.dart';

class GeneralInformation extends StatelessWidget {
  final TextEditingController controllerName;
  final TextEditingController controllerAddress;
  final TextEditingController controllerPhone;
  final VoidCallback onNext;

  const GeneralInformation(
      {super.key,
      required this.controllerName,
      required this.controllerAddress,
      required this.controllerPhone,
      required this.onNext});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Column(
      children: [
        CustomTextField(
          icon: Icons.person,
          hintText: 'Nombre completo',
          maxLine: 3,
          isPassword: false,
          width: screenWidth * 0.75,
          height: screenHeight * 0.1,
          inputColor: Palette.grey,
          textColor: Palette.textColor,
          onChanged: (value) {},
          controller: controllerName,
        ),
        CustomTextField(
          icon: Icons.location_on_rounded,
          hintText: 'Direccion',
          maxLine: 3,
          isPassword: false,
          width: screenWidth * 0.75,
          height: screenHeight * 0.1,
          inputColor: Palette.grey,
          textColor: Palette.textColor,
          onChanged: (value) {},
          controller: controllerAddress,
        ),
        CustomTextField(
          icon: Icons.phone,
          hintText: 'Telefono',
          maxLine: 3,
          isPassword: false,
          width: screenWidth * 0.75,
          height: screenHeight * 0.1,
          inputColor: Palette.grey,
          textColor: Palette.textColor,
          onChanged: (value) {},
          controller: controllerPhone,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton(
                text: 'Continuar',
                onPressed: onNext,
                height: screenHeight * 0.058,
                width: screenWidth * 0.33,
                textColor: Colors.white,
                textSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.039,
                backgroundColor: Palette.accent,
                hasBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
