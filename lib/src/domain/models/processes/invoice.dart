import 'package:cotiznow/src/domain/domain.dart';

class Invoice {
  final InvoiceInfo info;
  final Quotation quotation;
  final Users user;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.quotation,
    required this.user,
    required this.items,
  });
}

class InvoiceInfo {
  final String address;
  final String number;
  final DateTime date;
  final String email;

  const InvoiceInfo({
    required this.address,
    required this.number,
    required this.date,
    required this.email,
  });
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double descount;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.descount,
    required this.unitPrice,
  });
}
