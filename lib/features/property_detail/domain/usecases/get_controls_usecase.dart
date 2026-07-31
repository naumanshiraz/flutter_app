import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';
import 'package:pms_app/features/main_home/domain/repositories/main_home_repository.dart';

class GetControlsUseCase {
  final MainHomeRepository _repository;
  const GetControlsUseCase(this._repository);

  Future<Result<List<Control>>> call({String? propertyId}) => _repository.getControls(propertyId: propertyId);
}