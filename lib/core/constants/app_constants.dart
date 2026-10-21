/// Centralized application constants.
class AppConstants {
  AppConstants._();

  // ---------------------------------------------------------------------
  // App Info
  // ---------------------------------------------------------------------
  static const String appName = 'Property Management System';
  static const String appVersion = '1.0.0';

  // ---------------------------------------------------------------------
  // Storage Keys (Secure Storage)
  // ---------------------------------------------------------------------
  static const String secureKeyAuthToken = 'secure_auth_token';
  static const String secureKeyRefreshToken = 'secure_refresh_token';

  // ---------------------------------------------------------------------
  // Storage Keys (Hive Boxes)
  // ---------------------------------------------------------------------
  static const String hiveBoxUser = 'user_box';
  static const String hiveBoxSettings = 'settings_box';
  static const String hiveKeyIsLoggedIn = 'is_logged_in';
  static const String hiveKeyUserProfile = 'user_profile';
  static const String hiveKeyOnboardingComplete = 'onboarding_complete';

  // ---------------------------------------------------------------------
  // Timing
  // ---------------------------------------------------------------------
  static const Duration splashMinimumDuration = Duration(milliseconds: 1800);
  static const Duration otpResendDuration = Duration(seconds: 120);
  static const Duration apiTimeout = Duration(seconds: 30);

  // ---------------------------------------------------------------------
  // API — Dobu Mobile API (Estavex), resident surface.
  // Staging default; local demo stack is http://localhost:3000.
  // ---------------------------------------------------------------------
  static const String baseUrl = 'https://api.estavex.com';
  static const String endpointOtpRequest = '/api/auth/otp/request';
  static const String endpointOtpVerify = '/api/auth/otp/verify';
  static const String endpointAuthMe = '/api/auth/me';
  static const String endpointAuthRefresh = '/api/auth/refresh';
  static const String endpointAuthLogout = '/api/auth/logout';
  static const String endpointProfile = '/api/app/profile';
  static const String endpointProfileAvatar = '/api/app/profile/avatar';
  static const String endpointCampuses = '/api/app/campuses';
  
  /// GET /api/app/campuses/{campusId}/households
  static String endpointCampusHouseholds(String campusId) =>
      '/api/app/campuses/$campusId/households';

  /// POST
  static const String endpointResidencyRequests = '/api/app/residency-requests';

  /// GET /api/app/households?project_id={campusId}
  static const String endpointHouseholds = '/api/app/households';

  /// GET /api/app/households/{householdId}
  static String endpointHouseholdDetail(String householdId) =>
      '/api/app/households/$householdId';

  /// GET /api/app/households/{householdId}/devices
  static String endpointHouseholdDevices(String householdId) =>
      '/api/app/households/$householdId/devices';

  /// GET /api/app/households/{householdId}/visitors
  static String endpointHouseholdVisitors(String householdId) =>
      '/api/app/households/$householdId/visitors';

  /// GET /api/app/households/{householdId}/invitations
  static String endpointHouseholdInvitations(String householdId) =>
      '/api/app/households/$householdId/invitations';

  static const String endpointResidencyRequestsIncoming = '/api/app/residency-requests/incoming';

  static String endpointResidencyRequestApprove(String id) => '/api/app/residency-requests/$id/approve';

  static String endpointResidencyRequestReject(String id) => '/api/app/residency-requests/$id/reject';

  static const String endpointInvitations = '/api/app/invitations';

  static String endpointInvitationAccept(String id) => '/api/app/invitations/$id/accept';    

  /// DELETE /api/app/invitations/{invitationId}
  static String endpointInvitation(String invitationId) => '/api/app/invitations/$invitationId';

  /// GET POST
  static String endpointHouseholdVehicles(String householdId) => '/api/app/households/$householdId/vehicles';

  /// PATCH DELETE
  static String endpointHouseholdVehicle(String householdId, String vehicleId) =>
      '/api/app/households/$householdId/vehicles/$vehicleId';

  /// GET POST
  static String endpointHouseholdPets(String householdId) => '/api/app/households/$householdId/pets';

  /// PATCH DELETE
  static String endpointHouseholdPet(String householdId, String petId) =>
      '/api/app/households/$householdId/pets/$petId';
      
  /// GET /api/app/households/owned/members
  static const String endpointOwnedMembers = '/api/app/households/owned/members';

  /// GET /api/app/households/{householdId}/members
  static String endpointHouseholdMembers(String householdId) =>
      '/api/app/households/$householdId/members';
}
