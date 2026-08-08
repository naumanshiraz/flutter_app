import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_category.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_service_feed.dart';

abstract class ConciergeRepository {
  Future<Result<ConciergeServiceFeed>> getServices({
    ConciergeCategory category = ConciergeCategory.forYou,
  });
}
