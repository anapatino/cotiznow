import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/components/components.dart';

class GeneralInformation extends StatelessWidget {
  final TextEditingController controllerName;
  final TextEditingController controllerDescription;
  final VoidCallback onNext;

  const GeneralInformation(
      {super.key,
      required this.controllerName,
      required this.controllerDescription,
      required this.onNext});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        CustomTextField(
          icon: Icons.dehaze_rounded,
          hintText: 'Nombre',
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
          icon: Icons.dehaze_rounded,
          hintText: 'Descripción',
          maxLine: 9,
          isPassword: false,
          width: screenWidth * 0.75,
          height: screenHeight * 0.17,
          inputColor: Palette.grey,
          textColor: Palette.textColor,
          onChanged: (value) {},
          controller: controllerDescription,
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
                textSize: screenWidth * 0.039,
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
