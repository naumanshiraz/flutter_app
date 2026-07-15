import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';

/// Domain-layer contract. The Presentation layer depends only on this
/// interface, never on `AuthRepositoryImpl` or any Data-layer class —
/// classic dependency-inversion so mocked data can be swapped for a real
/// API later with zero changes above this line.
abstract class AuthRepository {
  /// Resolves whatever session currently exists on-device (token +
  /// cached flags). Never throws — always returns a [Result].
  Future<Result<AuthSession>> getCurrentSession();
}
