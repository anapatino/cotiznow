import 'package:cotiznow/lib.dart';

import '../../../domain/controllers/user_controller.dart';

// ignore: must_be_immutable
class Customer extends StatelessWidget {
  UserController userController = Get.find();

  Customer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard cliente',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard cliente'),
        ),
        body: Center(
          child: Text('Dashboard cliente ${userController.name}'),
        ),
      ),
    );
  }
}
