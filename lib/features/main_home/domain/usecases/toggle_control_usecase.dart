import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/repositories/main_home_repository.dart';

class ToggleControlUseCase {
  final MainHomeRepository _repository;
  const ToggleControlUseCase(this._repository);

  Future<Result<void>> call(String id, bool newState) => _repository.toggleControl(id, newState);
}
