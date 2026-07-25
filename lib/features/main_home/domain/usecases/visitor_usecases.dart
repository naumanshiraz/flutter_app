import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';
import 'package:pms_app/features/main_home/domain/repositories/visitor_repository.dart';

class GetVisitorSchedulesUseCase {
  final VisitorRepository repository;
  const GetVisitorSchedulesUseCase(this.repository);
  Future<Result<List<VisitorSchedule>>> call() => repository.getSchedules();
}

class AddOrUpdateVisitorScheduleUseCase {
  final VisitorRepository repository;
  const AddOrUpdateVisitorScheduleUseCase(this.repository);
  Future<Result<void>> call(VisitorSchedule schedule) => repository.addOrUpdateSchedule(schedule);
}

class DeleteVisitorScheduleUseCase {
  final VisitorRepository repository;
  const DeleteVisitorScheduleUseCase(this.repository);
  Future<Result<void>> call(String id) => repository.deleteSchedule(id);
}