import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/service_profile/domain/entities/service_profile.dart';

abstract class ServiceProfileRepository {
  Future<Result<ServiceProfile>> getServiceProfile(String serviceId);
}
