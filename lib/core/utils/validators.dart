class Validators {
  Validators._();

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  static bool isEmail(String value) => _emailRegex.hasMatch(value.trim());

  static bool isPhone(String value) =>
      _phoneRegex.hasMatch(value.trim().replaceAll(RegExp(r'[\s\-()]'), ''));

  /// Login/Sign up field accepts either shape.
  static bool isValidIdentifier(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    return isEmail(trimmed) || isPhone(trimmed);
  }

  static String? identifierError(String value) {
    if (value.trim().isEmpty) return 'Please enter your phone number or email address.';
    if (!isValidIdentifier(value)) return 'Enter a valid phone number or email address.';
    return null;
  }

  static String? emailError(String value) {
    if (value.trim().isEmpty) return 'Please enter your email address.';
    if (!isEmail(value)) return 'Enter a valid email address.';
    return null;
  }

  static String? phoneError(String value) {
    if (value.trim().isEmpty) return 'Please enter your phone number.';
    if (!isPhone(value)) return 'Enter a valid phone number.';
    return null;
  }

  static String? nameError(String value) {
    if (value.trim().isEmpty) return 'Please enter your name.';
    if (value.trim().length < 2) return 'Name is too short.';
    return null;
  }

  static String? requiredError(String value, String label) {
    if (value.trim().isEmpty) return 'Please enter $label.';
    return null;
  }

  static String maskIdentifier(String value) {
    if (isEmail(value)) {
      final parts = value.split('@');
      final local = parts.first;
      final visible = local.length <= 4 ? local.substring(0, 1) : local.substring(0, 4);
      return '$visible*****@${parts.last}';
    }
    if (value.length <= 6) return value;
    final visibleStart = value.substring(0, value.length - 6);
    final visibleEnd = value.substring(value.length - 3);
    return '$visibleStart*****$visibleEnd';
  }
}
