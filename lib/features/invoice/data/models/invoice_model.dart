import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

InvoiceStatus _statusFromApiValue(String? value) {
  switch (value) {
    case 'pending':
      return InvoiceStatus.pending;
    case 'overdue':
      return InvoiceStatus.overdue;
    default:
      return InvoiceStatus.none;
  }
}

@freezed
class InvoiceSummaryModel with _$InvoiceSummaryModel {
  const InvoiceSummaryModel._();

  const factory InvoiceSummaryModel({
    required String id,
    required String label,
    @Default('none') String status,
  }) = _InvoiceSummaryModel;

  factory InvoiceSummaryModel.fromJson(Map<String, dynamic> json) => _$InvoiceSummaryModelFromJson(json);

  InvoiceSummary toEntity() => InvoiceSummary(id: id, label: label, status: _statusFromApiValue(status));
}

@freezed
class InvoiceChargeModel with _$InvoiceChargeModel {
  const InvoiceChargeModel._();

  const factory InvoiceChargeModel({required String label, required String amount}) = _InvoiceChargeModel;

  factory InvoiceChargeModel.fromJson(Map<String, dynamic> json) => _$InvoiceChargeModelFromJson(json);

  InvoiceCharge toEntity() => InvoiceCharge(label: label, amount: amount);
}

@freezed
class InvoiceDetailModel with _$InvoiceDetailModel {
  const InvoiceDetailModel._();

  const factory InvoiceDetailModel({
    required String id,
    required String label,
    required String propertyName,
    required String propertyAddress,
    required String date,
    required String dueDate,
    required String invoiceNumber,
    required String billToName,
    required String billToAddress,
    required String balanceDue,
    @Default(<InvoiceChargeModel>[]) List<InvoiceChargeModel> charges,
  }) = _InvoiceDetailModel;

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) => _$InvoiceDetailModelFromJson(json);

  InvoiceDetail toEntity() => InvoiceDetail(
        id: id,
        label: label,
        propertyName: propertyName,
        propertyAddress: propertyAddress,
        date: date,
        dueDate: dueDate,
        invoiceNumber: invoiceNumber,
        billToName: billToName,
        billToAddress: billToAddress,
        balanceDue: balanceDue,
        charges: charges.map((c) => c.toEntity()).toList(),
      );
}
