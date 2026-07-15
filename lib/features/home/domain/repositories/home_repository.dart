import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';
import 'package:pms_app/features/home/domain/entities/property_listing.dart';

/// Domain contract for the Home screen. Presentation depends only on
/// this interface — `HomeRepositoryImpl` (mocked today, real API
/// tomorrow) is an implementation detail.
abstract class HomeRepository {
  /// Prefers the profile collected during sign-up onboarding (cached
  /// locally); falls back to a demo profile if the user only ever
  /// logged in (no onboarding profile was ever collected).
  Future<Result<ProfileSummary>> getProfileSummary();

  /// Property listings for the grid. Today: a static mocked list.
  /// Tomorrow: `GET /properties`, filtered server-side.
  Future<Result<List<PropertyListing>>> getPropertyListings({String? searchQuery});
}
