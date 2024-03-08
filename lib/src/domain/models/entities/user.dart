class Users {
  String name, lastName, address, phone, email, role, account, id, authId;

  Users({
    required this.name,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.email,
    required this.role,
    required this.account,
    required this.id,
    required this.authId,
  });

  factory Users.fromJson(Map<String, dynamic>? json) {
    return Users(
      name: json?['name'] ?? '',
      lastName: json?['lastName'] ?? '',
      phone: json?['phone'] ?? '',
      address: json?['address'] ?? '',
      email: json?['email'] ?? '',
      role: json?['role'] ?? '',
      account: json?['account'] ?? '',
      id: json?['id'] ?? '',
      authId: json?['authId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'email': email,
      'role': role,
      'account': account,
      'id': id,
      'authId': authId,
    };
  }
}
