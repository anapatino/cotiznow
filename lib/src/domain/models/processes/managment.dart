class Management {
  final Contact contact;
  final MethodOfPayment methodOfPayment;

  const Management({
    required this.contact,
    required this.methodOfPayment,
  });

  Map<String, dynamic> toJson() {
    return {
      'contact': contact.toJson(),
      'methodOfPayment': methodOfPayment.toJson(),
    };
  }
}

class Contact {
  final String phone;
  final String messageWhatsApp;
  final String email;

  Contact({
    required this.phone,
    required this.messageWhatsApp,
    required this.email,
  });

  factory Contact.fromFirestore(Map<String, dynamic>? data) {
    return Contact(
      phone: data?['phone'] ?? '',
      messageWhatsApp: data?['messageWhatsApp'] ?? '',
      email: data?['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'messageWhatsApp': messageWhatsApp,
      'email': email,
    };
  }
}

class MethodOfPayment {
  final Bancolombia bancolombia;
  final String nequi;
  final String daviplata;

  MethodOfPayment({
    required this.bancolombia,
    required this.nequi,
    required this.daviplata,
  });

  factory MethodOfPayment.fromFirestore(Map<String, dynamic>? data) {
    return MethodOfPayment(
      bancolombia: Bancolombia.fromMap(data?['bancolombia']),
      nequi: data?['nequi'] ?? '',
      daviplata: data?['daviplata'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bancolombia': bancolombia.toJson(),
      'nequi': nequi,
      'daviplata': daviplata,
    };
  }
}

class Bancolombia {
  final String name;
  final String cc;
  final String account;
  final String number;

  Bancolombia({
    required this.name,
    required this.cc,
    required this.account,
    required this.number,
  });

  factory Bancolombia.fromMap(Map<String, dynamic>? data) {
    return Bancolombia(
      name: data?['name'] ?? '',
      cc: data?['cc'] ?? '',
      account: data?['account'] ?? '',
      number: data?['number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cc': cc,
      'account': account,
      'number': number,
    };
  }
}
