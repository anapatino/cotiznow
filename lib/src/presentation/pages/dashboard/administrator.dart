import 'package:cotiznow/lib.dart';

import '../../../domain/controllers/user_controller.dart';

class Administrator extends StatelessWidget {
  UserController userController = Get.find();

  Administrator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Administrator',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Administrator'),
        ),
        body: Center(
          child: Text('Dashboard Administrator ${userController.name}'),
        ),
      ),
    );
  }
}
