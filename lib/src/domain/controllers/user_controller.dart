import 'dart:developer';
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
  final Rxn<List<Users>> _listUsers = Rxn<List<Users>>();

  String get userEmail => _email.value;
  String get name => _name.value;
  String get role => _role.value;
  String get account => _account.value;
  String get phone => _phone.value;
  List<Users>? get listUsers => _listUsers.value;

  Future<void> getUsersList() async {
    try {
      List<Users> list = await UserRequest.getUsersList();
      _listUsers.value = list;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential user = await UserRequest.login(email, password);
      Users foundUser = await UserRequest.findUser(email);
      _email.value = user.user!.email;
      _name.value = foundUser.name;
      _role.value = foundUser.role;
      _account.value = foundUser.account;
      _phone.value = foundUser.phone;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> register(String name, String lastName, String email,
      String password, String phone, String address) async {
    try {
      UserCredential user = await UserRequest.register(
          name, lastName, email, password, phone, address);
      _email.value = user.user!.email;
      Users foundUser = await UserRequest.findUser(email);
      _name.value = foundUser.name;
      _role.value = foundUser.role;
      _account.value = foundUser.account;
      _phone.value = foundUser.phone;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }
}
