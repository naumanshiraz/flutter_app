import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';
import 'package:pms_app/features/residency/domain/repositories/residency_repository.dart';

class GetCachedResidencyAddressUseCase {
  final ResidencyRepository _repository;
  const GetCachedResidencyAddressUseCase(this._repository);

  Future<Result<ResidencyAddress>> call() => _repository.getCachedAddress();
}

class SaveResidencyAddressUseCase {
  final ResidencyRepository _repository;
  const SaveResidencyAddressUseCase(this._repository);

  Future<Result<void>> call(ResidencyAddress address) => _repository.saveAddress(address);
}
