import 'package:pms_app/core/utils/result.dart';

abstract class AccountModificationRepository {
  Future<Result<void>> updateAdminIdentifier({
    required String currentIdentifier,
    required String newIdentifier,
  });
}
