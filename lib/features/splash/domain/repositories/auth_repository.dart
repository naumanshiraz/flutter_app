import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> getCurrentSession();
}
