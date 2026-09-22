import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';

abstract class MainHomeRepository {
  Future<Result<List<Control>>> getControls({String? householdId});

  Future<Result<void>> toggleControl(String id, bool newState);
}
