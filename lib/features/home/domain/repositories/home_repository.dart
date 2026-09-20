import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';

abstract class HomeRepository {
  Future<Result<ProfileSummary>> getProfileSummary();
}
