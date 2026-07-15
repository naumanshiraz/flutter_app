import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Data-layer shape of the onboarding profile. This is exactly the body
/// a real `POST /auth/signup` (or `/user/profile`) call will send once a
/// backend exists — building it now means `AuthRemoteDataSource` only
/// needs its mocked delay swapped for a real Dio call later.
@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    required String email,
    required String phone,
    required String name,
    DateTime? birthDate,
    String? gender,
    String? customGender,
    String? location,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromEntity(UserProfile entity) => UserProfileModel(
        email: entity.email,
        phone: entity.phone,
        name: entity.name,
        birthDate: entity.birthDate,
        gender: entity.gender?.name,
        customGender: entity.customGender,
        location: entity.location,
      );

  UserProfile toEntity() => UserProfile(
        email: email,
        phone: phone,
        name: name,
        birthDate: birthDate,
        gender: gender == null
            ? null
            : Gender.values.firstWhere(
                (g) => g.name == gender,
                orElse: () => Gender.other,
              ),
        customGender: customGender,
        location: location,
      );
}
