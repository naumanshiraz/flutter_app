import 'package:pms_app/core/utils/result.dart';

abstract class AccountTerminationRepository {
  Future<Result<void>> terminateAccount({
    required String reason,
    required String feedback,
  });
}
