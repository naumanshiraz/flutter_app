import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

DateTime? _date(String? v) => DateTime.tryParse(v ?? '');

String _dateLabel(String? v) {
  final d = _date(v);
  return d == null ? '' : DateFormat('MMM d, y').format(d);
}

String _mnt(num value) => 'MNT ${NumberFormat('#,##0').format(value)}';

@freezed
class InvoiceSummaryModel with _$InvoiceSummaryModel {
  const InvoiceSummaryModel._();

  const factory InvoiceSummaryModel({
    required String id,
    @Default('') String number,
    @JsonKey(name: 'issued_on') String? issuedOn,
    @JsonKey(name: 'due_on') String? dueOn,
    @JsonKey(name: 'total_mnt') @Default(0) num totalMnt,
    @JsonKey(name: 'is_new') @Default(false) bool isNew,
  }) = _InvoiceSummaryModel;

  factory InvoiceSummaryModel.fromJson(Map<String, dynamic> json) => _$InvoiceSummaryModelFromJson(json);

  /// The API has no payment status, so it is derived from the due date.
  InvoiceStatus get status {
    final due = _date(dueOn);
    if (due == null) return InvoiceStatus.none;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return due.isBefore(today) ? InvoiceStatus.overdue : InvoiceStatus.pending;
  }

  InvoiceSummary toEntity() =>
      InvoiceSummary(id: id, label: '${_dateLabel(issuedOn)} - Invoice', status: status);
}

@freezed
class InvoiceChargeModel with _$InvoiceChargeModel {
  const InvoiceChargeModel._();

  const factory InvoiceChargeModel({
    @Default('') String name,
    @JsonKey(name: 'total_mnt') @Default(0) num totalMnt,
  }) = _InvoiceChargeModel;

  factory InvoiceChargeModel.fromJson(Map<String, dynamic> json) => _$InvoiceChargeModelFromJson(json);

  InvoiceCharge toEntity() => InvoiceCharge(label: name, amount: _mnt(totalMnt));
}

@freezed
class InvoiceDetailModel with _$InvoiceDetailModel {
  const InvoiceDetailModel._();

  const factory InvoiceDetailModel({
    required String id,
    @Default('') String number,
    @JsonKey(name: 'issued_on') String? issuedOn,
    @JsonKey(name: 'due_on') String? dueOn,
    @JsonKey(name: 'billed_to') @Default('') String billedTo,
    @JsonKey(name: 'building_name') @Default('') String buildingName,
    @Default('') String suite,
    @JsonKey(name: 'vat_mnt') @Default(0) num vatMnt,
    @JsonKey(name: 'total_mnt') @Default(0) num totalMnt,
    @Default(<InvoiceChargeModel>[]) List<InvoiceChargeModel> lines,
  }) = _InvoiceDetailModel;

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) => _$InvoiceDetailModelFromJson(json);

  InvoiceDetail toEntity() {
    final suiteLabel = suite.isEmpty ? '' : 'Suite $suite';
    return InvoiceDetail(
      id: id,
      label: '${_dateLabel(issuedOn)} - Invoice',
      propertyName: buildingName,
      propertyAddress: suiteLabel,
      date: _dateLabel(issuedOn),
      dueDate: _dateLabel(dueOn),
      invoiceNumber: number,
      billToName: billedTo,
      billToAddress: [buildingName, suiteLabel].where((p) => p.isNotEmpty).join(', '),
      balanceDue: _mnt(totalMnt),
      charges: [
        ...lines.map((l) => l.toEntity()),
        if (vatMnt > 0) InvoiceCharge(label: 'VAT', amount: _mnt(vatMnt)),
      ],
    );
  }
}
