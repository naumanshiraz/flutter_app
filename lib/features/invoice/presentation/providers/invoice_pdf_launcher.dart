import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/invoice/presentation/providers/invoice_di_providers.dart';
import 'package:url_launcher/url_launcher.dart';

/// Resolves the invoice PDF link via the API and opens it in the browser.
Future<void> openInvoicePdf(BuildContext context, WidgetRef ref, String invoiceId) async {
  final messenger = ScaffoldMessenger.of(context);
  void toast(String message) => messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  final result = await ref.read(getInvoicePdfUrlUseCaseProvider)(invoiceId);
  final url = result.when(onSuccess: (u) => u, onFailure: (f) {
    toast(f.message);
    return null;
  });
  if (url == null) return;

  try {
    final opened = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!opened) toast('Could not open the invoice PDF.');
  } catch (_) {
    toast('Could not open the invoice PDF.');
  }
}
