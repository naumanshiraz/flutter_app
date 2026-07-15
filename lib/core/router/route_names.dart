/// Centralized route paths/names for GoRouter. Every `context.go(...)`
/// call in the app should reference these constants, never raw strings.
class RouteNames {
  RouteNames._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String onboardingEmail = '/onboarding/email';
  static const String onboardingPhone = '/onboarding/phone';
  static const String onboardingProfile = '/onboarding/profile';
  static const String onboardingGender = '/onboarding/gender';
  static const String onboardingLocation = '/onboarding/location';
  static const String home = '/home';
  static const String editProfile = '/profile/edit';
  static const String profilePicture = '/profile/picture';
  static const String residencyIdentification = '/profile/residency';
  static const String familyMembers = '/profile/family-members';
  static const String editFamilyMember = '/profile/family-members/edit';
  static const String properties = '/profile/properties';
  static const String editProperty = '/profile/properties/edit';
}
