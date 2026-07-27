import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/property_detail/domain/entities/property_detail.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';
import 'package:pms_app/features/property_detail/domain/repositories/property_detail_repository.dart';

class GetPropertyDetailUseCase {
  final PropertyDetailRepository _repository;
  const GetPropertyDetailUseCase(this._repository);

  Future<Result<PropertyDetail>> call(String propertyId) =>
      _repository.getPropertyDetail(propertyId);
}

class GetServicesUseCase {
  final PropertyDetailRepository _repository;
  const GetServicesUseCase(this._repository);

  Future<Result<List<ServiceListing>>> call(String propertyId) =>
      _repository.getServices(propertyId);
}
