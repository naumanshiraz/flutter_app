import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';

abstract class VisitorRepository {
  Future<Result<List<VisitorSchedule>>> getSchedules();
  Future<Result<void>> addOrUpdateSchedule(VisitorSchedule schedule);
  Future<Result<void>> deleteSchedule(String id);
}