import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/properties/domain/entities/available_suite.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/domain/repositories/properties_repository.dart';

class GetAvailableSuitesUseCase {
  final PropertiesRepository _repository;
  const GetAvailableSuitesUseCase(this._repository);

  Future<Result<List<AvailableSuite>>> call(String campusId) => _repository.getAvailableSuites(campusId);
}

class SubmitClaimRequestUseCase {
  final PropertiesRepository _repository;
  const SubmitClaimRequestUseCase(this._repository);

  Future<Result<void>> call(String householdId) => _repository.submitClaimRequest(householdId);
}

class UpdatePropertyUseCase {
  final PropertiesRepository _repository;
  const UpdatePropertyUseCase(this._repository);

  Future<Result<void>> call(Property property) => _repository.updateProperty(property);
}

class DeletePropertyUseCase {
  final PropertiesRepository _repository;
  const DeletePropertyUseCase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteProperty(id);
}
