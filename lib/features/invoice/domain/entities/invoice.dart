import 'package:equatable/equatable.dart';

enum InvoiceStatus { pending, overdue, none }

/// One row in `InvoiceSheet`'s list.
class InvoiceSummary extends Equatable {
  final String id;
  final String label;
  final InvoiceStatus status;

  const InvoiceSummary({required this.id, required this.label, required this.status});

  @override
  List<Object?> get props => [id, label, status];
}

class InvoiceCharge extends Equatable {
  final String label;
  final String amount;

  const InvoiceCharge({required this.label, required this.amount});

  @override
  List<Object?> get props => [label, amount];
}

/// Full body for `InvoicePaymentPage`.
class InvoiceDetail extends Equatable {
  final String id;
  final String label;
  final String propertyName;
  final String propertyAddress;
  final String date;
  final String dueDate;
  final String invoiceNumber;
  final String billToName;
  final String billToAddress;
  final String balanceDue;
  final List<InvoiceCharge> charges;

  const InvoiceDetail({
    required this.id,
    required this.label,
    required this.propertyName,
    required this.propertyAddress,
    required this.date,
    required this.dueDate,
    required this.invoiceNumber,
    required this.billToName,
    required this.billToAddress,
    required this.balanceDue,
    this.charges = const [],
  });

  @override
  List<Object?> get props => [
        id,
        label,
        propertyName,
        propertyAddress,
        date,
        dueDate,
        invoiceNumber,
        billToName,
        billToAddress,
        balanceDue,
        charges,
      ];
}
