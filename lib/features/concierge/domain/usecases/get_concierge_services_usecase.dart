import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_category.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_service_feed.dart';
import 'package:pms_app/features/concierge/domain/repositories/concierge_repository.dart';

class GetConciergeServicesUseCase {
  final ConciergeRepository _repository;
  const GetConciergeServicesUseCase(this._repository);

  Future<Result<ConciergeServiceFeed>> call({
    ConciergeCategory category = ConciergeCategory.forYou,
  }) {
    return _repository.getServices(category: category);
  }
}
