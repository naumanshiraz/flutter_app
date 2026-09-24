import 'package:pms_app/core/utils/validators.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';

class AffiliateValidators {
  AffiliateValidators._();

  static String? nameError(String value) => Validators.nameError(value);

  static String? contactError(String value) {
    if (value.trim().isEmpty) return 'Please enter an email or phone number.';
    if (!Validators.isValidIdentifier(value)) return 'Enter a valid email or phone number.';
    return null;
  }

  static String? relationshipError(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please select a relationship.';
    return null;
  }

  static String? validateDraft({
    required String name,
    required String contact,
    required String? relationship,
  }) {
    return nameError(name) ?? contactError(contact) ?? relationshipError(relationship);
  }

  static bool isValid(Affiliate affiliate) {
    final contact = affiliate.email.isNotEmpty ? affiliate.email : affiliate.phone;
    return validateDraft(name: affiliate.name, contact: contact, relationship: affiliate.relationship) == null;
  }
}
