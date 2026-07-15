import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/domain/repositories/properties_repository.dart';

class GetPropertiesUseCase {
  final PropertiesRepository _repository;
  const GetPropertiesUseCase(this._repository);

  Future<Result<List<Property>>> call() => _repository.getProperties();
}

class AddPropertyUseCase {
  final PropertiesRepository _repository;
  const AddPropertyUseCase(this._repository);

  Future<Result<void>> call(Property property) => _repository.addProperty(property);
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
