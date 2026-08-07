import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/auth/presentation/pages/login_page.dart';
import 'package:pms_app/features/auth/presentation/pages/onboarding_email_page.dart';
import 'package:pms_app/features/auth/presentation/pages/onboarding_gender_page.dart';
import 'package:pms_app/features/auth/presentation/pages/onboarding_location_page.dart';
import 'package:pms_app/features/auth/presentation/pages/onboarding_phone_page.dart';
import 'package:pms_app/features/auth/presentation/pages/onboarding_profile_page.dart';
import 'package:pms_app/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:pms_app/features/auth/presentation/providers/otp_verification_provider.dart';
import 'package:pms_app/features/chat/presentation/pages/chat_list_page.dart';
import 'package:pms_app/features/chat/presentation/pages/announcement_feed_page.dart';
import 'package:pms_app/features/chat/presentation/pages/post_detail_page.dart';
import 'package:pms_app/features/chat/presentation/pages/public_chat_page.dart';
import 'package:pms_app/features/chat/presentation/pages/group_info_page.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';
import 'package:pms_app/features/family_members/presentation/pages/edit_family_member_page.dart';
import 'package:pms_app/features/family_members/presentation/pages/family_members_page.dart';
import 'package:pms_app/features/home/presentation/pages/home_page.dart';
import 'package:pms_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:pms_app/features/profile/presentation/pages/profile_picture_page.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/presentation/pages/edit_property_page.dart';
import 'package:pms_app/features/properties/presentation/pages/properties_page.dart';
import 'package:pms_app/features/residency/presentation/pages/residency_identification_page.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';
import 'package:pms_app/features/vehicles/presentation/pages/edit_vehicle_page.dart';
import 'package:pms_app/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';
import 'package:pms_app/features/pets/presentation/pages/edit_pet_page.dart';
import 'package:pms_app/features/pets/presentation/pages/pets_page.dart';
import 'package:pms_app/features/residency_terms/presentation/pages/term_screen_page.dart';
import 'package:pms_app/features/main_home//presentation/pages/main_home_page.dart';
import 'package:pms_app/features/property_detail/presentation/pages/property_detail_page.dart';
import 'package:pms_app/features/invoice/presentation/pages/invoice_payment_page.dart';
import 'package:pms_app/features/billing_account/presentation/pages/billing_account_page.dart';
import 'package:pms_app/features/payment/presentation/pages/payment_page.dart';
import 'package:pms_app/features/bank_transaction/presentation/pages/bank_transaction_page.dart';
import 'package:pms_app/features/service_profile/presentation/pages/service_profile_page.dart';
import 'package:pms_app/features/account_modification/presentation/pages/admin_account_modification_page.dart';
import 'package:pms_app/features/account_termination/presentation/pages/account_termination_page.dart';
import 'package:pms_app/features/splash/domain/entities/app_destination.dart';
import 'package:pms_app/features/splash/presentation/pages/splash_page.dart';
import 'package:pms_app/features/splash/presentation/providers/app_initialization_provider.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen<AsyncValue<AppDestination>>(
      appInitializationProvider,
      (previous, next) => notifyListeners(),
    );
  }
}

final _routerRefreshProvider = Provider<_RouterRefreshNotifier>((ref) {
  return _RouterRefreshNotifier(ref);
});

