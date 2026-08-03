import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/service_profile/domain/entities/service_profile.dart';
import 'package:pms_app/features/service_profile/domain/repositories/service_profile_repository.dart';

class GetServiceProfileUseCase {
  final ServiceProfileRepository _repository;
  const GetServiceProfileUseCase(this._repository);

  Future<Result<ServiceProfile>> call(String serviceId) => _repository.getServiceProfile(serviceId);
}
