import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';
import 'package:pms_app/features/auth/presentation/providers/auth_providers.dart';

/// Carries the sign-up profile across all 5 onboarding steps (email,
/// phone, name + birthdate, gender, location). Each page reads/writes
/// its own slice via [update]; the final step calls [submit].
class SignupProfileNotifier extends StateNotifier<UserProfile> {
  final Ref _ref;

  SignupProfileNotifier(this._ref) : super(const UserProfile());

  void update(UserProfile Function(UserProfile current) updater) {
    state = updater(state);
  }

  Future<Result<void>> submit() async {
    final useCase = _ref.read(completeSignupUseCaseProvider);
    return useCase(state);
  }
}

final signupProfileProvider =
    StateNotifierProvider.autoDispose<SignupProfileNotifier, UserProfile>(
  (ref) => SignupProfileNotifier(ref),
);
