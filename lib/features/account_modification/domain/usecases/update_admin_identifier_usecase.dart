import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/account_modification/domain/repositories/account_modification_repository.dart';

class UpdateAdminIdentifierUseCase {
  final AccountModificationRepository _repository;
  const UpdateAdminIdentifierUseCase(this._repository);

  Future<Result<void>> call({required String currentIdentifier, required String newIdentifier}) =>
      _repository.updateAdminIdentifier(currentIdentifier: currentIdentifier, newIdentifier: newIdentifier);
}
