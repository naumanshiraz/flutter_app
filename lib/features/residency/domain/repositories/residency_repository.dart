import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';

/// Domain contract for the Residency Identification step. Deliberately
/// split from geo-hierarchy lookups (Country -> City -> District ->
/// Khoroo -> Residence), which are exposed separately since they're
/// synchronous local reference data today — see
/// `ResidencyGeoDataSource`. This repository only covers persistence.
abstract class ResidencyRepository {
  Future<Result<ResidencyAddress>> getCachedAddress();
  Future<Result<void>> saveAddress(ResidencyAddress address);
}