/// -------------------------------------------------------------------
/// Route Guard
/// -------------------------------------------------------------------
String? _routeGuard(BuildContext context, GoRouterState state, Ref ref) {
  final initAsync = ref.read(appInitializationProvider);
  final currentPath = state.matchedLocation;
  final isSplashRoute = currentPath == RouteNames.splash;

  return initAsync.when(
    loading: () => isSplashRoute ? null : RouteNames.splash,
    error: (_, __) => isSplashRoute ? null : RouteNames.splash,
    data: (destination) {
      final isAuthenticated = destination == AppDestination.home;
      final isLoginRoute = currentPath == RouteNames.login;
      final isProtectedRoute = currentPath == RouteNames.home ||
          currentPath == RouteNames.mainHome ||
          currentPath == RouteNames.chat ||
          currentPath == RouteNames.chatAnnouncement ||
          currentPath == RouteNames.chatPostDetail ||
          currentPath == RouteNames.chatPublicGroup ||
          currentPath == RouteNames.chatGroupInfo ||
          currentPath == RouteNames.editProfile ||
          currentPath == RouteNames.profilePicture ||
          currentPath == RouteNames.residencyIdentification ||
          currentPath == RouteNames.familyMembers ||
          currentPath == RouteNames.editFamilyMember ||
          currentPath == RouteNames.properties ||
          currentPath == RouteNames.editProperty ||
          currentPath == RouteNames.vehicles ||
          currentPath == RouteNames.editVehicle ||
          currentPath == RouteNames.pets ||
          currentPath == RouteNames.editPet ||
          currentPath == RouteNames.residencyTerms ||
          currentPath == RouteNames.propertyDetail ||
          currentPath == RouteNames.invoicePayment ||
          currentPath == RouteNames.billingAccount ||
          currentPath == RouteNames.payment ||
          currentPath == RouteNames.bankTransaction || 
          currentPath == RouteNames.serviceProfile ||
          currentPath == RouteNames.adminAccountModification || 
          currentPath == RouteNames.accountTermination;

      if (isSplashRoute) {
        return isAuthenticated ? RouteNames.home : RouteNames.login;
      }
      if (!isAuthenticated && isProtectedRoute) {
        return RouteNames.login;
      }
      if (isAuthenticated && isLoginRoute) {
        return RouteNames.home;
      }
      return null; // Already on the correct route — no redirect.
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(_routerRefreshProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refreshNotifier,
    redirect: (context, state) => _routeGuard(context, state, ref),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) {
          final args = state.extra as OtpVerificationArgs?;
          if (args == null) {
            return const PlaceholderPage(
              title: 'OTP Verification',
              routeName: RouteNames.otpVerification,
            );
          }
          return OtpVerificationPage(args: args);
        },
      ),
      GoRoute(
        path: RouteNames.onboardingEmail,
        name: RouteNames.onboardingEmail,
        builder: (context, state) => const OnboardingEmailPage(),
      ),
      GoRoute(
        path: RouteNames.onboardingPhone,
        name: RouteNames.onboardingPhone,
        builder: (context, state) => const OnboardingPhonePage(),
      ),
      GoRoute(
        path: RouteNames.onboardingProfile,
        name: RouteNames.onboardingProfile,
        builder: (context, state) => const OnboardingProfilePage(),
      ),
      GoRoute(
        path: RouteNames.onboardingGender,
        name: RouteNames.onboardingGender,
        builder: (context, state) => const OnboardingGenderPage(),
      ),
      GoRoute(
        path: RouteNames.onboardingLocation,
        name: RouteNames.onboardingLocation,
        builder: (context, state) => const OnboardingLocationPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.chat,
        name: RouteNames.chat,
        builder: (context, state) => const ChatListPage(),
      ),
      GoRoute(
        path: RouteNames.chatAnnouncement,
        name: RouteNames.chatAnnouncement,
        builder: (context, state) {
          final args = state.extra as AnnouncementFeedArgs?;
          if (args == null) {
            return const PlaceholderPage(
              title: 'Group Announcement',
              routeName: RouteNames.chatAnnouncement,
            );
          }
          return AnnouncementFeedPage(args: args);
        },
      ),
      GoRoute(
        path: RouteNames.chatPostDetail,
        name: RouteNames.chatPostDetail,
        builder: (context, state) {
          final args = state.extra as PostDetailArgs?;
          if (args == null) {
            return const PlaceholderPage(
              title: 'Group Announcement Comment',
              routeName: RouteNames.chatPostDetail,
            );
          }
          return PostDetailPage(args: args);
        },
      ),
      GoRoute(
        path: RouteNames.chatPublicGroup,
        name: RouteNames.chatPublicGroup,
        builder: (context, state) {
          final args = state.extra as PublicChatArgs?;
          if (args == null) {
            return const PlaceholderPage(
              title: 'Public Chat Group',
              routeName: RouteNames.chatPublicGroup,
            );
          }
          return PublicChatPage(args: args);
        },
      ),
      GoRoute(
        path: RouteNames.chatGroupInfo,
        name: RouteNames.chatGroupInfo,
        builder: (context, state) {
          final args = state.extra as GroupInfoArgs?;
          if (args == null) {
            return const PlaceholderPage(
              title: 'Chat Details',
              routeName: RouteNames.chatGroupInfo,
            );
          }
          return GroupInfoPage(args: args);
        },
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.profilePicture,
        name: RouteNames.profilePicture,
        builder: (context, state) => const ProfilePicturePage(),
      ),
      GoRoute(
        path: RouteNames.residencyIdentification,
        name: RouteNames.residencyIdentification,
        builder: (context, state) => const ResidencyIdentificationPage(),
      ),
      GoRoute(
        path: RouteNames.familyMembers,
        name: RouteNames.familyMembers,
        builder: (context, state) => const FamilyMembersPage(),
      ),
      GoRoute(
        path: RouteNames.editFamilyMember,
        name: RouteNames.editFamilyMember,
        builder: (context, state) {
          final member = state.extra as FamilyMember?;
          if (member == null) {
            return const EditFamilyMemberFallbackPage();
          }
          return EditFamilyMemberPage(member: member);
        },
      ),
      GoRoute(
        path: RouteNames.properties,
        name: RouteNames.properties,
        builder: (context, state) => const PropertiesPage(),
      ),
      GoRoute(
        path: RouteNames.editProperty,
        name: RouteNames.editProperty,
        builder: (context, state) {
          final property = state.extra as Property?;
          if (property == null) return const EditPropertyFallbackPage();
          return EditPropertyPage(property: property);
        },
      ),
      GoRoute(
        path: RouteNames.vehicles,
        name: RouteNames.vehicles,
        builder: (context, state) => const VehiclesPage(),
      ),
      GoRoute(
        path: RouteNames.editVehicle,
        name: RouteNames.editVehicle,
        builder: (context, state) {
          final vehicle = state.extra as Vehicle?;
          if (vehicle == null) return const EditVehicleFallbackPage();
          return EditVehiclePage(vehicle: vehicle);
        },
      ),
      GoRoute(
        path: RouteNames.pets,
        name: RouteNames.pets,
        builder: (context, state) => const PetsPage(),
      ),
      GoRoute(
        path: RouteNames.editPet,
        name: RouteNames.editPet,
        builder: (context, state) {
          final pet = state.extra as Pet?;
          if (pet == null) return const EditPetFallbackPage();
          return EditPetPage(pet: pet);
        },
      ),
      GoRoute(
        path: RouteNames.residencyTerms,
        name: RouteNames.residencyTerms,
        builder: (context, state) => const ResidencyTermsPage(),
      ),
      GoRoute(
        path: RouteNames.mainHome,
        name: RouteNames.mainHome,
        builder: (context, state) => MainHomePage(propertyId: state.extra as String?),
      ),
      GoRoute(
        path: RouteNames.propertyDetail,
        name: RouteNames.propertyDetail,
        builder: (context, state) {
          final propertyId = state.extra as String? ?? 'gerlug-vista';
          return PropertyDetailPage(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: RouteNames.invoicePayment,
        name: RouteNames.invoicePayment,
        builder: (context, state) {
          final invoiceId = state.extra as String? ?? 'inv-2024-05';
          return InvoicePaymentPage(invoiceId: invoiceId);
        },
      ),
      GoRoute(
        path: RouteNames.billingAccount,
        name: RouteNames.billingAccount,
        builder: (context, state) => const BillingAccountPage(),
      ),
      GoRoute(
        path: RouteNames.payment,
        name: RouteNames.payment,
        builder: (context, state) => const PaymentPage(),
      ),
      GoRoute(
        path: RouteNames.bankTransaction,
        name: RouteNames.bankTransaction,
        builder: (context, state) => BankTransactionPage(paymentMethodId: state.extra as String? ?? 'trade_dev_bank'),
      ),
      GoRoute(
        path: RouteNames.serviceProfile,
        name: RouteNames.serviceProfile,
        builder: (context, state) => ServiceProfilePage(serviceId: state.extra as String? ?? 'california_bakery'),
      ),
      GoRoute(
        path: RouteNames.adminAccountModification,
        name: RouteNames.adminAccountModification,
        builder: (context, state) => const AdminAccountModificationPage(),
      ),
      GoRoute(
        path: RouteNames.accountTermination,
        name: RouteNames.accountTermination,
        builder: (context, state) => const AccountTerminationPage(),
      ),
    ],
    errorBuilder: (context, state) => PlaceholderPage(
      title: 'Not Found',
      routeName: state.matchedLocation,
    ),
  );
});
