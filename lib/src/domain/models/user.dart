class Users {
  String name, lastName, adress, phone, email, password, role, account;

  Users(
      {required this.name,
      required this.lastName,
      required this.phone,
      required this.adress,
      required this.email,
      required this.password,
      required this.role,
      required this.account});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      adress: json['adress'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      account: json['account'] ?? '',
    );
  }
}
