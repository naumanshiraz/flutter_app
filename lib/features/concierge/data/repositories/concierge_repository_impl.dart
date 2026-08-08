import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/concierge/data/datasources/concierge_remote_datasource.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_category.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_grid_layout.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_service_feed.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_service_item.dart';
import 'package:pms_app/features/concierge/domain/repositories/concierge_repository.dart';
import 'package:pms_app/features/property_detail/data/models/service_listing_model.dart';

class ConciergeRepositoryImpl implements ConciergeRepository {
  final ConciergeRemoteDataSource _remoteDataSource;

  ConciergeRepositoryImpl({required ConciergeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<ConciergeServiceFeed>> getServices({
    ConciergeCategory category = ConciergeCategory.forYou,
  }) async {
    try {
      final json = await _remoteDataSource.getServices(category.name);
      final layout = conciergeGridLayoutFromApiValue(json['layout'] as String?);
      final servicesJson = (json['services'] as List<dynamic>).cast<Map<String, dynamic>>();
      final items = servicesJson.map((itemJson) {
        final service = ServiceListingModel.fromJson(itemJson).toEntity();
        final isBanner = itemJson['isBanner'] as bool? ?? false;
        return ConciergeServiceItem(service: service, isBanner: isBanner);
      }).toList();
      return Success(ConciergeServiceFeed(items: items, layout: layout));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load services: $e'));
    }
  }
}
