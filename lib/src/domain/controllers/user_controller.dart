import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../data/service/user_request.dart';
import '../models/user.dart';

class UserController extends GetxController {
  final Rx<dynamic> _email = "".obs;
  final Rx<dynamic> _name = "".obs;
  final Rx<dynamic> _role = "".obs;
  final Rx<dynamic> _account = "".obs;
  final Rx<dynamic> _phone = "".obs;
  final Rx<dynamic> _address = "".obs;
  final Rx<dynamic> _lastName = "".obs;
  final Rx<dynamic> _id = "".obs;
  final Rxn<List<Users>> _listUsers = Rxn<List<Users>>();

  String get userEmail => _email.value;
  String get name => _name.value;
  String get role => _role.value;
  String get account => _account.value;
  String get phone => _phone.value;
  String get address => _address.value;
  String get lastName => _lastName.value;
  String get idUser => _id.value;
  List<Users>? get listUsers => _listUsers.value;

  Future<List<Users>> getUsersList() async {
    try {
      List<Users> list = await UserRequest.getUsersList();
      _listUsers.value = list;
      return list;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential user = await UserRequest.login(email, password);
      Users foundUser = await UserRequest.findUser(email);
      updateController(foundUser);
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  void updateController(Users user) {
    _email.value = user.email;
    _name.value = user.name;
    _lastName.value = user.lastName;
    _address.value = user.address;
    _role.value = user.role;
    _account.value = user.account;
    _phone.value = user.phone;
    _id.value = user.id;
  }

  Future<void> register(
      String name,
      String lastName,
      String email,
      String password,
      String phone,
      String address,
      String role,
      String account) async {
    try {
      UserCredential user = await UserRequest.register(
          name, lastName, email, password, phone, address, role, account);
      Users foundUser = await UserRequest.findUser(email);
      updateController(foundUser);
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<String> updateUser(Users user) async {
    try {
      String message = await UserRequest.updateUserData(user);

      Users foundUser = await UserRequest.findUser(user.email);
      updateController(foundUser);
      return message;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<String> deleteUser(String userId) async {
    try {
      return await UserRequest.deleteUser(userId);
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }
}
