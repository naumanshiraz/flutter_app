import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';
import 'package:pms_app/features/home/domain/entities/property_listing.dart';
import 'package:pms_app/features/home/domain/repositories/home_repository.dart';

class GetProfileSummaryUseCase {
  final HomeRepository _repository;
  const GetProfileSummaryUseCase(this._repository);

  Future<Result<ProfileSummary>> call() => _repository.getProfileSummary();
}

class GetPropertyListingsUseCase {
  final HomeRepository _repository;
  const GetPropertyListingsUseCase(this._repository);

  Future<Result<List<PropertyListing>>> call({String? searchQuery}) {
    return _repository.getPropertyListings(searchQuery: searchQuery);
  }
}
