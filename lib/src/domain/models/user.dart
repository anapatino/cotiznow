class Users {
  String name, lastName, address, phone, email, role, account, id, authId;
  List<String> quotationIds;

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
    required this.quotationIds,
  });

  factory Users.fromJson(Map<String, dynamic>? json) {
    List<String> quotationIds = (json?['quotationIds'] as List<dynamic>?)
            ?.map((id) => id as String)
            .toList() ??
        [];

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
      quotationIds: quotationIds,
    );
  }
}
