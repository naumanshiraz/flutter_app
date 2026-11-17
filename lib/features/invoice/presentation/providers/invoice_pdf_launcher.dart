import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pms_app/features/invoice/presentation/providers/invoice_di_providers.dart';

Future<void> openInvoicePdf(BuildContext context, WidgetRef ref, String invoiceId) async {
  final messenger = ScaffoldMessenger.of(context);
  void toast(String message) => messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  toast('Downloading invoice…');
  final result = await ref.read(downloadInvoicePdfUseCaseProvider)(invoiceId);
  final path = result.when(onSuccess: (p) => p, onFailure: (f) {
    toast(f.message);
    return null;
  });
  if (path == null) return;

  messenger.hideCurrentSnackBar();
  final opened = await OpenFilex.open(path, type: 'application/pdf');
  if (opened.type != ResultType.done) {
    toast('No app available to open the PDF.');
  }
}
