import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';
import 'package:pms_app/features/profile/presentation/providers/profile_di_providers.dart';

enum EditProfileStatus { loading, ready, saving, saved }

class EditProfileState {
  final EditProfileStatus status;
  final EditableProfile profile;
  final bool isPickingImage;
  final String? errorMessage;

  const EditProfileState({
    this.status = EditProfileStatus.loading,
    this.profile = const EditableProfile(),
    this.isPickingImage = false,
    this.errorMessage,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    EditableProfile? profile,
    bool? isPickingImage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      isPickingImage: isPickingImage ?? this.isPickingImage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Backs both `EditProfilePage` and `ProfilePicturePage`. Uses
/// `autoDispose` for the usual "fresh data on each Edit-profile visit"
/// benefit — this stays safe across the two pages because
/// `ProfilePicturePage` is `push`ed *on top of* `EditProfilePage`, which
/// therefore remains mounted (and subscribed) underneath the whole time,
/// so the provider is never torn down mid-flow.
class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final Ref _ref;

  EditProfileNotifier(this._ref) : super(const EditProfileState()) {
    _load();
  }

  Future<void> _load() async {
    final useCase = _ref.read(getEditableProfileUseCaseProvider);
    final result = await useCase();
    result.when(
      onSuccess: (profile) {
        state = state.copyWith(status: EditProfileStatus.ready, profile: profile);
      },
      onFailure: (failure) {
        state = state.copyWith(status: EditProfileStatus.ready, errorMessage: failure.message);
      },
    );
  }

  void updateFields({
    String? name,
    String? email,
    String? phone,
    String? country,
    DateTime? birthDate,
    String? pronouns,
  }) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        name: name,
        email: email,
        phone: phone,
        country: country,
        birthDate: birthDate,
        pronouns: pronouns,
      ),
      clearError: true,
    );
  }

  /// Returns `true` if an image was picked (or the user cancelled — a
  /// silent no-op), `false` only for a real, surfaced failure.
  Future<bool> pickAvatar(ProfilePictureSource source) async {
    state = state.copyWith(isPickingImage: true, clearError: true);
    final useCase = _ref.read(pickProfilePictureUseCaseProvider);
    final result = await useCase(source);

    return result.when(
      onSuccess: (path) {
        state = state.copyWith(
          isPickingImage: false,
          profile: state.profile.copyWith(avatarPath: path),
        );
        return true;
      },
      onFailure: (failure) {
        if (failure is PickCancelledFailure) {
          state = state.copyWith(isPickingImage: false);
          return true;
        }
        state = state.copyWith(isPickingImage: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> save() async {
    if (state.profile.name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Name is required.');
      return false;
    }
    state = state.copyWith(status: EditProfileStatus.saving, clearError: true);

    final useCase = _ref.read(updateProfileUseCaseProvider);
    final result = await useCase(state.profile);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(status: EditProfileStatus.saved);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(status: EditProfileStatus.ready, errorMessage: failure.message);
        return false;
      },
    );
  }
}

final editProfileProvider = StateNotifierProvider.autoDispose<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(ref),
);
