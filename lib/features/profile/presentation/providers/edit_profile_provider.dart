import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';
import 'package:pms_app/features/profile/presentation/providers/profile_di_providers.dart';

enum EditProfileStatus { loading, ready, saving, saved }

class EditProfileState {
  final EditProfileStatus status;
  final EditableProfile profile;
  final bool isPickingImage;
  final bool isUploadingAvatar;
  final String? errorMessage;

  const EditProfileState({
    this.status = EditProfileStatus.loading,
    this.profile = const EditableProfile(),
    this.isPickingImage = false,
    this.isUploadingAvatar = false,
    this.errorMessage,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    EditableProfile? profile,
    bool? isPickingImage,
    bool? isUploadingAvatar,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      isPickingImage: isPickingImage ?? this.isPickingImage,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

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

  Future<bool> pickAvatar(ProfilePictureSource source) async {
    state = state.copyWith(isPickingImage: true, clearError: true);
    final pickUseCase = _ref.read(pickProfilePictureUseCaseProvider);
    final pickResult = await pickUseCase(source);

    String? path;
    bool cancelledOrFailed = false;
    String? pickErrorMessage;

    pickResult.when(
      onSuccess: (p) => path = p,
      onFailure: (failure) {
        cancelledOrFailed = true;
        if (failure is! PickCancelledFailure) pickErrorMessage = failure.message;
      },
    );

    if (cancelledOrFailed) {
      state = state.copyWith(isPickingImage: false, errorMessage: pickErrorMessage);
      return pickErrorMessage == null;
    }

    state = state.copyWith(
      isPickingImage: false,
      isUploadingAvatar: true,
      profile: state.profile.copyWith(avatarPath: path),
    );

    final uploadUseCase = _ref.read(uploadAvatarUseCaseProvider);
    final uploadResult = await uploadUseCase(path!);

    return uploadResult.when(
      onSuccess: (avatarUrl) {
        state = state.copyWith(
          isUploadingAvatar: false,
          profile: state.profile.copyWith(clearAvatarPath: true, avatarUrl: avatarUrl),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isUploadingAvatar: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> deleteAvatar() async {
    state = state.copyWith(isUploadingAvatar: true, clearError: true);
    final useCase = _ref.read(deleteAvatarUseCaseProvider);
    final result = await useCase();

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isUploadingAvatar: false,
          profile: state.profile.copyWith(clearAvatarPath: true, clearAvatarUrl: true),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isUploadingAvatar: false, errorMessage: failure.message);
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
