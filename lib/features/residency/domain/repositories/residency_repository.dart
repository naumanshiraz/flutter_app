import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';

abstract class ResidencyRepository {
  Future<Result<ResidencyAddress>> getCachedAddress();
  Future<Result<void>> saveAddress(ResidencyAddress address);
}
